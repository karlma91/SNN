color currentColor = color(0);
ArrayList<Neuron> neurons = new ArrayList<Neuron>();
PMatrix2D coordinateSystem;
PMatrix2D inverse;
float scale = 1;
PVector trans = new PVector();
JSONObject json;
PVector global = new PVector();
PVector local = new PVector();
PVector plocal = new PVector();

boolean[] keys = new boolean[255];


void setup() {
  size(1000, 800);
  coordinateSystem = new PMatrix2D(); 
  coordinateSystem.translate(width * .5, height * .5);
  
  cc.x_pos = width - 130;
  cc.add_button(saveButton);
  cc.add_button(removeButton);
  cc.add_button(addButton);
  cc.add_button(synapsButton);
  cc.add_button(loadButton);
  cc.add_button(fireButton);
  
  loadFile("data1.json");
}

void draw() {

  update(mouseX, mouseY);
  background(currentColor);
  cc.draw();
  pushMatrix();
  coordinateSystem.reset();
  coordinateSystem.translate(width/2, height/2);
  coordinateSystem.translate(trans.x, trans.y);
  coordinateSystem.scale(scale);
  inverse = coordinateSystem.get();
  inverse.invert();
  //set global coordinates
  global.set(mouseX, mouseY);
  //compute local coordinates by multiplying the global coordinates to the inverse local coordinate system (transformation matrix)
  inverse.mult(global, local);
  global.set(pmouseX, pmouseY);
  inverse.mult(global, plocal);

  setMatrix(coordinateSystem);
  //scale(scale);
  for (Neuron n : neurons) {
    n.draw();
  }
  if (toBeAdded != null) { 
    toBeAdded.pos.x = local.x;
    toBeAdded.pos.y = local.y;
    toBeAdded.draw();
  }
  popMatrix();
}

float speed = 5;

void update(int x, int y) {
  if (keys['j']) {
    scale*=0.99;
  }
  if (keys['k']) {
    scale*=1.01;
  }
  if (keys['a']) {
    trans.x-=speed;
  }
  if (keys['d']) {
    trans.x+=speed;
  }
  if (keys['w']) {
    trans.y-=speed;
  }
  if (keys['s']) {
    trans.y+=speed;
  }
  cc.update();
  for (Neuron n : neurons) {
    n.update();
  }
}

void keyPressed()
{
  keys[key]= true;
}
void keyReleased() {
  keys[key]= false;
}
