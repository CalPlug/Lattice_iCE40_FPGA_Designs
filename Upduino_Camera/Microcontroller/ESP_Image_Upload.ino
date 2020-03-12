
#include "SPIFFS.h"
#include <SPI.h>

#define CSPIN  5  // A1 for IU board
//
//SPI pins
//SSN  = ESP pin 10  = UPDuino pin 46
//SCK  = ESP pin 13 = UPDuino pin 47
//MOSI = ESP pin 11 = UPDuino pin 48
//MISO = ESP pin 12 = UPDuino pin 45

int i = 0;
int j = 0;
byte pixdata;
int address;
  
void setup(void)
{
  pinMode(CSPIN, OUTPUT);
  SPI.begin(); 
  digitalWrite(CSPIN, HIGH);
  Serial.begin(115200);
  if(!SPIFFS.begin(true)){
       Serial.println("An Error has occurred while mounting SPIFFS");
       return;
  }
  delay(4000);
  File file = SPIFFS.open("/data.txt", FILE_WRITE);
  if(!file){
      Serial.println("There was an error opening the file for writing");
      return;
  }
  file.println("424D36DC05000000000036000000280000004001000090010000010018000000000000DC050000000000000000000000000000000000");
  //adds bitmap header
  //Serial.println("424D36DC05000000000036000000280000004001000090010000010018000000000000DC050000000000000000000000000000000000");   
  digitalWrite(CSPIN, LOW);
  
  //wait at least 1/30fps = 33.333ms for last frame to finish writing in FPGA
  delay(100);
  
  while(j<400)
  {
    while(i<320) 
    {
    
      address = j*320+i;
      if(j==0 && i==0)
        pixdata = readRegister(0x0, 1);
      else
        pixdata = readRegisterDataOnly(1);
      
      if(pixdata<16)
      { 
//        Serial.print("0"); //hex print prints "0" instead of "00", so this fixes it
//        Serial.print(pixdata, HEX);
//        Serial.print("0"); //hex print prints "0" instead of "00", so this fixes it
//        Serial.print(pixdata, HEX);
//        Serial.print("0"); //hex print prints "0" instead of "00", so this fixes it
//        Serial.print(pixdata, HEX);
        file.print("0"); //hex print prints "0" instead of "00", so this fixes it
        file.print(pixdata, HEX);
        file.print("0"); //hex print prints "0" instead of "00", so this fixes it
        file.print(pixdata, HEX);
        file.print("0"); //hex print prints "0" instead of "00", so this fixes it
        file.print(pixdata, HEX);    
      }
      else
      {      
//        Serial.print(pixdata, HEX); //the address is only used the first time CSPIN is set low.  After that the address is automatically incremented in the fpga design.
//        Serial.print(pixdata, HEX); //print 3 times to make the 8-bit monochrome value 24 bit RGB
//        Serial.print(pixdata, HEX);      
        file.print(pixdata, HEX); //the address is only used the first time CSPIN is set low.  After that the address is automatically incremented in the fpga design.
        file.print(pixdata, HEX); //print 3 times to make the 8-bit monochrome value 24 bit RGB
        file.print(pixdata, HEX);    
      }      
      
      i++;
    }
    
    i = 0;
    j++;
    file.print("\n");
  //  Serial.print("\n");

  }
  file.close();  
  
  digitalWrite(CSPIN, HIGH);   
  
  File file2 = SPIFFS.open("/data.txt");
      if(!file2){
        Serial.println("Failed to open file for reading");
        return;
    }
  delay(50);
   while(file2.available()) {
    Serial.print(file2.read());
   }
   file2.close();

}

void loop(void)
{
}

//Read data from FPGA over SPI
unsigned int readRegisterDataOnly(int bytesToRead) {
  byte inByte = 0;           // incoming byte from the SPI
  unsigned int result = 0;   // result to return
  
  // send a value of 0 to read the first byte returned:
  result = SPI.transfer(0x00);
  
  // decrement the number of bytes left to read:
  bytesToRead--;
  
  // if you still have another byte to read:
  if (bytesToRead > 0) {
    // shift the first byte left, then get the second byte:
    result = result << 8;
    inByte = SPI.transfer(0x00);
    
    // combine the byte you just got with the previous one:
    result = inByte;
    // decrement the number of bytes left to read:
    bytesToRead--;
  }
  
  // take the chip select high to de-select:
  //digitalWrite(CSPIN, HIGH);
  
  // return the result:
  return (result);
}

//Initiate and read data from FPGA over SPI
unsigned int readRegister(byte thisRegister, int bytesToRead) {
  byte inByte = 0;           // incoming byte from the SPI
  unsigned int result = 0;   // result to return
  
  // now combine the address and the command into one byte
  byte dataToSend = thisRegister ;//& READ;
  
  // send the device the register you want to read:
  SPI.transfer(dataToSend);
  
  // send a value of 0 to read the first byte returned:
  result = SPI.transfer(0x00);
  
  // decrement the number of bytes left to read:
  bytesToRead--;
  
  // if you still have another byte to read:
  if (bytesToRead > 0) {
  
    // shift the first byte left, then get the second byte:
    result = result << 8;
    inByte = SPI.transfer(0x00);
    
    // combine the byte you just got with the previous one:
    result = inByte;
    
    // decrement the number of bytes left to read:
    bytesToRead--;
  }
  
  // take the chip select high to de-select:
  //digitalWrite(CSPIN, HIGH);
  // return the result:
  return (result);
}

