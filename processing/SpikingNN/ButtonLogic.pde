Container cc = new Container(100, 10);

Button saveButton = new Button(0, 0, 100, 30, "save");
Button removeButton = new Button(0, 35, 100, 30, "remove");
Button addButton = new Button(0, 70, 100, 30, "add");
Button synapsButton = new Button(0, 105, 100, 30, "synaps");
Button loadButton = new Button(0, 140, 100, 30, "load");
Button fireButton = new Button(0, 175, 100, 30, "fire");

boolean synapseMode = false;
Neuron selectedN = null;
Neuron toBeAdded = null;

void mouseDragged() {
  if (selectedN != null) { 
    selectedN.pos.x = local.x;
    selectedN.pos.y = local.y;
  } else {
    trans.x+=mouseX-pmouseX;
    trans.y+=mouseY-pmouseY;
  }
}

void mousePressed() {
  Neuron toBe = null;
  for (Neuron n : neurons) {
    if (n.mouseOver) {
      toBe = n;
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
        if (toBe == selectedN) { 
          selectedN.selected = false;
          selectedN = null;
        } else {
          selectedN.selected = false;
          selectedN = toBe;
          toBe.selected = true;
        }
      }
    } else {
      selectedN = toBe;
      selectedN.selected = true;
    }
  } else {
    //if (selectedN != null) {
    //  selectedN.selected = false;
    //  selectedN = null;
    //}
  }
}


void mouseReleased() {
  if (saveButton.rectOver) {
    
    synapseMode = false;
    toBeAdded = null;
    cc.setActiveButton(saveButton);
    
  } else if (removeButton.rectOver) {
    
    synapseMode = false;
    cc.setActiveButton(removeButton);
    synapseMode = false;
    toBeAdded = null;
    
  } else if (addButton.rectOver) {
    
    cc.setActiveButton(addButton, true);
    toBeAdded = new Neuron(0, 0, neurons.size());
    synapseMode = false;
    
  } else if (synapsButton.rectOver) {
    
    cc.setActiveButton(synapsButton);
    toBeAdded = null;
    synapseMode = !synapseMode;
    
  } else if (loadButton.rectOver) {
    
    cc.setActiveButton(loadButton);
    selectInput("Select a file to process:", "fileSelected");
    synapseMode = false;
    toBeAdded = null;
    
  } else if (fireButton.rectOver) {
    
    synapseMode = false;
    toBeAdded = null;
    cc.setActiveButton(fireButton);
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
