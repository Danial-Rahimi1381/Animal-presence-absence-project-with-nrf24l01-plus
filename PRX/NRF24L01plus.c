#include "NRF24L01plus.h"
#include "uart.h"
//------------------------------------------------------------

void NRF24_Write_Register(uint8_t reg, uint8_t Data)
{
if(reg <= 31)
{
   uint8_t buf[2]; 
   buf[0] = reg|(1<<5);
   buf[1] = Data;
   CSN_Enable;
   SPI_Transmit(buf[0]);
   SPI_Transmit(buf[1]);
   CSN_Disable;   
}
}
                          
void NRF24_WriteMulti_Register(uint8_t reg, uint8_t * Data, uint8_t size)
{   uint8_t i;                         
    uint8_t buf;
    buf = reg | (1 << 5);
    CSN_Enable;
    SPI_Transmit(buf);
    SPI_TransmitBytes(Data, size);
    CSN_Disable;   
}

uint8_t NRF24_Read_Register(uint8_t reg)
{
if(reg <= 31)
{
    uint8_t Data = 0;  
    CSN_Enable; 
    SPI_Transmit(reg);
    Data = SPI_Receive(); 
    CSN_Disable;   
    return Data;
}
return 0;
}

void NRF24_ReadMulti_Register(uint8_t reg, uint8_t *data, uint8_t size)
{
    CSN_Enable;
    
    SPI_Transmit(reg);
    SPI_ReceiveBytes(data, size); 
    
    CSN_Disable;
}


// send the command to the NRF 
void NRF24_SendCMD(uint8_t cmd)
{
    CSN_Enable;
    SPI_Transmit(cmd);
    CSN_Disable;
}
//----------------------------------------------------


void NRF24L01plus_Init()
{
    uint8_t config;
    CE_Disable;
    NRF_RESET(STATUS);
    NRF_RESET(FIFO_STATUS);
  
    
    NRF24_Write_Register(CONFIG,0); // will be configured later  
    NRF24_Write_Register(SETUP_RETR, 0xFA); // Enable automatic retransmission with maximum delay and retries
   
    NRF24_Write_Register(RF_CH, 9); // will be setup during TX or RX
    NRF24_Write_Register(SETUP_AW, 0x03);//5byte for  TX/RX Address 
    NRF24_Write_Register(RF_SETUP, 0x0E); // Power = 0db, data rate =  250kbps
    NRF24_Write_Register(FEATURE,0x06); //EN_ACK_PAY  ,  EN_DPL 
    NRF24_Write_Register(SETUP_AW, 0x03); // Set address width to 5 bytes
    config = NRF24_Read_Register(CONFIG);
    config = config | (1<<3) | (1 << 2); // CRC ENABLE ,  CRC 2BYTE
    NRF24_Write_Register(CONFIG, config);
   
    CE_Enable;
}
/*----------------------------------------------*/
/*-----------------TxMode-----------------------*/
void NRF24_TXMode( uint8_t const* Address, uint8_t channel)
 {
    uint8_t config = 0;
    uint8_t dynpd = 0;
    CE_Disable;

    NRF24_Write_Register(RF_CH, channel); // select the channel

    NRF24_WriteMulti_Register(TX_ADDR, Address, 5); // Write the TX address

    // power up the device
    config = NRF24_Read_Register(CONFIG);
    config = config | (1<<1) | (0 << 0);
    NRF24_Write_Register(CONFIG, config);

    // Enable Enhanced ShockBurst
    NRF24_Write_Register(EN_AA, 0x01); // Enable Auto ACK on pipe 0
    NRF24_Write_Register(EN_RXADDR, 0x01); // Enable data pipe 0
    NRF24_Write_Register(DYNPD, 0x01); //Enable DPL  PIPE 0
    NRF24_WriteMulti_Register(RX_ADDR_P0, Address, 5); //Write the TX address

               
    


    CE_Enable;
 }


uint8_t NRF24_Transmit(uint8_t * data , uint8_t length)
 {

    uint8_t counter = 0;
    uint8_t cmdtosend = 0; 
    uint8_t fifostatus = 0;
    //Select the device 
  
  CSN_Enable;
    cmdtosend = W_TX_PAYLOAD;
    SPI_Transmit(cmdtosend);
    SPI_TransmitBytes(data,length); 
  CSN_Disable;
  
 // delay_ms(2);
  
   
   fifostatus = NRF24_Read_Register(FIFO_STATUS);
    if ((fifostatus&(1<<4)) && (!(fifostatus&(1<<3))))
    {    
              
        cmdtosend = FLUSH_TX;
        NRF24_SendCMD(cmdtosend);      
        NRF_RESET(FIFO_STATUS); 
        NRF_RESET(STATUS);
        return 1;
    }
    ++counter;
    if(counter == 15)
    {
    counter = 0; 
        NRF_RESET(FIFO_STATUS); 
        NRF_RESET(STATUS);
    }       
 }


void NRF24_RxMode (uint8_t *Address, uint8_t channel)
 {
    uint8_t en_rxaddr;
    uint8_t en_aa;
    uint8_t config;
    //Disable the chip before configuring the device
    CE_Disable;

   // NRF24_Write_Register(RF_CH, channel); // select the channel

    en_rxaddr = NRF24_Read_Register(EN_RXADDR);
    en_rxaddr = en_rxaddr | (1 << 1);
    NRF24_Write_Register(EN_RXADDR, en_rxaddr); // enable data pipe 1
    en_aa = NRF24_Read_Register(EN_AA);
    en_aa = en_aa | (1 << 1);
    NRF24_Write_Register(EN_AA, en_aa); // enable auto acknowledgment for data pipe 1

    NRF24_WriteMulti_Register(RX_ADDR_P1, Address, 5); // Write the RX address for data pipe 1
    NRF24_Write_Register(DYNPD, 0x02); // DPL for PIPE 1  
    
    // power up the device and enable Enhanced ShockBurst
    config = NRF24_Read_Register(CONFIG);
    config = config | (1 << 1) | (1 << 0);
    NRF24_Write_Register(CONFIG, config);
    
    // Enable the chip after configuring the device
    CE_Enable;
    
 }    
 
void nrf24_write_ack(void)
{
	const uint8_t *ack = "A";
	unsigned int length = 1;
	CSN_Enable;
	SPI_Transmit(W_ACK_PAYLOAD);
	while (length--) SPI_Transmit(*(uint8_t *)ack++);
	CSN_Disable;
      delay_ms(100);
      PORTC.5 = 0;
      PORTC.4 = 1;
      delay_ms(300);
      PORTC.5 = 1;
        
}
                    

uint8_t isDataAvailable(int pipenum)
{

    uint8_t status;
    status = NRF24_Read_Register(STATUS);  
    if((status&(1<<6))&&(status&(pipenum<<1)))
    {   
        PORTC.5 = 1;
        PORTC.4 = 0;
       NRF24_Write_Register(STATUS,status);
       return 1;
    }
    return 0;

}                      

void NRF24_Recive(uint8_t *data)
{

    
 uint8_t cmdtosend = 0;
 uint8_t length = 0;
 uint8_t counter = 0;
 uint8_t i;
 // select the device
 CSN_Enable; 
 cmdtosend = R_RX_PL_WID;
 SPI_Transmit(cmdtosend); 
 length = SPI_Receive(); 
 CSN_Disable;

 CSN_Enable; 
 cmdtosend = R_RX_PAYLOAD;
 SPI_Transmit(cmdtosend); 
 SPI_ReceiveBytes(data,length);  
 //UART_SendString(data,32);    

// Unselect the device

 CSN_Disable;
 cmdtosend = FLUSH_RX;
 NRF24_SendCMD(cmdtosend);
    
}

void NRF_RESET(uint8_t REG)
{
uint8_t rx_addr_p0_def[5]= {0xE7, 0xE7, 0xE7, 0xE7, 0xE7};
uint8_t rx_addr_p1_def[5]=  {0xC2, 0xC2, 0xC2, 0xC2, 0xC2};
uint8_t tx_addr_def[5] = {0xE7, 0xE7, 0xE7, 0xE7, 0xE7};
uint8_t status;
    if (REG == STATUS)
    {
     status = NRF24_Read_Register(STATUS);
     status = status | (1 << 4) | (1 << 5) | (1 << 6);
     NRF24_Write_Register(STATUS, status);
    }
    else if (REG == FIFO_STATUS)
    {
        NRF24_Write_Register(FIFO_STATUS, 0x11);
    }
    else {
        NRF24_Write_Register(CONFIG, 0x08);
        NRF24_Write_Register(EN_AA, 0x3F);
        NRF24_Write_Register(EN_RXADDR, 0x03);
        NRF24_Write_Register(SETUP_AW, 0x03);
        NRF24_Write_Register(SETUP_RETR, 0x03);
        NRF24_Write_Register(RF_CH, 0x02);
        NRF24_Write_Register(RF_SETUP, 0x0E);
        NRF24_Write_Register(STATUS, 0x00);
        NRF24_Write_Register(OBSERVE_TX, 0x00);
        NRF24_Write_Register(CD, 0x00);
        NRF24_WriteMulti_Register(RX_ADDR_P0, rx_addr_p0_def, 5);
        NRF24_WriteMulti_Register(RX_ADDR_P1, rx_addr_p1_def, 5);
        NRF24_Write_Register(RX_ADDR_P2, 0xC3);
        NRF24_Write_Register(RX_ADDR_P3, 0xC4);
        NRF24_Write_Register(RX_ADDR_P4, 0xC5);
        NRF24_Write_Register(RX_ADDR_P5, 0xC6);
        NRF24_WriteMulti_Register(TX_ADDR, tx_addr_def, 5);
        NRF24_Write_Register(RX_PW_P0, 0);
        NRF24_Write_Register(RX_PW_P1, 0);
        NRF24_Write_Register(RX_PW_P2, 0);
        NRF24_Write_Register(RX_PW_P3, 0);
        NRF24_Write_Register(RX_PW_P4, 0);
        NRF24_Write_Register(RX_PW_P5, 0);
        NRF24_Write_Register(FIFO_STATUS, 0x11);
        NRF24_Write_Register(DYNPD, 0);
        NRF24_Write_Register(FEATURE, 0);
    }
}
