
#include "spi.h"
#include "uart.h"
// Function to initialize SPI
void SPI_Init()
{
    // Set MOSI, SCK, SS as output pins
    DDRB |= (1 << DDB3) | (1 << DDB5) | (1 << DDB2);
    // Enable SPI, Set as Master
    // Prescaler: Fosc/16, Enable Interrupts
    SPCR |= (1 << SPE) | (1 << MSTR) | (1 << SPR0);
}

// Function to send data over SPI
void SPI_Transmit(uint8_t data)
{
    // Start transmission
    SPDR = data;
    // Wait for transmission to complete
    while (!(SPSR & (1 << SPIF)));
}

// Function to send multiple bytes over SPI
void SPI_TransmitBytes(uint8_t* data, uint16_t length)
{      uint8_t i = 0;
    
        for(i = 0; i < length;++i)
        { 
        SPDR = data[i]; 
        while (!(SPSR & (1 << SPIF)));
        }
           
       // UART_SendString(data,32);
}
void SPI_Transmit_nrf24(uint8_t* data, uint16_t length)
{      uint8_t i = 0;
    
        for(i = 0; i < length;++i)
        { 
        SPDR = data[i]; 
        while (!(SPSR & (1 << SPIF)));
        }
           
       // UART_SendString(data,32);
}
// Function to receive data over SPI (single byte)
uint8_t SPI_Receive()
{
    // Send dummy data to initiate data exchange
    SPI_Transmit(0xFF);
    // Wait for reception to complete
    while (!(SPSR & (1 << SPIF)));
    // Return received data
    return SPDR;
}

// Function to receive multiple bytes over SPI
void SPI_ReceiveBytes(uint8_t* buffer, uint16_t length)
{    
    uint16_t i;
    for (i = 0; i < length; i++)
    {
        buffer[i] = SPI_Receive();
    }
}
