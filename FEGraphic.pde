class FEGraphic {
  public float originx, originy;
  boolean mouseover = false;
  boolean mousedown = false;
  void display(float xpos, float ypos) { };
  void setMouseOver(boolean mouse_is_over_me) { this.mouseover = mouse_is_over_me; };
  void setMouseDown(boolean down) { mousedown = down; }
  void setRadius(float asize) {  };
  void displayPhotos() { };
  void releasePhotos() { };
  boolean over() { 
    return false;
  }
  void setShowPhotos(boolean yesorno) { };
}
