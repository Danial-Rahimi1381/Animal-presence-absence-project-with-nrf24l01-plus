#include "uart.h"
#include <delay.h>
unsigned char UART_RxChar()
{
    while ((UCSRA & (1 << RXC)) == 0);/* Wait till data is received */
    return(UDR);            /* Return the byte*/
}

void UART_TxChar(uint8_t ch)
{
	while (! (UCSRA & (1<<UDRE)));  /* Wait for empty transmit buffer */
	UDR = ch ;
}

void UART_SendString(uint8_t *str, uint8_t length)
{
int i;
for(i = 0; i< length;++i)
{
    UART_TxChar(str[i]);
}
}

void UART_SendString2(char *str)
{
	unsigned char j=0;
	
	while (str[j]!=0)		/* Send string till null */
	{
		UART_TxChar(str[j]);	
		j++;
	}
}
