import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

float x = 0;
float y = 0;
float z = 0;


void setup() {
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
}
void draw()
{
  if ( myPort.available() > 0) {
  //val = myPort.readStringUntil('\n'); 
  val = myPort.readString(); 
  //println(val);
  
  String[] new_val = split(val, "-");
  println(new_val.length);
  if(new_val[0].trim().contains( "ACC") && new_val.length == 5){
    x = float(new_val[1]);
    y = float(new_val[2]);
    z = float(new_val[3]);
    println("X: ", x);// read it and store it in val
    println("Y: ", y);// read it and store it in val
    println("Z: ", z);// read it and store it in val
  }
  } 
 //print it out in the console
}

//void serialEvent(Serial pa) {
//  String inString = pa.readString();
//  println(inString);
//}
