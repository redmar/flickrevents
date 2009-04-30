class FETimeLine {
  int[] a = new int[367];
  int[] b = new int[367];
  int maxPerDay = 0;
  float fe_timeline_height = 100;
  float fe_timeline_day_small_width;
  float fe_timeline_day_selected_width = 35;
  int selected_day = 11;
  
  FETimeLine(){
    generateArrays();
    fe_timeline_day_small_width = (float)1024 / 365.0;
  }
  
  void generateArrays(){
    Random generator = new Random(1);
    
    for(int i = 0; i < 367; i++){
      a[i] = generator.nextInt(50);
      b[i] = generator.nextInt(50);
      
      maxPerDay = Math.max(maxPerDay, Math.max(a[i], b[i]));
    }
  }
  
  void step(){
    
    if (mouseX > 1024){
      selected_day = 365;
    } else {
      selected_day = (int)((float) mouseX / fe_timeline_day_small_width);
    }
  }
  
  void render(){
    float x = 0;
    float y = 0;
    noStroke();
    for(int i = 1; i < 366; i++){
      //Draw a
      
      if (i == selected_day){
        fill(1.0,1.0,0);
        beginShape();
          vertex(x, y);
          y = a[i-1];
          vertex(x, y);
          x += fe_timeline_day_selected_width / 2.0;
          y = a[i];
          vertex(x,y);
          x += fe_timeline_day_selected_width / 2.0;
          y = a[i+1];
          vertex(x, y);
          y = 0;
          vertex(x, y);
        endShape(CLOSE);
        
        x -= fe_timeline_day_selected_width;
        
        fill(1.0,0.0,0);
        beginShape();
          y = a[i-1];
          vertex(x, y);
          y = a[i-1] + b[i-1];
          vertex(x, y);
          x += fe_timeline_day_selected_width / 2.0;
          y = a[i] + b[i];
          vertex(x,y);
          x += fe_timeline_day_selected_width / 2.0;
          y = a[i+1] + b[i+1];
          vertex(x, y);
          y = a[i+1];
          vertex(x, y);
          x -= fe_timeline_day_selected_width / 2.0;
          y = a[i];
          vertex(x,y);
          x += fe_timeline_day_selected_width / 2.0;
        endShape(CLOSE);
      } else {
        fill(1.0,1.0,0);
        rect(x,0,fe_timeline_day_small_width,a[i]);
        fill(1.0,0,0);
        rect(x,a[i],fe_timeline_day_small_width, a[i] + b[i]);
        x += fe_timeline_day_small_width;
      }
      /*

      */
    }
  }
  
  /* Old timeline
  PImage img;
  PImage fe_timeline;  
  float fe_timeline_xpos;
  float fe_timeline_ypos;
  float fe_timeline_drag = 30.0;
  
  FETimeLine() {
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
  */
}
