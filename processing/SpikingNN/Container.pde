class Container {
  int x_pos;
  int y_pos;
  ArrayList<Button> buttons = new ArrayList<Button>();
  
  Container( int x, int y) {
    this.x_pos = x;
    this.y_pos = y;
  }

  void add_button(Button button)
  {
    buttons.add(button);
  }

  void draw() {
    push();
    translate(x_pos,y_pos);
    for (Button b : this.buttons) {
      b.draw_button();
    }
    pop();
  }

  void update() {
    for (Button b : this.buttons) {
      b.update_button(x_pos,y_pos);
    }
  }
  
  void setActiveButton(Button b, boolean override) {
    for (Button otherButton : this.buttons) {
      if (otherButton != b) {
        otherButton.activeAction = false;
      }
    } 
    b.activeAction = true;
  }
  
  void setActiveButton(Button b) {
    for (Button otherButton : this.buttons) {
      if (otherButton == b) {
        b.activeAction = !b.activeAction;
      } else {
        otherButton.activeAction = false;
      }
    }
  }
}
