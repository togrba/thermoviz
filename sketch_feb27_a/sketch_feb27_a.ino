#include <Wire.h>
#include <Adafruit_Sensor.h> 
#include <Adafruit_ADXL345_U.h>
#include <SoftwareSerial.h>
#include <LowPower.h>


const int AccPin = 9; 
SoftwareSerial BT(10, 11);  
char val;
Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified();
void setup(void) 
{
  // set the data rate for the SoftwareSerial port
   Serial.begin(9600); 
   Serial.println("BT is ready!");
   pinMode(AccPin, OUTPUT);
   BT.begin(9600); 
   if(!accel.begin())
   {
      Serial.println("No ADXL345 sensor detected.");
      while(1);
   }
}

void loop(void) 
{
   sensors_event_t event; 
   accel.getEvent(&event);
  if (BT.available()) {
    //val = Serial.read();
    Serial.println("SEnding");
    BT.print("SOMEDATASENT");
  }

  Serial.println("SEnding");
    BT.print(event.acceleration.x);
    BT.print(event.acceleration.y);
    BT.print(event.acceleration.z);

  if (BT.available()) {
    val = BT.read();
    Serial.print(val);
  }


   Serial.print("X: "); Serial.print(event.acceleration.x); Serial.print("  ");
   Serial.print("Y: "); Serial.print(event.acceleration.y); Serial.print("  ");
   Serial.print("Z: "); Serial.print(event.acceleration.z); Serial.print("  ");
   Serial.println("m/s^2 ");
   delay(500);
}
