VIDEOKIT_HEX_FILE=softconsole/Videokit/Release/Videokit.hex
SPI_FILE=hex/spiflash.cfg

default_target: spi

HEX_FILES:=ascii_characters.hex \
	   firmware.hex \
	   scrfd_500m_bnkps.hex \
	   mobilefacenet-arcface.hex \
	   genderage.hex \
	   mobilenet-v2.hex \
	   lpd_eu_v42.hex \
	   lpr_eu_v3.hex \
	   ultralytics.yolov5n.relu.hex \
	   yolo-v4-tiny-tf.hex
HEX_FILES:=$(addprefix hex/,$(HEX_FILES))


$(SPI_FILE):
	mkdir -p hex
	wget https://github.com/Microchip-Vectorblox/VectorBlox-SDK/raw/release-v1.4.4/example/soc-video-c/frameDrawing/ascii_characters.hex
	wget https://github.com/Microchip-Vectorblox/VectorBlox-SDK/raw/release-v1.4.4/fw/firmware.hex
	mv ascii_characters.hex hex
	mv firmware.hex hex
	wget https://vector-blox-model-zoo.s3.us-west-2.amazonaws.com/Releases/ModelZoo/samples_V1000_1.4.4.zip
	unzip samples_V1000_1.4.4.zip
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/scrfd_500m_bnkps.vnnx hex/scrfd_500m_bnkps.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/mobilefacenet-arcface.vnnx hex/mobilefacenet-arcface.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/genderage.vnnx hex/genderage.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/mobilenet-v2.vnnx hex/mobilenet-v2.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/lpd_eu_v42.vnnx hex/lpd_eu_v42.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/lpr_eu_v3.vnnx hex/lpr_eu_v3.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/ultralytics.yolov5n.relu.vnnx hex/ultralytics.yolov5n.relu.hex
	objcopy -Ibinary -Oihex samples_V1000_1.4.4/yolo-v4-tiny-tf.vnnx hex/yolo-v4-tiny-tf.hex
	bash -c "python3 script_support/gen_spi_cfg.py -o $@ -d ../hex $(HEX_FILES)"


spi: $(SPI_FILE)
	bash -c "python3 script_support/set_model_size.py hex/spiflash.cfg softconsole/Videokit/main.c"
	make -C softconsole/Videokit/Release all

bitstream: $(VIDEOKIT_HEX_FILE)
	bash -c "libero script:MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl SCRIPT_ARGS:SYNTHESIZE+VERIFIY_TIMING+GENERATE_PROGRAMMING_DATA+EXPORT_FPE"

all: bitstream
.PHONY : all

ifeq (, $(shell which libero))
 $(error 'No libero in $$PATH')
endif
ifeq (, $(shell which riscv64-unknown-elf-gcc))
 $(error 'No riscv64-unknown-elf-gcc in $$PATH')
endif
