import java.lang.*;
class FETimeLine implements Observer {
  FEDayCollection dayCollection;
  ArrayList timeLineButtons;
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
    locationX = 30;
    timeLineButtons = new ArrayList();
    for(int i = 0; i < dayCollection.size(); i++){
      FEDay day = (FEDay)dayCollection.get(i);
      TimeLineDay timeLineDay = new TimeLineDay(day.getDate());
      timeLineButtons.add(timeLineDay);
    }
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
    resizeFactor = 200 / (float) dayCollection.getMaxPhotos();
    float startX = locationX;
    renderAxis();
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
  
  void renderAxis()
  {
    stroke(0.1);
    line(locationX, locationY, locationX, locationY - 200);
    line(locationX + 60 + 60*stdBinWidth, locationY, locationX + 60 + 60*stdBinWidth, locationY - 200);
    textFont(font, 8);
    fill(1);
    int labelStep = dayCollection.getMaxPhotos() / 20;
    int maxPhotos = dayCollection.getMaxPhotos();
    for(int i = 0; i < 20; i++){
      line(locationX - 25, locationY - 200 + i*10, locationX + 60 + 60*stdBinWidth, locationY - 200 + i*10);
      text(maxPhotos - labelStep * (i),locationX - 25, locationY + 4 - 200 + i*10);
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
      TimeLineDay timeLineDay = (TimeLineDay)timeLineButtons.get(dayCollection.indexOf(day));
      timeLineDay.update(startX, locationY - 200, stdBinWidth, 200 + stdBinWidth*2+8);
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
      tag.setColor(0.35);
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
