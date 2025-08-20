################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../cam_adjust.c \
../detectionDemo.c \
../main.c \
../postprocess.c \
../postprocess_license_plate.c \
../postprocess_pose.c \
../postprocess_retinaface.c \
../postprocess_scrfd.c \
../postprocess_ssd.c \
../recognitionDemo.c \
../tracking.c 

OBJS += \
./cam_adjust.o \
./detectionDemo.o \
./main.o \
./postprocess.o \
./postprocess_license_plate.o \
./postprocess_pose.o \
./postprocess_retinaface.o \
./postprocess_scrfd.o \
./postprocess_ssd.o \
./recognitionDemo.o \
./tracking.o 

C_DEPS += \
./cam_adjust.d \
./detectionDemo.d \
./main.d \
./postprocess.d \
./postprocess_license_plate.d \
./postprocess_pose.d \
./postprocess_retinaface.d \
./postprocess_scrfd.d \
./postprocess_ssd.d \
./recognitionDemo.d \
./tracking.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g -I"../drivers/vectorblox/" -I"../libfixmath/" -I"../libfixmatrix/" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


