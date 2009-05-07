import java.lang.*;
class FETimeLine implements Observer {
  FEDayCollection dayCollection;
  float resizeFactor;
  float locationX, locationY, stdBinWidth;
  Date selectedDate;
  float selectedDateWidth;
  boolean update = false;
  boolean bounce = true;
  boolean debug = false;
  float maxPhotosFactor;
  
  FETimeLine(FEDayCollection dayCollection){
    this.dayCollection = dayCollection;
    maxPhotosFactor = 30 / (float) dayCollection.getMaxPhotos();
    resizeFactor = (400/5) / (float) Math.log(31);
    resizeFactor = 200 / (float) dayCollection.getMaxPhotos();
    selectedDateWidth = 60;
    selectedDate = calendar.getTime();
    locationX = 20.0;
    stdBinWidth = 10.0;
    locationY = 760.0;
  }
  
  void update(Observable obj, Object arg)
  {
    selectedDate = ((FEDateView)obj).currentDate();
    update = true;
  }
      
  void step(){
  }
  
  void render(){
    float startX = locationX;
    for(int i = 0; i < dayCollection.size(); i++){
      FEDay day = (FEDay) dayCollection.get(i);
      FEDay nextDay;
      
      if (i == (dayCollection.size() - 1)){
        nextDay = null;
      } else {
        nextDay = (FEDay) dayCollection.get(i + 1);
      }
      
      if(day.getDate().equals(selectedDate)){
        renderDay(startX, day, nextDay, true);
        startX += selectedDateWidth + stdBinWidth;
      } else {
        renderDay(startX, day, nextDay, false);
        startX += stdBinWidth*2;
      }
    }
  }
  
  void renderDay(float startX, FEDay day, FEDay nextDay, boolean isSelected){
    float startY = locationY, nextY = locationY, binWidth;
    if (isSelected){
      noStroke();
      fill(0.1);
      rect(startX, locationY - 200, selectedDateWidth, 200);
      binWidth = selectedDateWidth;
    } else {
      binWidth = stdBinWidth;
    }
    for(int i = 0; i < tagOrder.length; i++){
      float h, nextH;
      
      //Render Rect
      FETag tag = day.getTag(tagOrder[i]);
      if (isSelected){
        tag.setColor(0.6);
      } else {
        tag.setColor(0.4);
      }
      
      h = (float) Math.log(1+maxPhotosFactor*tag.size()) * resizeFactor;
      h = (float) tag.size() * resizeFactor;
      rect(startX, startY - h, binWidth, h);
      
      //Render quad
      tag.setColor(0.4);
      if (nextDay != null){
        FETag nextTag = nextDay.getTag(tagOrder[i]);
        nextH = (float) Math.log(1+maxPhotosFactor*nextTag.size()) * resizeFactor;
        nextH = (float) nextTag.size() * resizeFactor;
        quad(startX + binWidth, startY - h, startX + stdBinWidth + binWidth, nextY - nextH, startX + stdBinWidth + binWidth, nextY, startX + binWidth, startY);
      
        nextY -= nextH;
      }
      startY -= h;
    }
  }
  
  void log(String what) {
    if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
  
}
