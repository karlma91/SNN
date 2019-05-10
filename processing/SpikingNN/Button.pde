
class Button
{
  int x, y;
  int rectW;
  int rectH;
  color rectColor, baseColor;
  color rectHighlight;
  color currentColor;
  boolean rectOver = false;

  String text;

  Button(int x, int y, int w, int h, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.rectW=w;
    this.rectH=h;
    this.rectColor = color(14);
    this.rectHighlight = color(255);
  }

  void draw_button()
  {
    if (rectOver) {
      fill(rectHighlight);
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

  void update_button(int cx, int cy) {
    if ( overRect(cx+x, cy+y, rectW, rectH) ) {
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
