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
  float totalWidth;
  
  FETimeLine(FEDayCollection dayCollection){
    this.dayCollection = dayCollection;
    resizeFactor = 200 / (float) dayCollection.getMaxPhotos();
    selectedDateWidth = 60;
    selectedDate = calendar.getTime();
    locationX = 10;
  }
  
  void update(Observable obj, Object arg)
  {
    selectedDate = ((FEDateView)obj).currentDate();
    update = true;
  }
      
  void step(){
    locationY = height - ((stdBinWidth+4)*2);
    stdBinWidth = (float) Math.floor((width - 300) / dayCollection.size()/2);
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
      fill(1,1,1,0.1);
      rect(startX, locationY - 200, selectedDateWidth, 200 + stdBinWidth*2+8);
      binWidth = selectedDateWidth;
    } else {
      binWidth = stdBinWidth;
    }
    fill(1);
    textFont(font,stdBinWidth);
    SimpleDateFormat df = new SimpleDateFormat("dd");
    text(df.format(day.getDate()),startX + (binWidth/2 - 1- (stdBinWidth/2)), startY + stdBinWidth+3);
    df = new SimpleDateFormat("E");
    text(df.format(day.getDate()).charAt(0),startX + (binWidth/2 - 4), startY + stdBinWidth*2+6);
    for(int i = 0; i < tagOrder.length; i++){
      if (!selectedTags.contains(tagOrder[i])){
        continue;
      }
      float h, nextH;
      
      //Render Rect
      FETag tag = day.getTag(tagOrder[i]);
      if (isSelected){
        tag.setColor(0.6);
      } else {
        tag.setColor(0.4);
      }
      
      h = (float) tag.size() * resizeFactor;
      rect(startX, startY - h, binWidth, h);
      
      //Render quad
      tag.setColor(0.4);
      if (nextDay != null){
        FETag nextTag = nextDay.getTag(tagOrder[i]);
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
