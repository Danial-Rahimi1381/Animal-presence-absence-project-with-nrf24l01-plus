
#include "spi.h"
#include <string.h>
// Function to initialize SPI

// Function to send data over SPI
void SPI_Transmit(uint8_t data)
{
    // Start transmission
    SPDR = data;
    // Wait for transmission to complete
    while (!(SPSR & (1 << SPIF)));
}

// Function to send multiple bytes over SPI
void SPI_TransmitBytes(const uint8_t* data, uint16_t length)
{      uint8_t i;
    
    for (i = 0; i < length; i++) {
       
        SPDR = data[i];
       
        while (!(SPSR & (1 << SPIF)));
    }
  
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
void SPI_ReceiveBytes2(uint8_t* buffer)
{    
    uint16_t i;
    for (i = 0; i < strlen(buffer); i++)
    {
        buffer[i] = SPI_Receive();
    }
}