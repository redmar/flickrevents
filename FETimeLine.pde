import java.lang.*;

class FETimeLine implements Observer {
  FEDayCollection dayCollection;
  float resizeFactor;
  float locationX, locationY;
  Date selectedDate;
  float selectedDateWidth;
  boolean update = false;
  boolean bounce = false;
  
  FETimeLine(FEDayCollection dayCollection){
    this.dayCollection = dayCollection;
    resizeFactor = (200/5) / (float) log(dayCollection.getMaxPhotos());
    locationX = 20.0;
    locationY = 800.0;
  }
  
  void update(Observable obj, Object arg)
  {
    selectedDate = (Date) arg;
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
      fill(#FF0000,0.5);
      stroke(#FF0000);
    } else if (number.equals("classic")){
      fill(#00FF00,0.5);
      stroke(#00FF00);
    } else if (number.equals("trance")){
      fill(#0000FF,0.5);
      stroke(#0000FF);
    } else if (number.equals("pop")){
       fill(#FFFF00,0.5);
      stroke(#FFFF00);
    } else if (number.equals("jazz")){
      fill(#FF00FF,0.5);
      stroke(#FF00FF);
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
          float h = (float) max(log(tag.size()) * resizeFactor, 0);
          setColor(tag.getTagName());
          rect(startX, startY - h, w, h);
          startY -= h;
        }
      } else {
        w = 20;
        for(int j = 0; j < day.size(); j++){
          FETag tag = (FETag) day.get(j);
          float h = (float) max(log(tag.size()) * resizeFactor, 0);
          setColor(tag.getTagName());
          rect(startX, startY - h, w, h);
          startY -= h;
        }
      }
      startY = locationY;
      startX += w;
    }
  }
}
