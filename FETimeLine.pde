import java.lang.*;
class FETimeLine implements Observer {
  FEDayCollection dayCollection;
  float resizeFactor;
  float locationX, locationY;
  Date selectedDate;
  float selectedDateWidth;
  boolean update = false;
  boolean bounce = true;
  boolean debug = false;
  
  FETimeLine(FEDayCollection dayCollection){
    this.dayCollection = dayCollection;
    resizeFactor = (200/5) / (float) Math.log(dayCollection.getMaxPhotos());
    locationX = 20.0;
    locationY = 800.0;
  }
  
  void update(Observable obj, Object arg)
  {
    selectedDate = ((FEDateView)obj).currentDate();
    update = true;
  }
      
  void step(){
    if (update){
      selectedDateWidth = 30;
      update = false;
    } else if (selectedDateWidth < 200 && selectedDateWidth != 150) {
      selectedDateWidth += 100;
    } else {
      selectedDateWidth = 150;
    }
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
  
  void setColor(String number)
  {
    if (number.equals("rock")){
      fill(#fc00ff,0.8);
      stroke(#fc00ff);
    } else if (number.equals("classic")){
      fill(#00fcff,0.8);
      stroke(#00fcff);
    } else if (number.equals("trance")){
      fill(#2f78ff,0.8);
      stroke(#2f78ff);
    } else if (number.equals("pop")){
       fill(#a200ff,0.8);
      stroke(#a200ff);  //a200ff
    } else if (number.equals("jazz")){
      fill(#FF0000,0.8);
      stroke(#FF0000);
    }
  }
  
  void render(){
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
      
      float w;
      if (day.getDate().equals(selectedDate)){
        w = selectedDateWidth;
        for(int j = 0; j < day.size(); j++){
          FETag tag = (FETag) day.get(j);
          float h = (float) Math.max(Math.log(tag.size()) * resizeFactor, 0);
          setColor(tag.getTagName());
          rect(startX, startY - h, w, h);
          startY -= h;
        }
      } else {
        w = 20;
        for(int j = 0; j < day.size(); j++){
          FETag tag = (FETag) day.get(j);
          float h = (float) Math.max(Math.log(tag.size()) * resizeFactor, 0);
          setColor(tag.getTagName());
          rect(startX, startY - h, w, h);
          startY -= h;
        }
      }
      startY = locationY;
      startX += w;
    }
  }
  
  void log(String what) {
    if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
  
}
