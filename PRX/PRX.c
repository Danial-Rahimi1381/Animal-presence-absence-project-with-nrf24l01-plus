/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 7/9/2023
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

#include <delay.h>

// Declare your global variables here

// Standard Input/Output functions
#include <stdio.h>

#include "uart.h"
#include "NRF24L01plus.h"       


#define Internal_REF  1.78
#define Tolerance_Res  1.091

uint8_t str[20];
float voltage_battery  = 0;
float voltage_reset = 0;

int dipSwitchStatus = 0;

uint8_t RXData[32];

uint8_t status = 0;
uint8_t ACK_Payload[7] = "Hello1";
// Timer 0 overflow interrupt service routine

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value

TCNT0=0x06;

// Place your code here

     if(isDataAvailable(1))
      {
       NRF24_Recive(RXData);
       nrf24_write_ack();
       UART_SendString(str,11);
      }
}

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
uint8_t  RxAddress[] ;//= {0xEE,0xDD,0xCC,0xBB,0xAA};
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

#include "NRF24L01plus.h"
void Battery_monitoring(float voltage)
{
    if(voltage <= 3.29)
    {   
    
        PORTC.1 = 1;
        PORTC.2 = 1;
        PORTC.0 = 0;
        delay_ms(300);
        PORTC.0 = 1;
        delay_ms(300);
    }
    else if( voltage > 3.29 && voltage <=3.42)
    {
    PORTC.0 = 0;
    PORTC.1 = 1;
    PORTC.2 = 1;
    }
    else if(voltage >3.42 && voltage <= 3.70)
    {
    PORTC.0 = 0;
    PORTC.1 = 0;
    PORTC.2 = 1;
    }
    else if(voltage >3.70)
    {
    PORTC.0 = 0;
    PORTC.1 = 0;
    PORTC.2 = 0;
    } 
    else
    {
    PORTC.0 = 1;
    PORTC.1 = 1;
    PORTC.2 = 1;
 
   }
}
void DipSwitch()
{   
        
      //  DDRD &= ~(0b11111111);

        // Read the status of DIP switches from pins D3 to D7
            dipSwitchStatus = (PIND  & 0xF8) >> 3;

        // Compare the dipSwitchStatus with desired cases using switch
  switch (dipSwitchStatus) {
            case 0b00000:
                // No switches are ON
                // Perform corresponding actions 
                RxAddress[0] = 0x00;
                RxAddress[1] = 0xDD;
                RxAddress[2] = 0xCC;
                RxAddress[3] = 0xBB;
                RxAddress[4] = 0xCB;
                NRF24_Write_Register(RF_CH, 0); // will be setup during TX or RX
             break;
            case 0b00001:
                // Switch D3 is ON, other switches are OFF
                // Perform corresponding actions
                RxAddress[0] = 0x03;
                RxAddress[1] = 0xDD;
                RxAddress[2] = 0xCC;
                RxAddress[3] = 0xBB;
                RxAddress[4] = 0xCB;
                NRF24_Write_Register(RF_CH, 3); // will be setup during TX or RX
                break;
            case 0b00010:
                // Switch D4 is ON, other switches are OFF
                // Perform corresponding actions
                      RxAddress[0] = 0xEE;
                RxAddress[1] = 0x06;
                RxAddress[2] = 0xCC;
                RxAddress[3] = 0xBB;
                RxAddress[4] = 0xCB;
                NRF24_Write_Register(RF_CH, 6); // will be setup during TX or RX
             break;
            case 0b00100:
                // Switch D5 is ON, other switches are OFF
                // Perform corresponding actions 
                RxAddress[0] = 0x09;
                RxAddress[1] = 0xDD;
                RxAddress[2] = 0xCC;
                RxAddress[3] = 0xBB;
                RxAddress[4] = 0xCB;
                NRF24_Write_Register(RF_CH, 9); // will be setup during TX or RX
                break;
            case 0b01000:
                // Switch D6 is ON, other switches are OFF
                // Perform corresponding actions 
                RxAddress[0] = 0x0B;
                RxAddress[1] = 0xDD;
                RxAddress[2] = 0xCC;
                RxAddress[3] = 0xBB;
                RxAddress[4] = 0xCB;
                NRF24_Write_Register(RF_CH, 12); // will be setup during TX or RX
                  break;
            case 0b10000:
                // Switch D7 is ON, other switches are OFF
                // Perform corresponding actions   
                RxAddress[0] = 0x0E;
                RxAddress[1] = 0xDD;
                RxAddress[2] = 0xCC;
                RxAddress[3] = 0xBB;
                RxAddress[4] = 0xCB;
                NRF24_Write_Register(RF_CH, 15); // will be setup during TX or RX
                break;

  }


}
unsigned int averaging_adc()
{   int i;
    unsigned int value = 0;
    unsigned int array[40];
    for( i = 0; i < 40; i++)
    {
        array[i] = read_adc(3);
    }
    for(i = 0; i < 40; i++)
    {
       value += array[i];
    }
    value /= 40;
    return value;   

}



void main(void)
{

// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250.000 kHz
TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x06;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0xF8;
TCNT1L=0x30;
ICR1H=0x00;
ICR1L=0x00;
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
TCNT2=0x06;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

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

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

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

// Global enable interrupts
#asm("sei")
PORTC.4 = 0;
delay_ms(1000);

NRF24L01plus_Init();
DipSwitch();
NRF24_RxMode(( uint8_t *)RxAddress,9);

while (1)
      {
      // Place your code here  
      
        voltage_battery =4.2*(2*(averaging_adc()/1023.00))/Tolerance_Res;// 1023  511.5 
        sprintf(str, "%.2f \n\r ", voltage_battery);
        //UART_SendString(str, 20);
        Battery_monitoring(voltage_battery);
        

    }
}
