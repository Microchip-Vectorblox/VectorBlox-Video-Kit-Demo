#define R_CONST_ADDR        0x7F009004
#define G_CONST_ADDR        0x7F009008
#define B_CONST_ADDR        0x7F00900C
#define SECOND_CONST_ADDR   0x7F009010
#define CONTRAST_ADDR       0x7F009030
#define BRIGHTNESS_ADDR     0x7F009034
#define RED_MEAN_ADDR       0x7F009080
#define GREEN_MEAN_ADDR     0x7F009084
#define BLUE_MEAN_ADDR      0x7F009088
#define RED_VAR_ADDR        0x7F00908C
#define GREEN_VAR_ADDR      0x7F009100
#define BLUE_VAR_ADDR       0x7F009104
#include <stdint.h>
#include "application/imx334_corei2c/imx334_corei2c.h"
uint32_t* swap_draw_frame();
typedef struct pid_state_s{
	int target;
	float prop_gain;
	float diff_gain;
	float int_gain;
	int integral;
	int last_error;
}pid_state_t;

int pid(pid_state_t* state,int in){
	int err= in - state->target ;
	int diff = err - state->last_error ;
	state->integral += err;
	state->last_error = err;
	int out = err*state->prop_gain + diff*state->diff_gain+state->integral*state->int_gain;
	return out;
}
static void set_cam_shutter(uint32_t shutter){
	sensor_i2c_write(1,0x3058, shutter&0xFF);
	shutter>>=8;
	sensor_i2c_write(1,0x3059, shutter&0xFF);
	shutter>>=8;
	sensor_i2c_write(1,0x305A, shutter&0xF);

}

static void set_bgr_gain(int r_gain ,int g_gain,int b_gain,int brightness,int contrast){
	//contrast = *(volatile int*) CONTRAST_ADDR;//8;//Range 3 - 30 (divided by 10 in later steps)
	//brightness = *(volatile int*) BRIGHTNESS_ADDR;
	//int brightness = 0x80;
	int contrast_scl = (325*(contrast+128) / (387 - contrast))>>5u;
	int r_const = (r_gain * contrast_scl)/10;
	int b_const = (b_gain * contrast_scl)/10;
	int g_const = (g_gain * contrast_scl/10);
	int second_const = 128 * (brightness - ((128*contrast_scl)/10));

	*(volatile int*) R_CONST_ADDR = r_const;
	*(volatile int*) G_CONST_ADDR = g_const;
	*(volatile int*) B_CONST_ADDR = b_const;
	*(volatile int*) SECOND_CONST_ADDR = second_const;
}
static int get_avg_brightness(void){
	int r = *((volatile uint32_t*)RED_MEAN_ADDR);
	int g = *((volatile uint32_t*)GREEN_MEAN_ADDR);
	int b = *((volatile uint32_t*)BLUE_MEAN_ADDR);
	return (r+g+b)/3;
}
static int get_variance(void){
	int r = *((volatile uint32_t*)RED_VAR_ADDR);
	int g = *((volatile uint32_t*)GREEN_VAR_ADDR);
	int b = *((volatile uint32_t*)BLUE_VAR_ADDR);
	return ((r+g+b)/3);
}
void msdelay(uint32_t tms);


static int adjust_camera_shutter(int brightness_target,int current_shutter){

	return current_shutter;
}
void camera_adjust(){

	static int current_shutter    = 5;
	static int current_brightness = 0x7f;
	static int current_contrast   = 0x60;

	const int r_gain = 0xF0;
	const int g_gain = 0x90;
	const int b_gain = 0xFF;
	const int capture_delay= 1000/14;
	static int brightness_target = 128;
	static int variance_target = 40;


	const int max_shutter = 0x08C9;
	const int min_shutter = 0x0005;
	set_cam_shutter(current_shutter);
	set_bgr_gain(r_gain, g_gain, b_gain, current_brightness, current_contrast);

	int mean;
	int var;

	int run=0;
	int saturation_count =0;
	static pid_state_t shutter_state = {
			//.target=brightness_target,
			.prop_gain=0.1,
			.diff_gain=0.1,
			.int_gain=0.2,
			.integral=0,
			.last_error=0,
	};
	shutter_state.target=brightness_target;
	while(1 ){
        msdelay(capture_delay);
        swap_draw_frame();
		mean = get_avg_brightness();
		if((mean > (brightness_target-2) && (mean <(brightness_target+2))) || saturation_count>3){
			break;
		}
		current_shutter = pid(&shutter_state,mean);
		if(current_shutter>max_shutter){
				current_shutter=max_shutter;
				saturation_count++;
		}else if(current_shutter<min_shutter){
				current_shutter = min_shutter;
				saturation_count++;
		}
		set_cam_shutter(current_shutter);
	}
	static pid_state_t brightness_state = {
				//.target=brightness_target,
				.prop_gain=-0.1,
				.diff_gain=-0.1,
				.int_gain=-0.1,
				.integral=0,
				.last_error=0,
		};
	static pid_state_t contrast_state = {
				.prop_gain=-0.1,
				.diff_gain=-0.1,
				.int_gain=-0.2,
				.integral=0,
				.last_error=0,
		};
	brightness_state.target=brightness_target;
	contrast_state.target = variance_target;
	brightness_state.integral = current_brightness/brightness_state.int_gain;
	contrast_state.integral = current_contrast/contrast_state.int_gain;
	int mean_saturation_count = 0;
	int var_saturation_count =0;

	while(1){
		msdelay(capture_delay);
        swap_draw_frame();
		mean = get_avg_brightness();
		var = get_variance();

		if((mean > (brightness_target-2) && mean <(brightness_target+2) || mean_saturation_count>3 )&&
			(var > (variance_target-2) && var < (variance_target+2) || var_saturation_count>3)){
			break;
		}
		current_brightness = pid(&brightness_state,mean);
		if(current_brightness>0x7FF){
			current_brightness=0x7FF;
			mean_saturation_count++;
		}
		current_contrast = pid(&contrast_state,var);
		if(current_contrast>255){
			current_contrast=255;
			var_saturation_count++;
		}
		set_bgr_gain(r_gain, g_gain, b_gain, current_brightness, current_contrast);
	}

}
