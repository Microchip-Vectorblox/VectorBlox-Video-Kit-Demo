################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../libfixmatrix/fixarray.c \
../libfixmatrix/fixmatrix.c 

OBJS += \
./libfixmatrix/fixarray.o \
./libfixmatrix/fixmatrix.o 

C_DEPS += \
./libfixmatrix/fixarray.d \
./libfixmatrix/fixmatrix.d 


# Each subdirectory must supply rules for building sources it contributes
libfixmatrix/%.o: ../libfixmatrix/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


