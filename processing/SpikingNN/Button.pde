class Button
{
  int x, y;
  int rectW;
  int rectH;
  color rectColor, baseColor;
  color rectHighlight;
  color currentColor;
  color activeColor;
  
  boolean rectOver = false;
  boolean activeAction = false;

  String text;

  Button(int x, int y, int w, int h, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.rectW=w;
    this.rectH=h;
    this.rectColor = color(150);
    this.rectHighlight = color(255);
    this.activeColor = color(255,0,0);
  }

  void draw_button()
  {
    if (rectOver) {
      fill(rectHighlight);
    } else if (activeAction) {
      fill(activeColor);
    } else {
      fill(rectColor);
    }
    stroke(255);
    rect(x, y, rectW, rectH);
    int fontSize =24;
    textSize(24);
    fill(0, 102, 153);
    text(this.text, x + 10, y + (rectH/2 + fontSize/4) );
  }

  void update_button(int container_x_pos, int container_y_pos) {
    if ( overRect(container_x_pos + x, container_y_pos + y, rectW, rectH) ) {
      rectOver = true;
    } else {
      rectOver = false;
    }
  }

  boolean overRect(int x, int y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  
}
