class Neuron
{
  PVector pos;
  int radius = 8;
  int id = 0;
  int gotInput = 0;
  int lastFire = 0;
  int maxf = 1; // 1 hz
  float Cm = 10; //cell capacitance
  float Vth = 4; // Volt threshold causing (Action potential?)
  float Rm = 0.995; // Membrane resistance causing leak
  float Vm = 0; // current voltage
  
  boolean selected = false;
  boolean mouseOver = false;
  ArrayList<Float> axonWeights = new ArrayList<Float>();
  ArrayList<Neuron> axon = new ArrayList<Neuron>();
  ArrayList<Neuron> dendrite = new ArrayList<Neuron>();
  Neuron(int x, int y,int id) {
    pos = new PVector(x,y);
    this.id = id;
  }

  void recieve_spike(int peak){
    Vm += peak;
    if(Vm>Vth){
     gotInput = millis(); 
    }
  }
  
  void fire(){
    for(Neuron n : axon){
      n.recieve_spike(5);
    }
  }

  void draw() {
    if (mouseOver) {
      fill(120);
    } else {
      int fill = min((int)Vm*100,255);
      fill(fill);
    }
    if (selected) {
      stroke(255,0,0);
    }else{
      stroke(255); 
    }

    
    circle(pos.x, pos.y, radius*2);
    for (Neuron n : axon) {
      drawArrow(pos.x, pos.y, n.pos.x, n.pos.y);
    }
    textSize(16);
    fill(255);
    text(Vm+"",pos.x-10,pos.y+24);
  }

  void update() {
    if ( overCircle(pos, radius*2) ) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
    int now = millis();
    int delta = now-lastFire;
    if(Vm > Vth && delta>100 && (now-gotInput)>100){
      fire();
      Vm = 0;
      lastFire = now;
    }
    Vm *= Rm;
  }

  void drawArrow(float x1, float y1, float x2, float y2) {
    float a = 3;
    pushMatrix();
    translate(x2, y2);
    rotate(atan2(y2 - y1, x2 - x1));
    triangle(- a * 2-radius, - a, -radius, 0, - a * 2-radius, a);
    popMatrix();
    line(x1, y1, x2, y2);
  }

  boolean overCircle(PVector pos, int diameter) {
    
    float disX = ((float)pos.x) - local.x;
    float disY = ((float)pos.y) - local.y;
    if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } else {
      return false;
    }
  }
}
