################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../drivers/mt25ql01gbbb/micron1gflash.c 

OBJS += \
./drivers/mt25ql01gbbb/micron1gflash.o 

C_DEPS += \
./drivers/mt25ql01gbbb/micron1gflash.d 


# Each subdirectory must supply rules for building sources it contributes
drivers/mt25ql01gbbb/%.o: ../drivers/mt25ql01gbbb/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


