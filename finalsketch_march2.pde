// Sources:
// https://www.openprocessing.org/sketch/748916 
// https://www.openprocessing.org/sketch/178381


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
float scale;
float middle;
float sketch_size_length = 1500; // obs change in setup - size
float sketch_size_breadth = 900; // obs change in setup - size
// =============================================================
 

void setup() {
  // ======================= Visualization =======================
  size(1500, 900, P2D);
  smooth();
  frameRate(30);
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
    val = myPort.readString();
    
    String[] new_val = split(val, ":"); // split incoming data at hyphens
    if(new_val[0].trim().contains( "ACC") && new_val.length == 5){
      x = (float(new_val[1]));
      y = (float(new_val[2]));
      z = (float(new_val[3]));
      println("GOOD X: ", x);
      println("GOOD Y: ", y);
      println("GOOD Z: ", z);
    }
    
    // ======================= Visualization =======================
    //middle = sketch_size/2; //sketch size divided in half
    //scale = x*middle*100;
    
    for (int i=0;i<100;i++) { //number of particles created
     /* if (x > -5 && x < 5 && z > 0) {  // middle
        //println("Middle");
        //println("X: ", x, "Z: ", z);
        Particle newP = new Particle((x/9.4)*middle*4, (x/9.4)*middle*4, i+pts.size(), i+pts.size());  // y coordinate
        pts.add(newP);
      }
      else if (x > 8 && x < 15 && z < 0) {  // looking down
        //println("Looking down");
        //println("X: ", x, "Z: ", z);
        Particle newP = new Particle((x/(9.4))*middle/11, (x/(9.4))*middle/11, i+pts.size(), i+pts.size()); 
        pts.add(newP);
      }
      else if (x < -8 && x > -15 && z < 0) { 
        //println("Looking up"); //x=10 z=neg
        //println("X: ", x, "Z: ", z);
        Particle newP = new Particle(-(-x/(9.4))*middle/11, -(-x/(9.4))*middle/11, i+pts.size(), i+pts.size());  
        pts.add(newP);
      }*/
      
      Particle newP = new Particle((10-y)*(sketch_size_length/20), (15+x)*(sketch_size_breadth/30), i+pts.size(), i+pts.size()); 
      
      pts.add(newP);
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

//// REMOVE?
//void keyPressed() {
//  if (key == 'c') {
//    for (int i=pts.size()-1; i>-1; i--) {
//      Particle p = pts.get(i);
//      pts.remove(i);
//    }
//    background(255);
//  }
//}
 
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
    c = color(random(255),random(255),255); // ADD map, color change with z values
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

//color getColorByTheta(float theta, float time) {
//  float th = 8.0 * theta + time * 2.0;
//  float r = 0.6 + 0.4 * cos(th), 
//    g = 0.6 + 0.4 * cos(th - PI / 3), 
//    b = 0.6 + 0.4 * cos(th - PI * 2.0 / 3.0), 
//    alpha = map(circleCnt, MIN_CIRCLE_CNT, MAX_CIRCLE_CNT, 150, 30); //map(value, start1, stop1, start2, stop2) -> https://processing.org/reference/map_.html
//  return color(r * 255, g * 255, b * 255, alpha);
//}
// =============================================================
