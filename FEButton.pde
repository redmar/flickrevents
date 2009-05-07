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
    if(over && mousePressed || locked) {
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
  
  CheckBox(int ix, int iy, int iw, int ih, int isc)
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    selectedColor = isc;
    checked = false;
  }
  
  void update()
  {
    over();
    pressed();
    if(!pressed && locked) {
      checked = !checked;
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
      rect(x+2,y+2, w-2, h-2);
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
