/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 7/22/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 2.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>

// Declare your global variables here

// Standard Input/Output functions
#include <stdio.h>

// SPI functions
#include <spi.h>                                                                            
#include "NRF24L01plus.h"
#include "uart.h"

// Timer1 output compare A interrupt service routine
uint16_t counter_delay = 0;
uint16_t request_counter_delay = 20;
uint8_t dipSwitchStatus = 0;
uint8_t  TxAddress[10][5] = 
{
    {0x00,0xDD,0xCC,0xBB,0xCB},
    {0x03,0xDD,0xCC,0xBB,0xCB},
    {0x06,0xDD,0xCC,0xBB,0xCB},
    {0x09,0xDD,0xCC,0xBB,0xCB},
    {0x0C,0xDD,0xCC,0xBB,0xCB},
    {0x0F,0xDD,0xCC,0xBB,0xCB},
    {0x12,0xDD,0xCC,0xBB,0xCB},
    {0x15,0xDD,0xCC,0xBB,0xCB},
    {0x18,0xDD,0xCC,0xBB,0xCB},
    {0x1B,0xDD,0xCC,0xBB,0xCB}
};
uint8_t TxData[10][6] = {
    {0, 0, 0, 0, 0, 0},
    {1, 1, 1, 1, 1, 1},
    {2, 2, 2, 2, 2, 2},
    {3, 3, 3, 3, 3, 3},
    {4, 4, 4, 4, 4, 4},
    {5, 5, 5, 5, 5, 5},
    {6, 6, 6, 6, 6, 6},
    {7, 7, 7, 7, 7, 7},
    {8, 8, 8, 8, 8, 8},
    {9, 9, 9, 9, 9, 9}
};
uint8_t flag_tx = 0;
interrupt [TIM1_COMPA] void timer1_compa_isr(void)//10ms
{
// Place your code here
counter_delay++;
if(counter_delay >= request_counter_delay)
{
  flag_tx = 1; 
  counter_delay = 0; 
} 
}
void DipSwitch(void)
{
 dipSwitchStatus = ~((PIND  & 0xF8) >> 3) & 0x1F;  
 set_addr(TxAddress[dipSwitchStatus],3 * dipSwitchStatus);

}
void main(void)
{

// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 250.000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 10 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x09;
ICR1L=0xC3;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x0C;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 500.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
NRF24L01plus_Init();
NRF24_TXMode(TxAddress[dipSwitchStatus],0);
#asm("sei")

while (1)
      { 
      DipSwitch();
      UART_TxChar(dipSwitchStatus);
      UART_TxChar('\n');
      UART_TxChar('\r');
      // Place your code here  
      if(flag_tx)
      {   counter_delay = 0;
          flag_tx = 0;
          
          switch(NRF24_Transmit(TxData[dipSwitchStatus],5))
           {  
              case 0:
                 request_counter_delay = 20; 
                 break;
              case 1:
                  request_counter_delay = 300;
                  PORTC.4 = 0;
                  delay_ms(100);
                  PORTC.4 = 1;    
              break;
              

           }
      }
      }
}
