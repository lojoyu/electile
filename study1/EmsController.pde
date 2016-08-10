class EmsController {
  int channel = 0;
  int intensity = 0;
  int time = 200;
  Serial openEMSstim;
  
  EmsController(Serial _openEMSstim) {
    openEMSstim = _openEMSstim;
  }
  
  void setIntensity(int val) {
    if (val > EMS_I_VAL[MAX]) intensity = EMS_I_VAL[MAX];
    else if (val < EMS_I_VAL[MIN]) intensity = EMS_I_VAL[MIN];
    else intensity = val;
  }
  
  void plusIntensity(int val) {
    if (val+intensity > EMS_I_VAL[MAX]) intensity = EMS_I_VAL[MAX];
    else if (val+intensity < EMS_I_VAL[MIN]) intensity = EMS_I_VAL[MIN];
    else intensity += val;
  }
  
  void go() {
    if (noEMS) println("go");
    else this.openEMSstim.write("C"+str(channel)+"I"+str(intensity)+"T"+str(time)+"G");  
  }
  
}