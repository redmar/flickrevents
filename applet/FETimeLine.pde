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
}