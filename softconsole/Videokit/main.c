
/*******************************************************************************
 * (c) Copyright 2016-2017 Microsemi SoC Products Group. All rights reserved.
 *
 * This SoftConsole Video project for MIPI sensor configuration and interfacing with GUI
 *
 * Please refer README.TXT in the root folder of this project for more details.
 */
#include "riscv_hal/riscv_hal.h"
#include "drivers/CoreGPIO/core_gpio.h"
#include "drivers/CoreUARTapb/core_uart_apb.h"
#include "drivers/CoreI2C/core_i2c.h"
#include "drivers/CoreSPI/core_spi.h"
#include "drivers/mt25ql01gbbb/micron1gflash.h"
#include "drivers/vectorblox/vbx_cnn_api.h"
#include "hal/hal.h"
#include "application/imx334_corei2c/imx334_corei2c.h"
#include "application/hdmi_config/hdmi_tx.h"
#include "frameDrawing/draw_assist.h"
#include "frameDrawing/draw.h"
#include <stdio.h>
#include "model_descr.h"
#include "recognitionDemo.h"
#include "detectionDemo.h"
#include "imageScaler/scaler.h"

#define LED1 GPIO_0
#define LED2 GPIO_1
#define LED3 GPIO_2
#define LED4 GPIO_3

#define MIPI_TRNG_RST GPIO_4

#define SW1_MASK GPIO_10_MASK
#define SW2_MASK GPIO_11_MASK
#define USE_CAMERA_MASK GPIO_16_MASK
#define MODEL_SW_MASK   0x00001000UL

#define DDR_READ_FRAME_START_ADDR 0x7F009108

const int CLASSIFIER_FPS = 10;
const int CAMERA_FPS = 30;
const int HDMI_FPS = 55;
int frame_rate;


// Specify the Models in the SPI Flash and their Start Addresses
struct model_descr_t models[] = {
{"SCRFD","",0x3f4020, "SCRFD"},
{"ArcFace","",0x67b540, "ARCFACE"},
{"GenderAge","",0x7a4338, "GENDERAGE"},
{"LPD","",0x108ff78, "LPD"},
{"LPR","",0x164b8c8, "LPR"},
{"MobileNet V2","",0x806668, "IMAGENET"},
{"Yolo V5 Nano","",0x1939b80, "YOLOV5"},
{"Tiny Yolo V4 COCO","",0x1fce230, "YOLOV4"},
};

vbx_cnn_t* vbx_cnn;
short demo_setup = 0;
int use_attribute_model = 0;  // run genderage attributes along w/ face detector + face recognition
int fps = 0;
uint16_t modelSwIn;
uint32_t switch_debounce_time = 500; // 0.5 second
uint32_t last_sw1_check;
uint32_t last_sw2_check;
uint16_t modelsIndex = 0;
int update_Classifier = 1;


const char *errorMsgs[11] = {
	"NO ERRORS",
	"INVALID FIRMWARE ADDRESS",
	"FIRMWARE ADDRESS NOT READY",
	"START NOT CLEAR",
	"OUTPUT VALID NOT SET",
	"FIRMWARE BLOB VERSION MISMATCH",
	"INVALID NETWORK ADDRESS",
	"MODEL INVALID",
	"MODEL VERSION MISMATCH",
	"MODEL SIZE CONFIGURATION MISMATCH",
	"FIRMWARE BLOB STALE"
};
uint32_t * volatile * const WARP_BASE_ADDRESS = (uint32_t* volatile * const)0x7F040000;
uint32_t * volatile * const SCALER_BASE_ADDRESS = (uint32_t* volatile * const)0x7F030000;
uint32_t * volatile * const PROCESSING_FRAME_ADDRESS = (uint32_t * volatile * const)0x7F009110;
uint32_t * volatile * const PROCESSING_NEXT_FRAME_ADDRESS = (uint32_t * volatile * const)0x7F009114;
uint32_t * volatile * const PROCESSING_NEXT2_FRAME_ADDRESS = (uint32_t * volatile * const)0x7F009118;

volatile uint32_t * const SAVED_FRAME_SWAP = (volatile uint32_t * const )0x7F009110;
volatile void *draw_assist_base_address =(volatile void*)0x7F020000;

const int CHAR_SPI_OFFSET = 0x589a0;

void camera_adjust();

volatile uint32_t g_10ms_count;

volatile uint32_t timerdone = 0;
volatile uint32_t g_10ms_count1;
volatile uint32_t g_ms_count;
volatile uint32_t tick_counter;
i2c_instance_t g_i2c_instance_hdmi;
i2c_instance_t g_i2c_instance_cam1;
i2c_instance_t g_i2c_instance_cam2;
/*-----------------------------------------------------------------------------
 * GPIO instance data.
 */

gpio_instance_t g_gpio_out;

/*-----------------------------------------------------------------------------
 * Global state counter.
 */
uint32_t g_state = 1;

volatile uint32_t rx_tmr_done = 0;
volatile uint32_t rx_ms_count1;
volatile uint32_t rx_ms_count;
uint32_t t_ms_count = 0;

uint32_t* loop_draw_frame;

uint32_t* swap_draw_frame(){

    draw_wait_for_draw();
    *SAVED_FRAME_SWAP=1;

    return *PROCESSING_FRAME_ADDRESS;
}
/*-----------------------------------------------------------------------------
 * System Tick interrupt handler
 */
void SysTick_Handler(void) {

    g_state = (~g_state) & 0x01;
    tick_counter ++;
    if(timerdone == 1){
        g_10ms_count1 += 1;
        if(g_ms_count <= g_10ms_count1)
            timerdone = 0;
    }

    if(rx_tmr_done == 1){
        rx_ms_count1 += 1;
        if(rx_ms_count1 >= rx_ms_count){
            rx_tmr_done = 0;
        }
    }
}

void External_30_IRQHandler(void) {

    I2C_isr(&g_i2c_instance_cam2);
}

void External_29_IRQHandler(void) {

    I2C_isr(&g_i2c_instance_cam1);
}

void External_28_IRQHandler(void) {

    I2C_isr(&g_i2c_instance_hdmi);
}

void External_27_IRQHandler(void) {
	vbx_cnn_model_isr(vbx_cnn);
}

void msdelay(uint32_t tms);
void copy_from_flash(const char* name,void* target,uint32_t flash_offset,size_t len);

uint8_t* ddr_begin = (uint8_t*)0x60000000;
uint8_t* ddr_ptr = (uint8_t*)0x60000000;
uint8_t* ddr_end = (uint8_t*)0x76FFFFFF;


void* ddr_uncached_allocate(size_t size){
    int boundary = 4096;
    size_t padded_request = (size+boundary-1)/boundary*boundary;
    if(ddr_ptr + padded_request > ddr_end){
        printf("ERROR:UNABLE TO ALLOCATE\n");
        while(1);
        return NULL;
    }
    void* ret = ddr_ptr;
    ddr_ptr += padded_request;
    printf("ddr_ptr = %08x\n",ddr_ptr);
    return ret;
}

uint8_t* cached_ddr_begin = (uint8_t*)0x88000000;
uint8_t* cached_ddr_ptr = (uint8_t*)0x88000000;
uint8_t* cached_ddr_end = (uint8_t*)0x8FFFFFFF;
void* ddr_cached_allocate(size_t size){
    int boundary = 4096;
    size_t padded_request = (size+boundary-1)/boundary*boundary;
    if(cached_ddr_ptr + padded_request > cached_ddr_end){
    	printf("ERROR:UNABLE TO ALLOCATE\n");
        while(1);
        return NULL;
    }
    void* ret = cached_ddr_ptr;
    cached_ddr_ptr += padded_request;
    printf("ddr_ptr = %08x\n",cached_ddr_ptr);
    return ret;
}

model_t *setup_model(uint32_t spi_offset,const char* name){
    char stack_space[512];
    model_t* model =(model_t*)stack_space;
    //512 bytes is enough to query size of model
    copy_from_flash(name,model,spi_offset,sizeof(stack_space));
    if(model_check_sanity(model) != 0) {
    	printf("ERROR: %s %s\n", name, errorMsgs[8]);
    	uint32_t *draw=swap_draw_frame();
    	char label[128];
    	snprintf(label,sizeof(label),"Error: %s %s", name, errorMsgs[8]);
    	draw_label(label,34,34,
    	           draw,2048,1080,WHITE);
    	draw=swap_draw_frame();
        return NULL;
    }
    size_t allocate_size = model_get_allocate_bytes(model);
    //pad to multiple of 512 bytes
    allocate_size = (allocate_size + 511) /512 * 512;
    size_t data_size = model_get_data_bytes(model);
    model = ddr_uncached_allocate(allocate_size);
    unsigned start = tick_counter;
    copy_from_flash(name,model,spi_offset,data_size);
    return model;
}
char* orca_std_out;

void uart_putc(char c){
    volatile uint32_t* txdata = (volatile uint32_t*) COREUARTAPB0_BASE_ADDR + 0x0;
    volatile uint32_t* status = (volatile uint32_t*) (COREUARTAPB0_BASE_ADDR + 0x10);
    while(((*status)&1) != 1);
    *txdata=c;
}

void tpf_putc(void* _ ,char c){
    uart_putc(c);

}

uint8_t switchModels() {
	uint32_t *draw;
	int32_t last_menu_draw = tick_counter-switch_debounce_time;
	char label[128];

	while(1) {
		if (!(GPIO_get_inputs(&g_gpio_out) & SW1_MASK) &&
	    	 (tick_counter - last_sw1_check > switch_debounce_time)) {
			last_sw1_check = tick_counter;
			break;
		}

		snprintf(label, sizeof(label),"Menu:");
		draw_label(label,500,100,draw,2048,1080,WHITE);
		snprintf(label, sizeof(label),"Models List:");
		draw_label(label,500,150,draw,2048,1080,WHITE);
		uint8_t y = 0;
		for(int i = 0; i < (sizeof(models)/sizeof(*models)); i++) {
			if (!strcmp(models[i].post_process_type, "RETINAFACE")) {
				snprintf(label, sizeof(label),"%d. Retinaface Face Demo", y+1);
				if(modelsIndex == i) {
					draw_label(label,500,200+(y*50),draw,2048,1080,RED);
				}
				else {
					draw_label(label,500,200+(y*50),draw,2048,1080,WHITE);
				}
                i+=2;
			}

			else if (!strcmp(models[i].post_process_type, "SCRFD")) {
				snprintf(label, sizeof(label),"%d. SCRFD Face Demo", y+1);
				if (modelsIndex == i) {
					draw_label(label,500,200+(y*50),draw,2048,1080,RED);
				}
				else {
					draw_label(label,500,200+(y*50),draw,2048,1080,WHITE);
				}
                i+=2;
			}

			//lpr demo
			else if (!strcmp(models[i].post_process_type, "LPD")){
				snprintf(label, sizeof(label),"%d. License Plate Demo", y+1);
				if(modelsIndex == i) {
					draw_label(label,500,200+(y*50),draw,2048,1080,RED);
				}
				else {
					draw_label(label,500,200+(y*50),draw,2048,1080,WHITE);
				}
				i+=1;
			}
			else {
				snprintf(label, sizeof(label),"%d. %s Model", y+1, models[i].name);
				if (modelsIndex == i) {
					draw_label(label,500,200+(y*50),draw,2048,1080,RED);
				}
				else {
					draw_label(label,500,200+(y*50),draw,2048,1080,WHITE);
				}
			}
			y++;
		}
		if (tick_counter-last_menu_draw > 1000/frame_rate) {
			draw = swap_draw_frame();
			last_menu_draw = tick_counter;
		}
		if (!(GPIO_get_inputs(&g_gpio_out) & SW2_MASK) &&
	    	 (tick_counter - last_sw2_check > switch_debounce_time)) {
			last_sw2_check = tick_counter;
			if (modelsIndex >= (sizeof(models)/sizeof(*models))-1) {
				modelsIndex = 0;
			}

			//check for License Plate Detect/Recog
			else if (!strcmp(models[modelsIndex].post_process_type, "LPD")){
				trackClean(models,modelsIndex+1);
				if(modelsIndex == (sizeof(models)/sizeof(*models))-2) modelsIndex = 0;
				else modelsIndex +=2;
			}
			//end LP check


			else if (!strcmp(models[modelsIndex].post_process_type, "RETINAFACE") || !strcmp(models[modelsIndex].post_process_type, "SCRFD")) {
				trackClean(models,modelsIndex+1);
				if (modelsIndex == (sizeof(models)/sizeof(*models))-3) modelsIndex = 0;
				// followed by invisible faceReg+gernderage,, so needs to be set to beginning if 2nd to last in models_struct
                else modelsIndex += 3;

			}
			else {
				modelsIndex++;
			}
		}
 	}
	return modelsIndex;
}

void vbx_setup() {
    printf("\n\n\nStarting vbx setup\n");
    uint32_t firmware_flash_offset = 0x1f4020;
    size_t firmware_size = 2*1024*1024;
    void* firmware_blob = ddr_uncached_allocate(firmware_size);
    if((uintptr_t)firmware_blob & (firmware_size-1)) {
        //not aligned, make it aligned
        size_t move_forward = firmware_size - ((uintptr_t)firmware_blob&(firmware_size-1));
        firmware_blob = (void*)((uintptr_t)firmware_blob+move_forward);
        ddr_uncached_allocate(move_forward);
    }
    printf("firmware_blob = %p\n",firmware_blob);
    orca_std_out = (char*)firmware_blob +firmware_size - 16*1024;
    copy_from_flash("Firmware",firmware_blob,firmware_flash_offset,firmware_size);
    vbx_cnn = vbx_cnn_init((void*)COREVBX_BASE_ADDR,(void*)firmware_blob);
    if(!vbx_cnn) {
        printf("Unable to initialize the vbx_cnn.\n",firmware_blob);
        printf("Perhaps the firmware did not load from spi flash correctly\n");
        abort();
    }
}

int isRecog(int index){
	if(!strcmp(models[index].post_process_type, "RETINAFACE") || !strcmp(models[index].post_process_type, "SCRFD") || !strcmp(models[index].post_process_type, "LPD")){
		return true;
	}
	else return false;

}

int main(int argc, char **argv) {
    char label[256];
    uint8_t manufacturer_id1;
    uint8_t device_id1;
    uint32_t data_size= 0;

    // Initialize Flash
    FLASH_init();
    FLASH_set_clk_div(2);
    FLASH_read_device_id (&manufacturer_id1, &device_id1);
    data_size = 0x01589380;

    // Initialize GPIOs and interrupt handlers
    GPIO_init(&g_gpio_out, COREGPIO_OUT_BASE_ADDR, GPIO_APB_32_BITS_BUS);
    GPIO_set_output(&g_gpio_out, LED1, 1);
    PLIC_init();

    // Timer to generate Interrupts
    SysTick_Config(100000000 / 1000);

    // Interrupt Handlers
    PLIC_SetPriority(I2C_CAM1_IRQn, 1);
    PLIC_EnableIRQ(I2C_CAM1_IRQn);
    PLIC_SetPriority(HDMI_I2C_IRQn, 1);
    PLIC_EnableIRQ(HDMI_I2C_IRQn);
    PLIC_SetPriority(I2C_CAM2_IRQn, 1);
    PLIC_EnableIRQ(I2C_CAM2_IRQn);
	HAL_enable_interrupts();

    // Setup GPIOs
    GPIO_set_output(&g_gpio_out, MIPI_TRNG_RST, 0u);
    GPIO_set_output(&g_gpio_out, LED2, 1);
    HDMI_tx_init();
    GPIO_set_output(&g_gpio_out, CAM1_RST, 1u);
    GPIO_set_output(&g_gpio_out, CAM2_RST, 1u);
    GPIO_set_output(&g_gpio_out, CAM_CLK_EN, 0u);
    imx334_cam_init();
    imx334_cam_reginit(1u);
    GPIO_set_output(&g_gpio_out, LED3, 1);
    msdelay(1000);
    GPIO_set_output(&g_gpio_out, MIPI_TRNG_RST, 1u);
    GPIO_set_output(&g_gpio_out, LED4, 1);
    GPIO_set_output(&g_gpio_out, GPIO_5, 1);

    //calibrate image brightness
    uint32_t camera_adjust_time=60*1000*5;//5 minutes
    uint32_t last_camera_check = tick_counter-camera_adjust_time;//5 minutes ago
    if((GPIO_get_inputs(&g_gpio_out)& USE_CAMERA_MASK)){
    	frame_rate = CAMERA_FPS;
    	camera_adjust();
    	last_camera_check=tick_counter;
    }
    else{
        frame_rate = HDMI_FPS;
    }

    last_sw1_check = tick_counter-switch_debounce_time; //1 second ago
    last_sw2_check = tick_counter-switch_debounce_time; //1 second ago

    // Setup the firmware and Models needed for the Demos
    vbx_setup();
    loop_draw_frame = swap_draw_frame();


    for(int i = 0; i < 8; i++) {
    	if(models[i].modelSetup_done != 1) {
    		printf("Setting up model '%s'\n",models[i].name);
    		models[i].model = setup_model(models[i].spi_offset,models[i].name);
    		model_t* model = models[i].model;
    		if(model == NULL){
    			printf("ERROR: %s does not appear as valid model\n",models[i].name);
    			while(1);
    		}
    		if(model_check_sanity(model) != 0) {
    			printf("Model %s is not sane\n", models[i].name);
    		}
    		models[i].modelSetup_done = 1;
    	}
    }

    //Initialize all demos

    demo_setup = recognitionDemoInit(vbx_cnn,models, 0,1, 1080, 1920,0,0);
    if (demo_setup < 0) {
    	printf("faceDemoSetup error: %d\n", demo_setup);
    	while(1);
    }
    tracksInit(models+1);
    demo_setup = recognitionDemoInit(vbx_cnn,models, 3, 0, 540, 1920, 540, 0);
    if (demo_setup < 0) {
    	printf("plateDemoSetup error: %d\n", demo_setup);
    	while(1);
    }
    for (int i = 0; i < 3; i++) {
    	demo_setup = detectionDemoInit(vbx_cnn, models, 5+i);
    	if (demo_setup < 0) {
    		printf("detectionDemoSetup error: %d\n", demo_setup);
    		while(1);
    	}
    }

    //Main Loop
    int mode = 0;
    if(!strcmp(models[mode].post_process_type, "RETINAFACE") || !strcmp(models[mode].post_process_type, "SCRFD") || !strcmp(models[mode].post_process_type, "LPD"))
    	PLIC_DisableIRQ(External_27_IRQn);
    else{
    	PLIC_SetPriority(External_27_IRQn, 1);
    	PLIC_EnableIRQ(External_27_IRQn);
    }
    uint32_t tv1,tv2,prev_timestamp;
	prev_timestamp = tick_counter;
    while (1) {
     	// Control for swapping to next model
    	if (!(GPIO_get_inputs(&g_gpio_out) & SW1_MASK) &&
    	     (tick_counter - last_sw1_check > switch_debounce_time)) {
			PLIC_DisableIRQ(External_27_IRQn);

    		while (vbx_cnn_model_poll(vbx_cnn) > 0);
    		
    		

    		//wait for scale of frame to complete before switch
    		resize_image_hls_wait(HLS_SCALER_BASE_ADDRESS);
    		last_sw1_check = tick_counter;
			mode = switchModels();

    		if(isRecog(mode)==0){  //Enable interrupts for detection based models
    			PLIC_SetPriority(External_27_IRQn, 1);
    			PLIC_EnableIRQ(External_27_IRQn);
    		}

    		models[mode].is_running = 0;
    	}

    	// Control for adjusting frame rate for MIPI camera device, and brightness of the camera
        if((GPIO_get_inputs(&g_gpio_out) & USE_CAMERA_MASK) ) {
            frame_rate = CAMERA_FPS;
            if( (tick_counter - last_camera_check) > camera_adjust_time){
                // Adjust Brightness of the Camera
                camera_adjust();
                last_camera_check = tick_counter;
            }
        }
        // Control for adjusting frame rate for HDMI input
        else{
            frame_rate = HDMI_FPS;
        }

        // Controls whether to include genderage in faceDemo
    	if (!(GPIO_get_inputs(&g_gpio_out) & SW2_MASK) &&
    	     (tick_counter - last_sw2_check > switch_debounce_time) &&
             (!strcmp(models[mode].post_process_type, "RETINAFACE") || !strcmp(models[mode].post_process_type, "SCRFD"))) {
    		last_sw2_check = tick_counter;
    		use_attribute_model = !use_attribute_model;

    	}
    	tv1 = tick_counter;
       	short status = 1;
    	while(status > 0){
			if (!strcmp(models[mode].post_process_type, "RETINAFACE") || !strcmp(models[mode].post_process_type, "SCRFD")) {
				// Run Face Demo
				status = runRecognitionDemo(models, vbx_cnn, mode,use_attribute_model, 1080, 1920,0,0);
			}
			else if (!strcmp(models[mode].post_process_type, "LPD")) {
				//Run Plate Demo
				status = runRecognitionDemo(models, vbx_cnn, mode, 0, 540, 1920, 540, 0);
			}
			else {
				// Run Object Demo
				status = runDetectionDemo(models, vbx_cnn, mode);
			}
    	}
    	if (status < 0){
    		printf("Error running mode %s \n",models[mode].name);
    		printf("control_reg = %x \n",vbx_cnn->ctrl_reg[0]);
    		printf("status: %d",status);
			printf("error code: %d",vbx_cnn_get_error_val(vbx_cnn));												  
    		printf("state = %d\n",vbx_cnn_get_state(vbx_cnn));
    	}
    	if((tick_counter-prev_timestamp)>1500/CLASSIFIER_FPS){
    		update_Classifier = 1;
    		prev_timestamp = tick_counter;
    	}
    	else{
    		update_Classifier = 0;
		}
        while((tick_counter - tv1) < (1000/frame_rate));
    	tv2 = tick_counter;
    	fps = 1000/(tv2 - tv1);
    	loop_draw_frame = swap_draw_frame();

    }

    return 0;
}


// spi_flash read
#define FLASH_COPY_PROGRESS 1
void copy_from_flash(const char* name, void* target,uint32_t flash_offset,size_t len){
    static void* uncached_tmp=0;
    int tx_size = 32*1024;
    int i;
    int verbose = FLASH_COPY_PROGRESS && len>512;
    uint32_t *draw=swap_draw_frame();
    char label[128];
    if(verbose)
        printf("copying from flash %x\n",flash_offset);

    for (i = 0;i<len ;i+=tx_size){
        if(verbose && (!(i & 0xFFFF)) ){
            printf("%dKB/%dKB\r",i>>10,len>>10);
            if(name){
                snprintf(label,sizeof(label),"Copying %s from flash %dKB/%dKB",name,i>>10,len>>10);
                draw_label(label,34,34,
                           draw,2048,1080,WHITE);
                draw=swap_draw_frame();
            }
        }
        if(i+tx_size > len){
            tx_size = len -i;
        }
        FLASH_read(flash_offset+i,((uint8_t*)target) +i,tx_size);
    }
    if(verbose) {
        printf("%dKB/%dKB\n",i>>10,len>>10);
        snprintf(label,sizeof(label),"Copying %s from flash %dKB/%dKB",name,i>>10,len>>10);
        draw_label(label,34,34,
        		   draw,2048,1080,WHITE);
        draw=swap_draw_frame();
    }
}
