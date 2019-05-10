class Container {
  int x;
  int y;
  ArrayList<Button> buttons = new ArrayList<Button>();
  Container( int x, int y) {
    this.x = x;
    this.y = y;
  }

  void add_button(Button button)
  {
    buttons.add(button);
  }

  void draw() {
    translate(x,y);
    for (Button b : this.buttons) {
      b.draw_button();
    }
    translate(-x,-y);
  }

  void update() {
    for (Button b : this.buttons) {
      b.update_button(x,y);
    }
  }
}
