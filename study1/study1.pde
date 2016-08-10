import processing.serial.*;
import java.util.*;
import controlP5.*;

ControlP5 cp5;

Serial openEMSstim;
int index_of_serial_port = 17;
EmsController emsController;

boolean noEMS = true;
StepHandler stepHandler;

void setup() {
  
  //printArray(Serial.list());
  //openEMSstim = new Serial(this, Serial.list()[index_of_serial_port], 9600);
  emsController = new EmsController(openEMSstim);
  
  size(600, 400);
  fill(200);
  textSize(15f);
  
  cp5 = new ControlP5(this);
  stepHandler = new StepHandler(cp5, 1); 
  
  
  frameRate(50);
}

void draw() {
  background(255);
  stepHandler.draw();

}

void keyPressed() {
  if (key == ENTER) {
      println("next");
      stepHandler.next();
  }
  
  if (key == 'r' || key =='R') {
    emsController.go();
  }
  
  if (key == 'a' || key == 'A') {
    sendVal(-5);
  }
  if (key == 's' || key == 'S') {
    sendVal(+5);  
  }
  if (key == 'z' || key == 'Z') {
    sendVal(-1);  
  }
  if (key == 'x' || key == 'X') {
    sendVal(+1);  
  }
  
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName() == "OK") {
    println("ok");
    stepHandler.next();
    return;
  }
  int val = (int)theEvent.getController().getValue(); 
  sendVal(val);
}

void sendVal(int val) {
  emsController.plusIntensity(val);
  emsController.go();
}

