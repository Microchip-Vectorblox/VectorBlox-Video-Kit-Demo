.ONESHELL:
SHELL := /bin/bash
VIDEOKIT_HEX_FILE=softconsole/Videokit/Release/Videokit.hex
SPI_FILE=hex/spiflash.cfg

default_target: spi

HEX_FILES:=ascii_characters.hex \
	   mobilenet-v2.hex \
	   yolov8n_512x288_argmax.hex
HEX_FILES:=$(addprefix hex/,$(HEX_FILES))

# Prebuilt hex files for this release; includes a preconfigured hex/spiflash.cfg
HEX_ZIP=hex_V1000_3.2.zip
HEX_ZIP_URL=https://github.com/Microchip-Vectorblox/assets/releases/download/assets/$(HEX_ZIP)


$(SPI_FILE):
	set -e
	if [ ! -d hex ]; then
	wget $(HEX_ZIP_URL)
	unzip -o $(HEX_ZIP)
	rm -f $(HEX_ZIP)
	fi
	if [ ! -f $@ ]; then
	python3 script_support/gen_spi_cfg.py -o $@ -d ../hex $(HEX_FILES)
	fi
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