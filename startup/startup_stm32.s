/**
  ******************************************************************************
  * @file      startup_stm32.s dedicated to STM32L011F3Px device
  * @author    Ac6
  * @version   V1.0.0
  * @date      2020-09-16
  ******************************************************************************
  */


.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

/**
 * @brief  This is the code that gets called when the processor first
 *          starts execution following a reset event. Only the absolutely
 *          necessary set is performed, after which the application
 *          supplied main() routine is called.
 * @param  None
 * @retval : None
*/

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit
  
/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler
/******************************************************************************
*
* The STM32L011F3Px vector table.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
   .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors


g_pfnVectors:
  .word _estack
  .word Reset_Handler
  .word NMI_Handler
  .word HardFault_Handler
  .word	0
  .word	0
  .word	0
  .word	0
  .word	0
  .word	0
  .word	0
  .word	SVC_Handler
  .word	0
  .word	0
  .word	PendSV_Handler
  .word	SysTick_Handler
  .word	WWDG_IRQHandler           			/* Window Watchdog interrupt                                                      */
  .word	PVD_IRQHandler            			/* PVD through EXTI line detection                                                */
  .word	RTC_IRQHandler            			/* RTC global interrupt                                                           */
  .word	FLASH_IRQHandler          			/* Flash global interrupt                                                         */
  .word	RCC_IRQHandler            			/* RCC global interrupt                                                           */
  .word	EXTI0_1_IRQHandler        			/* EXTI Line[1:0] interrupts                                                      */
  .word	EXTI2_3_IRQHandler        			/* EXTI Line[3:2] interrupts                                                      */
  .word	EXTI4_15_IRQHandler       			/* EXTI Line15 and EXTI4 interrupts                                               */
  .word	0                         			/* Reserved                                                                       */
  .word	DMA1_Channel1_IRQHandler  			/* DMA1 Channel1 global interrupt                                                 */
  .word	DMA1_Channel2_3_IRQHandler			/* DMA1 Channel2 and 3 interrupts                                                 */
  .word	DMA1_Channel4_7_IRQHandler			/* DMA1 Channel4 to 7 interrupts                                                  */
  .word	ADC_COMP_IRQHandler       			/* ADC and comparator 1 and 2                                                     */
  .word	LPTIM1_IRQHandler         			/* LPTIMER1 interrupt through EXTI29                                              */
  .word	USART4_USART5_IRQHandler  			/* USART4/USART5 global interrupt                                                 */
  .word	TIM2_IRQHandler           			/* TIM2 global interrupt                                                          */
  .word	TIM3_IRQHandler           			/* TIM3 global interrupt                                                          */
  .word	TIM6_IRQHandler           			/* TIM6 global interrupt and DAC                                                  */
  .word	TIM7_IRQHandler           			/* TIM7 global interrupt and DAC                                                  */
  .word	0                         			/* Reserved                                                                       */
  .word	TIM21_IRQHandler          			/* TIMER21 global interrupt                                                       */
  .word	I2C3_IRQHandler           			/* I2C3 global interrupt                                                          */
  .word	TIM22_IRQHandler          			/* TIMER22 global interrupt                                                       */
  .word	I2C1_IRQHandler           			/* I2C1 global interrupt                                                          */
  .word	I2C2_IRQHandler           			/* I2C2 global interrupt                                                          */
  .word	SPI1_IRQHandler           			/* SPI1_global_interrupt                                                          */
  .word	SPI2_IRQHandler           			/* SPI2 global interrupt                                                          */
  .word	USART1_IRQHandler         			/* USART1 global interrupt                                                        */
  .word	USART2_IRQHandler         			/* USART2 global interrupt                                                        */
  .word	AES_RNG_LPUART1_IRQHandler			/* AES global interrupt RNG global interrupt and LPUART1 global interrupt through */

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/

  	.weak	NMI_Handler
	.thumb_set NMI_Handler,Default_Handler

  	.weak	HardFault_Handler
	.thumb_set HardFault_Handler,Default_Handler

	.weak	SVC_Handler
	.thumb_set SVC_Handler,Default_Handler

	.weak	PendSV_Handler
	.thumb_set PendSV_Handler,Default_Handler

	.weak	SysTick_Handler
	.thumb_set SysTick_Handler,Default_Handler

	.weak	WWDG_IRQHandler
	.thumb_set WWDG_IRQHandler,Default_Handler
	
	.weak	PVD_IRQHandler
	.thumb_set PVD_IRQHandler,Default_Handler
	
	.weak	RTC_IRQHandler
	.thumb_set RTC_IRQHandler,Default_Handler
	
	.weak	FLASH_IRQHandler
	.thumb_set FLASH_IRQHandler,Default_Handler
	
	.weak	RCC_IRQHandler
	.thumb_set RCC_IRQHandler,Default_Handler
	
	.weak	EXTI0_1_IRQHandler
	.thumb_set EXTI0_1_IRQHandler,Default_Handler
	
	.weak	EXTI2_3_IRQHandler
	.thumb_set EXTI2_3_IRQHandler,Default_Handler
	
	.weak	EXTI4_15_IRQHandler
	.thumb_set EXTI4_15_IRQHandler,Default_Handler
	
	.weak	DMA1_Channel1_IRQHandler
	.thumb_set DMA1_Channel1_IRQHandler,Default_Handler
	
	.weak	DMA1_Channel2_3_IRQHandler
	.thumb_set DMA1_Channel2_3_IRQHandler,Default_Handler
	
	.weak	DMA1_Channel4_7_IRQHandler
	.thumb_set DMA1_Channel4_7_IRQHandler,Default_Handler
	
	.weak	ADC_COMP_IRQHandler
	.thumb_set ADC_COMP_IRQHandler,Default_Handler
	
	.weak	LPTIM1_IRQHandler
	.thumb_set LPTIM1_IRQHandler,Default_Handler
	
	.weak	USART4_USART5_IRQHandler
	.thumb_set USART4_USART5_IRQHandler,Default_Handler
	
	.weak	TIM2_IRQHandler
	.thumb_set TIM2_IRQHandler,Default_Handler
	
	.weak	TIM3_IRQHandler
	.thumb_set TIM3_IRQHandler,Default_Handler
	
	.weak	TIM6_IRQHandler
	.thumb_set TIM6_IRQHandler,Default_Handler
	
	.weak	TIM7_IRQHandler
	.thumb_set TIM7_IRQHandler,Default_Handler
	
	.weak	TIM21_IRQHandler
	.thumb_set TIM21_IRQHandler,Default_Handler
	
	.weak	I2C3_IRQHandler
	.thumb_set I2C3_IRQHandler,Default_Handler
	
	.weak	TIM22_IRQHandler
	.thumb_set TIM22_IRQHandler,Default_Handler
	
	.weak	I2C1_IRQHandler
	.thumb_set I2C1_IRQHandler,Default_Handler
	
	.weak	I2C2_IRQHandler
	.thumb_set I2C2_IRQHandler,Default_Handler
	
	.weak	SPI1_IRQHandler
	.thumb_set SPI1_IRQHandler,Default_Handler
	
	.weak	SPI2_IRQHandler
	.thumb_set SPI2_IRQHandler,Default_Handler
	
	.weak	USART1_IRQHandler
	.thumb_set USART1_IRQHandler,Default_Handler
	
	.weak	USART2_IRQHandler
	.thumb_set USART2_IRQHandler,Default_Handler
	
	.weak	AES_RNG_LPUART1_IRQHandler
	.thumb_set AES_RNG_LPUART1_IRQHandler,Default_Handler
	
	.weak	SystemInit

/************************ (C) COPYRIGHT Ac6 *****END OF FILE****/
