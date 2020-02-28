#include <Wire.h>
#include <Adafruit_Sensor.h> 
#include <Adafruit_ADXL345_U.h>
#include <SoftwareSerial.h>
#include <LowPower.h>


//Serial BT(10, 11);  
SoftwareSerial BT(10, 11);  
//char val;
float val_x;
float val_y;
float val_z;

Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified();
void setup(void) 
{
  // set the data rate for the (Software)Serial port
   Serial.begin(9600); 
   Serial.println("BT is ready!");
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
//  val_x = event.acceleration.x;
//  val_y = event.acceleration.y;
//  val_z = event.acceleration.z;
//  println(val_x "+" val_y "+" val_z);

//    BT.println(event.acceleration.x); 
//    BT.println(event.acceleration.y); 
//    BT.println(event.acceleration.z);

    BT.println("ACC-"+(String)event.acceleration.x +"-"+ (String)event.acceleration.y +"-"+ (String)event.acceleration.z+"-END");
    //BT.println("-"); 
    // split string at - into a string of xyz together

  if (BT.available()) {
    //val = BT.read();
    //Serial.print(val);
  }


//   Serial.print("X: "); Serial.print(event.acceleration.x); Serial.print("  ");
//   Serial.print("Y: "); Serial.print(event.acceleration.y); Serial.print("  ");
//   Serial.print("Z: "); Serial.print(event.acceleration.z); Serial.print("  ");
//   Serial.println("m/s^2 ");
   delay(500);
   LowPower.powerDown(SLEEP_8S, ADC_OFF, BOD_OFF);
}
