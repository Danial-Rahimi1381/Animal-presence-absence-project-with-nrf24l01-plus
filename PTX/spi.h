#include <stdint.h>
#include <stdio.h>
// Function to initialize SPI
void SPI_Init();

// Function to send data over SPI
void SPI_Transmit(uint8_t data);

// Function to send multiple bytes over SPI
void SPI_TransmitBytes(uint8_t* data, uint16_t length);

// Function to receive data over SPI (single byte)
uint8_t SPI_Receive();

// Function to receive multiple bytes over SPI
void SPI_ReceiveBytes(uint8_t* buffer, uint16_t length);
void SPI_Transmit_nrf24(uint8_t* data, uint16_t length);