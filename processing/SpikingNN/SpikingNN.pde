
Container cc = new Container(100, 10);
Button b = new Button(0, 0, 100, 30, "save");
Button b2 = new Button(0, 35, 100, 30, "remove");
Button b3 = new Button(0, 70, 100, 30, "add");
Button b4 = new Button(0, 105, 100, 30, "synaps");
Button b5 = new Button(0, 140, 100, 30, "load");
Button b6 = new Button(0, 175, 100, 30, "fire");
boolean synapseMode=false;
color currentColor = color(0);
Neuron selectedN = null;
Neuron toBeAdded = null;
ArrayList<Neuron> neurons = new ArrayList<Neuron>();
PMatrix2D coordinateSystem;
PMatrix2D inverse;
float scale = 1;
PVector trans = new PVector();
JSONObject json;
PVector global = new PVector();
PVector local = new PVector();

boolean[] keys = new boolean[255];


void setup() {
  size(1000, 800);
  coordinateSystem = new PMatrix2D(); 
  coordinateSystem.translate(width * .5, height * .5);
  cc.x = width - 130;
  cc.add_button(b);
  cc.add_button(b2);
  cc.add_button(b3);
  cc.add_button(b4);
  cc.add_button(b5);
  cc.add_button(b6);
  loadFile("data1.json");
}

void draw() {

  update(mouseX, mouseY);
  background(currentColor);
  cc.draw();
  pushMatrix();
  coordinateSystem.reset();
  coordinateSystem.translate(width/2,height/2);
  coordinateSystem.translate(trans.x,trans.y);
  coordinateSystem.scale(scale);
  inverse = coordinateSystem.get();
  inverse.invert();
   //set global coordinates
  global.set(mouseX,mouseY);
  //compute local coordinates by multiplying the global coordinates to the inverse local coordinate system (transformation matrix)
  inverse.mult(global,local);
  
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

void mouseDragged() {
  if (selectedN != null) { 
    selectedN.pos.x = local.x;
    selectedN.pos.y = local.y;
  }
}
void mousePressed() {
  Neuron toBe = null;
  for (Neuron n : neurons) {
    if (n.mouseOver) {
      toBe = n;
      toBe.selected = true;
      break;
    }
  }
  if (toBe != null) {
    if (selectedN != null) {
      if (synapseMode) {
        selectedN.axon.add(toBe);
        selectedN.selected = false;
        toBe.selected = false;
        selectedN= null;
      } else {
        selectedN.selected = false;
        selectedN = toBe;
      }
    } else {
      selectedN = toBe;
    }
  }
}

void mouseReleased() {

  if (b.rectOver) {
  } else if (b2.rectOver) {
    synapseMode = false;
    toBeAdded = null;
  } else if (b3.rectOver) {
    toBeAdded = new Neuron(0, 0, neurons.size());
    synapseMode = false;
  } else if (b4.rectOver) {
    toBeAdded = null;
    synapseMode = !synapseMode;
  } else if (b5.rectOver) {    
    selectInput("Select a file to process:", "fileSelected");
  } else if (b6.rectOver) {
    if (selectedN != null) { 
      selectedN.fire();
    }
  } else {
    if (toBeAdded != null) { 
      neurons.add(toBeAdded);
      toBeAdded = new Neuron(0, 0, neurons.size());
    }
  }
}
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String filename = selection.getName();
    loadFile(filename);
  }
}

void loadFile(String filename) {
  json = loadJSONObject(filename);
  neurons =  new ArrayList<Neuron>();
  selectedN = null;
  JSONArray  nodes = json.getJSONArray("nodes");
  for (int i = 0; i < nodes.size(); i++) {
    JSONObject node = nodes.getJSONObject(i);
    Neuron n = new Neuron(node.getInt("x"), node.getInt("y"), node.getInt("id"));
    neurons.add(n);
  }
  JSONArray  links = json.getJSONArray("links");
  for (int i = 0; i < links.size(); i++) {
    JSONObject link = links.getJSONObject(i);
    int from = link.getInt("from");
    int to = link.getInt("to");
    Neuron n = neurons.get(from);
    Neuron tn = neurons.get(to);
    n.axon.add(tn);
  }
}

void keyPressed()
{
  keys[key]= true; 
}
void keyReleased(){
  keys[key]= false;
}
