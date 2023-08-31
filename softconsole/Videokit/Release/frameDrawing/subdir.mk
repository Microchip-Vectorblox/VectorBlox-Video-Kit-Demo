################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../frameDrawing/ascii_characters.c \
../frameDrawing/draw.c \
../frameDrawing/draw_assist.c 

OBJS += \
./frameDrawing/ascii_characters.o \
./frameDrawing/draw.o \
./frameDrawing/draw_assist.o 

C_DEPS += \
./frameDrawing/ascii_characters.d \
./frameDrawing/draw.d \
./frameDrawing/draw_assist.d 


# Each subdirectory must supply rules for building sources it contributes
frameDrawing/%.o: ../frameDrawing/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


