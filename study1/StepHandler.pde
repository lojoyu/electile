class StepHandler {
  
  ControlP5 cp5;
  int step;
  /*
    1 - min (up)
    2 - min (down)
    3 - max (up)
    4 - try
  */
  String[] stepIntro = new String[]{"Step 1-1", "Step 1-2", "Step 2", "Step 3"};
  String[] adjustStr = new String[]{"- ", "+ "};
  int[] adjustV = new int[]{1, 5};
  Button[] btns = new Button[4];
  
  int[] recordI = new int[]{0, 0, 0};
  int[] recordIsum = new int[]{0, 0, 0};
  int[] testV = new int[6];
  int step4T = 0;
  int stepCount = 0;

  StepHandler(ControlP5 _cp5, int _step) {
    cp5 = _cp5;
    step = _step;
    
    initStep(true);
    //cp5.addButton("OK")
    //    .setValue(0)
    //    .setPosition(width-70, height-70)
    //    .setSize(50,50);
  }  
  
  void draw() {
    textAlign(CENTER);
    text(stepIntro[step-1], width/2, 50);
    pushStyle();
      textSize(70);
      fill(0);
      String t = "";
      if (step <= 3) t = str(emsController.intensity);
      else if (step4T == -1) t = "START";
      else if (step4T < 5) t = "L"+str(step4T+1);
      else t = "DONE";
      text(t, width/2, 150);     
    popStyle();
    
  }
  
  void next() {
    if (step == 4) {
      step4T++;
      if (step4T >= 5) return;
      println(testV[step4T]);
      emsController.setIntensity(testV[step4T]);
      
      //EMS go
      return;
    }  
    
    recordI[step-1] = emsController.intensity;
    if (step == 2) recordI[step-1] -= 1;
    else recordI[step-1] += 1;
    
    recordIsum[step-1] += recordI[step-1];
    if (step == 3) {
      stepCount ++;
      if (stepCount >= STEP_REPEAT) {
        removeControlBtn();
      }

      else step = 0;
    }
    step ++;
    initStep(false);
  }
  
  void initStep(boolean first) {
 
    if (step == 4) {
      step4T = -1;
      genTestV();
      emsController.setIntensity(0);
      
      return;
    }  
    
    if (first) addControlBtn();
    if (step == 1) emsController.setIntensity(0);  
    else if (step == 2) emsController.setIntensity(recordI[0]+10);  
    else if (step == 3) emsController.setIntensity(recordI[1]);  
    
  }

  void genTestV() {
    float minI = (recordIsum[0]/STEP_REPEAT+recordIsum[1]/STEP_REPEAT)/2.0;
    float maxI = recordIsum[2]/STEP_REPEAT;
    testV[0] = (int)minI+2;
    testV[4] = (int)maxI-2;
    float interval = (maxI-minI-4)/4;
    for (int i=1; i<4; i++) {
      testV[i] = (int)(minI+2+interval*i);
    }
    println(testV);
  }
  
  
  void addControlBtn() {
    for(int i=0; i<2; i++) {
      for (int j=0; j<2; j++) {
        btns[i*2+j] = cp5.addButton(adjustStr[i]+str(adjustV[j]))
                          .setValue(adjustV[j]*(i*2-1))
                          .setPosition(160+200*i,250-50*j)
                          .setSize(80,30);
      }
    }
    
  }
  
  void removeControlBtn() {
    for(int i=0; i<2; i++) {
      for (int j=0; j<2; j++) {
        cp5.remove(adjustStr[i]+str(adjustV[j]));
      }
    }
  }
  
  
  
  
  
}