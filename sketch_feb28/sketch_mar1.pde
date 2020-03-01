import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

float x = 0;
float y = 0;
float z = 0;
// ======================= Visualization =======================
ArrayList<Particle> pts;
boolean onPressed, showInstruction;
PFont f;
//float mousez;
//float scale;
//float middle;
float nega(float val)
{
    if(val<0.0)
    {
      val= val * -1.0;
    }
    return val;
}

//scales x coordinate 
float scale1(float val)
{
  if(val>1.0 && val<10.0)
  {
    val=val*72;
    return val;
  }
  else if(val>10.0)
  {
    val=val*7.2;
    
    return val;
  }
  else
  {
    val=val*720;
    return val;
  }  
}

//scales y coordinate 
float scale3(float val)
{
  if(val>1.0 && val<10.0)
  {
    val=val*72;
    return val;
  }
  else if(val>10.0)
  {
    val=val*7.2;
    
    return val;
  }
  else
  {
    val=val*720;
    return val;
  }
}

//scales z coordinate 
float scale2(float val)
{
  if(val>1.0 && val<10.0)
  {
    val=val*25.5;
    return val;
  }
  else if(val>10.0)
  {
    val=val*2.55;
    
    return val;
  }
  else
  {
    val=val*255;
    return val;
  }
}
// =============================================================
 

void setup() {
  // ======================= Visualization =======================
  size(720, 720, P2D);
  smooth();
  frameRate(1000);
  colorMode(RGB);
  rectMode(CENTER);
 
  pts = new ArrayList<Particle>();
  background(255);
  // =============================================================

  
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  if ( myPort.available() > 0) {
    //val = myPort.readStringUntil('\n'); 
    val = myPort.readString(); 
    //println(val);
    
    String[] new_val = split(val, "-");
    //println("TEST VAL: ", val);
    //println(new_val.length);
    if(new_val[0].trim().contains("ACC") && new_val.length == 5){
      x = (float(new_val[1]));
      y = (float(new_val[2]));
      z = (float(new_val[3]));
      println("X: ", x);// read it and store it in val
      println("Y: ", y);// read it and store it in val
      println("Z: ", z);// read it and store it in val
    }
    
    // ======================= Visualization =======================
    //middle = 720/2; // sketch size divided in half
    //scale = x*middle*6;
    //scale = x*middle*100;
    
    for (int i=0;i<10;i++) {
      //Particle newP = new Particle(x*scale, y*scale, i+pts.size(), i+pts.size());
      Particle newP1 = new Particle(scale1(nega(x)), scale3(nega(x)), i+pts.size(), i+pts.size());
      pts.add(newP1);
    }
 
    for (int i=0; i<pts.size(); i++) {
      Particle p = pts.get(i);
      p.update();
      p.display();
    }
 
    for (int i=pts.size()-1; i>-1; i--) {
      Particle p = pts.get(i);
      if (p.dead) {
        pts.remove(i);
      }
    }
    // =============================================================

  } 
 //print it out in the console
}

//void serialEvent(Serial pa) {
//  String inString = pa.readString();
//  println(inString);
//}

// ======================= Visualization ======================= 
void keyPressed() {
  if (key == 'c') {
    for (int i=pts.size()-1; i>-1; i--) {
      Particle p = pts.get(i);
      pts.remove(i);
    }
    background(255);
  }
}
 
class Particle{
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;
   
  Particle(float x, float y, float xOffset, float yOffset){
    loc = new PVector(x,y);
     
    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    vel.mult(random(5));
     
    acc = new PVector(0,0);
    lifeSpan = int(random(30, 90));
    decay = random(0.75, 0.9);
    c = color(z,random(255),255);
    weightRange = random(3,50);
     
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
   
  void update(){
    if(passedLife>=lifeSpan){
      dead = true;
    }else{
      passedLife++;
    }
     
    alpha = float(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = float(lifeSpan-passedLife)/lifeSpan * weightRange;
     
    acc.set(0,0);
     
    float rn = (noise((loc.x+frameCount+xOffset)*0.01, (loc.y+frameCount+yOffset)*0.01)-0.5)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.01);
    PVector dir = new PVector(cos(rn),sin(rn));
    acc.add(dir);
    acc.mult(mag);
     
    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5);
    acc.add(randV);
     
    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }
   
  void display(){
    strokeWeight(weight+1.5);
    stroke(0, alpha);
    point(loc.x, loc.y);
     
    strokeWeight(weight);
    stroke(c);
    point(loc.x, loc.y);
  }
}
// =============================================================
