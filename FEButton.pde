class Button
{
  int x, y;
  int w, h;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;
  boolean locked = false;
  
  void over() 
  {
    if( overRect(x, y, w, h) ) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void pressed() {
    if(over && mousePressed) {
      pressed = true;
      locked = true;
    } else {
      pressed = false;
    }    
  }
  
  void release() {
    locked = false;
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

class CheckBox extends Button
{
  int selectedColor;
  boolean checked;
  float spaceFactor = 0.15;
  
  CheckBox(int ix, int iy, int iw, int ih, int isc, boolean ic)
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    selectedColor = isc;
    checked = ic;
  }
  
  void update()
  {
    over();
    pressed();
    if(!pressed && locked) {
      checked = !checked;
      release();
    }
  }
  
  void display()
  {
    stroke(1);
    noFill();
    rect(x,y,w,h);
    if (checked){
      noStroke();
      fill(selectedColor,0.5);
      rect(x+w*spaceFactor,y+h*spaceFactor, w+2-(2*w*spaceFactor), h+2-(2*h*spaceFactor));
    }
  }
}

class ImageButtons extends Button 
{
  PImage base;
  PImage roll;
  PImage down;
  PImage currentimage;

  ImageButtons(int ix, int iy, int iw, int ih, PImage ibase, PImage iroll, PImage idown) 
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    base = ibase;
    roll = iroll;
    down = idown;
    currentimage = base;
  }
  
  void update() 
  {
    over();
    pressed();
    if(pressed) {
      currentimage = down;
    } else if (over){
      currentimage = roll;
    } else {
      currentimage = base;
    }
  }
    
  void display() 
  {
    image(currentimage, x, y);
  }
}
