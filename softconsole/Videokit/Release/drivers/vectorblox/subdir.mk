################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../drivers/vectorblox/vbx_cnn_api.c \
../drivers/vectorblox/vbx_cnn_model.c 

OBJS += \
./drivers/vectorblox/vbx_cnn_api.o \
./drivers/vectorblox/vbx_cnn_model.o 

C_DEPS += \
./drivers/vectorblox/vbx_cnn_api.d \
./drivers/vectorblox/vbx_cnn_model.d 


# Each subdirectory must supply rules for building sources it contributes
drivers/vectorblox/%.o: ../drivers/vectorblox/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


