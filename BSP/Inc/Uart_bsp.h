/**
  ******************************************************************************
  * @file    Uart_bsp.h
  * @author  MCD Application Team
  * @brief   Header file of ADC HAL extended module.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright(c) 2016 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __UART_BSP_H
#define __UART_BSP_H
#ifdef __cplusplus
 extern "C" {
#endif
#include "stm32l0xx_ammeter.h"
InitStatus BSP_UART_Init(void);
void BSP_UART_Write(uint8_t *pData, uint16_t Size);
#ifdef __cplusplus
}
#endif /*  */
#endif
