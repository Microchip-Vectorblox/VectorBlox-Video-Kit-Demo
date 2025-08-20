.ONESHELL:
SHELL := /bin/bash
VIDEOKIT_HEX_FILE=softconsole/Videokit/Release/Videokit.hex
SPI_FILE=hex/spiflash.cfg

default_target: spi

HEX_FILES:=ascii_characters.hex \
	   mobilenet-v2.hex \
	   yolov8n_512x288_argmax.hex
HEX_FILES:=$(addprefix hex/,$(HEX_FILES))


$(SPI_FILE):
	if [ ! -d hex ]; then
	mkdir -p hex
	wget https://github.com/Microchip-Vectorblox/VectorBlox-SDK/raw/release-v1.4.4/example/soc-video-c/frameDrawing/ascii_characters.hex
	mv ascii_characters.hex hex
	wget https://vector-blox-model-zoo.s3.us-west-2.amazonaws.com/Releases/ModelZoo/hex_V1000_2.0.3.zip
	unzip hex_V1000_2.0.3.zip
	mv hex/yolov8n_512x288_argmax.hex
	mv hex/mobilenet-v2.hex hex
	fi
	bash -c "python3 script_support/gen_spi_cfg.py -o $@ -d ../hex $(HEX_FILES)"
spi: $(SPI_FILE)
	bash -c "python3 script_support/set_model_size.py hex/spiflash.cfg softconsole/Videokit/main.c"
	

bitstream:
	make -C softconsole/Videokit/Release all
	bash -c "libero script:MPF_VIDEO_KIT_VECTORBLOX_DESIGN.tcl SCRIPT_ARGS:SYNTHESIZE+VERIFIY_TIMING+GENERATE_PROGRAMMING_DATA+EXPORT_FPE"

all: bitstream
.PHONY : all
ifeq (,$(shell grep -i Microsoft /proc/version))
 ifeq (, $(shell which libero))
  $(error 'No libero in $$PATH')
 endif
 ifeq (, $(shell which riscv64-unknown-elf-gcc))
  $(error 'No riscv64-unknown-elf-gcc in $$PATH')
 endif
endif