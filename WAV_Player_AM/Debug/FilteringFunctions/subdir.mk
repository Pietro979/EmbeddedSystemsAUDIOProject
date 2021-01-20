################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../FilteringFunctions/arm_fir_init_q31.c \
../FilteringFunctions/arm_fir_q31.c 

OBJS += \
./FilteringFunctions/arm_fir_init_q31.o \
./FilteringFunctions/arm_fir_q31.o 

C_DEPS += \
./FilteringFunctions/arm_fir_init_q31.d \
./FilteringFunctions/arm_fir_q31.d 


# Each subdirectory must supply rules for building sources it contributes
FilteringFunctions/arm_fir_init_q31.o: ../FilteringFunctions/arm_fir_init_q31.c
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DUSE_HAL_DRIVER -DDEBUG -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../FATFS/Target -I../FATFS/App -I../USB_HOST/App -I../USB_HOST/Target -I../Middlewares/Third_Party/FatFs/src -I../Middlewares/ST/STM32_USB_Host_Library/Core/Inc -I../Middlewares/ST/STM32_USB_Host_Library/Class/MSC/Inc -I../Audio -I"C:/Users/adria/OneDrive/Pulpit/Nowy folder/WAV_Player/FilteringFunctions" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"FilteringFunctions/arm_fir_init_q31.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
FilteringFunctions/arm_fir_q31.o: ../FilteringFunctions/arm_fir_q31.c
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DUSE_HAL_DRIVER -DDEBUG -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../FATFS/Target -I../FATFS/App -I../USB_HOST/App -I../USB_HOST/Target -I../Middlewares/Third_Party/FatFs/src -I../Middlewares/ST/STM32_USB_Host_Library/Core/Inc -I../Middlewares/ST/STM32_USB_Host_Library/Class/MSC/Inc -I../Audio -I"C:/Users/adria/OneDrive/Pulpit/Nowy folder/WAV_Player/FilteringFunctions" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"FilteringFunctions/arm_fir_q31.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

