class FEPhoto {
  PImage img;
  PImage fe_timeline;  
  float fe_timeline_xpos;
  float fe_timeline_ypos;
  float fe_timeline_drag = 30.0;

  // requestImage(filename)
  //
  // LOAD SHIT ASYNC!
  //
  // 
  //

  FEPhoto() {
    fe_timeline = loadImage("timeline.png");  // Load the image into the program  
    fe_timeline_xpos = (width/2)-(fe_timeline.width/2);
    fe_timeline_ypos = height-fe_timeline.height;
  }

  void step() {
    float difx = (width/2)-(fe_timeline.width/2) - fe_timeline_xpos;
    if(abs(difx) > 1.0) {
      fe_timeline_xpos = fe_timeline_xpos + difx/fe_timeline_drag;
      fe_timeline_xpos = constrain(fe_timeline_xpos, 0, (width/2)-(fe_timeline.width/2));
    }  
  
    float dify = height-fe_timeline.height - fe_timeline_ypos;
    if(abs(dify) > 1.0) {
      fe_timeline_ypos = fe_timeline_ypos + dify/fe_timeline_drag;
      fe_timeline_ypos = constrain(fe_timeline_ypos, 0, height-fe_timeline.height);
    }  
  }

  void render() {
    // Displays the image at point (100, 0) at half of its size
    image(fe_timeline, fe_timeline_xpos, fe_timeline_ypos);
  }
}
