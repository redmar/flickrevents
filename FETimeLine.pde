class FETimeLine implements Observer {
  FEDayCollection dayCollection;
  float resizeFactor;
  float locationX, locationY;
  boolean debug = false;
  
  FETimeLine(FEDayCollection dayCollection){
    this.dayCollection = dayCollection;
    resizeFactor = 150.0 / (float) dayCollection.getMaxPhotos();
    locationX = 20.0;
    locationY = 700.0;
  }
      
  void step(){

  }
  
  void renderTag(float startX, float startY, FEDay prev, FEDay next, FETag tag)
  {
    float x = startX, y = startY;
    beginShape();
      vertex(x, y);
      y = startY - (prev.getTag(tag.getTagName()).size() * resizeFactor);
      vertex(x, y);
      x += 10.0;
      y = startY - (tag.size() * resizeFactor);
      vertex(x,y);
      x += 10.0;
      y = startY -  (next.getTag(tag.getTagName()).size() * resizeFactor);
      vertex(x, y);
      y = startY;
      vertex(x, y);
      x -= 10.0;
      y = startY;
    endShape(CLOSE);
  }
  
  void setColor(int number)
  {
    switch (number)
    {
      case 0:
        fill(0.5,0.5,0);
        break;
      case 1:
        fill(0.0,1,0);
        break;
      case 2:
        fill(0.0,1,1);
        break;
      case 3:
        fill(0.0,0.0,1);
        break;
      case 4:
        fill(0.5,0.0,0);
        break;
    }
  }
  
  void render(){
    
    noStroke();
    float startX = locationX, startY = locationY;
    for(int i = 0; i < dayCollection.size(); i++){
      FEDay day = (FEDay) dayCollection.get(i);
      FEDay prevDay, nextDay;
      
      if (i == 0){
        prevDay = (FEDay) dayCollection.get(i);
      } else{
        prevDay = (FEDay) dayCollection.get(i - 1);
      }
      
      if (i == (dayCollection.size() - 1)){
        nextDay = (FEDay) dayCollection.get(i);
      } else {
        nextDay = (FEDay) dayCollection.get(i + 1);
      }
      
      for(int j = 0; j < day.size(); j++){
        FETag tag = (FETag) day.get(j);
        setColor(j);
//        log(day.getDate() + " " + tag.getTagName() + " " + tag.size());
        renderTag(startX, startY, prevDay, nextDay, tag);
      }
      startX += 20.0;
//      if (i == selected_day){
//        fill(1.0,1.0,0);
//        beginShape();
//          vertex(x, y);
//          y = a[i-1];
//          vertex(x, y);
//          x += fe_timeline_day_selected_width / 2.0;
//          y = a[i];
//          vertex(x,y);
//          x += fe_timeline_day_selected_width / 2.0;
//          y = a[i+1];
//          vertex(x, y);
//          y = 0;
//          vertex(x, y);
//        endShape(CLOSE);
//        
//        x -= fe_timeline_day_selected_width;
//        
//        fill(1.0,0.0,0);
//        beginShape();
//          y = a[i-1];
//          vertex(x, y);
//          y = a[i-1] + b[i-1];
//          vertex(x, y);
//          x += fe_timeline_day_selected_width / 2.0;
//          y = a[i] + b[i];
//          vertex(x,y);
//          x += fe_timeline_day_selected_width / 2.0;
//          y = a[i+1] + b[i+1];
//          vertex(x, y);
//          y = a[i+1];
//          vertex(x, y);
//          x -= fe_timeline_day_selected_width / 2.0;
//          y = a[i];
//          vertex(x,y);
//          x += fe_timeline_day_selected_width / 2.0;
//        endShape(CLOSE);
//      } else {
//        fill(1.0,1.0,0);
//        rect(x,0,fe_timeline_day_small_width,a[i]);
//        fill(1.0,0,0);
//        rect(x,a[i],fe_timeline_day_small_width, a[i] + b[i]);
//        x += fe_timeline_day_small_width;
//      }
    }
  }
  
  void log(String what) {
    if( FlickrEvents.DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
  
 /* This function will be called by the FEDateView class when it's date has changed.
  * Meaning the whole GUI has to change/recalculate to the new date. */
  void update(Observable o, Object arg) { 
    Date newDate = ((FEDateView)o).currentDate();
    log("needs to change to the new date of: " + newDate); 

    // TODO: change inner date here
  }
}
