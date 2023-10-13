#include <stdint.h>
#include <stdio.h>

unsigned char UART_RxChar();
void UART_TxChar(uint8_t ch);
void UART_SendString(uint8_t *str, uint8_t length);
void UART_SendString2(uint8_t *str);