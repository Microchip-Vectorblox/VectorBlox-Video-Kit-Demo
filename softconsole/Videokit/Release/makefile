################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include warpAffine/subdir.mk
-include riscv_hal/subdir.mk
-include libfixmatrix/subdir.mk
-include libfixmath/subdir.mk
-include imageScaler/subdir.mk
-include hal/subdir.mk
-include frameDrawing/subdir.mk
-include drivers/vectorblox/subdir.mk
-include drivers/mt25ql01gbbb/subdir.mk
-include drivers/CoreUARTapb/subdir.mk
-include drivers/CoreSPI/subdir.mk
-include drivers/CoreI2C/subdir.mk
-include drivers/CoreGPIO/subdir.mk
-include application/sincos_funcs/subdir.mk
-include application/imx334_corei2c/subdir.mk
-include application/hdmi_config/subdir.mk
-include application/delay/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
Videokit.hex \

SECONDARY_SIZE += \
Videokit.siz \


# All Target
all: Videokit.elf secondary-outputs

# Tool invocations
Videokit.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU RISC-V Cross C Linker'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -T "../riscv_hal/microsemi-riscv-ram.ld" -nostartfiles -Xlinker --gc-sections -Wl,-Map,"Videokit.map" -o "Videokit.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

Videokit.hex: Videokit.elf
	@echo 'Invoking: GNU RISC-V Cross Create Flash Image'
	riscv64-unknown-elf-objcopy -O ihex --change-section-lma *-0x80000000 "Videokit.elf"  "Videokit.hex"
	@echo 'Finished building: $@'
	@echo ' '

Videokit.siz: Videokit.elf
	@echo 'Invoking: GNU RISC-V Cross Print Size'
	riscv64-unknown-elf-size --format=berkeley "Videokit.elf"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(SECONDARY_FLASH)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_UPPER_DEPS)$(C_DEPS) Videokit.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_SIZE)

.PHONY: all clean dependents

-include ../makefile.targets
