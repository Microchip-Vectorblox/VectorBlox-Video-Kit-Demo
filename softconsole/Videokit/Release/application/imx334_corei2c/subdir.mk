################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../application/imx334_corei2c/imx334_corei2c.c 

OBJS += \
./application/imx334_corei2c/imx334_corei2c.o 

C_DEPS += \
./application/imx334_corei2c/imx334_corei2c.d 


# Each subdirectory must supply rules for building sources it contributes
application/imx334_corei2c/%.o: ../application/imx334_corei2c/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


