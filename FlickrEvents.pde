
boolean search_on_startup = false;
boolean w_event = true;
FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
FEDateView dateView;
String cacheDir = "/users/benoist/flickrevents/cache/";

void setup() {
  smooth();
  colorMode(RGB, 1.0);

  frame.setResizable(true); 
  size(screen.width, screen.height-50);

  pg = new FEPhotoGroup(200,200,30);
  photo = new FEPhoto(this);

  fe_worldmap = new FEWorldMap();
  dateView = new FEDateView(this);
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  if(search_on_startup) {
    try {
      GregorianCalendar calendar = new GregorianCalendar(2009, 3, 28);
      for(int i = 0; i < 31; i++){
        calendar.add(Calendar.DATE, -1);
        String prevDay = df.format(calendar.getTime());
        if (!new File(cacheDir+prevDay).exists()){
          FEFlickrData fe_data = new FEFlickrData(prevDay);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  } else {
    FECacheReader cacheReader = new FECacheReader();
    FEDayCollection dayCollection = cacheReader.getDayCollection();
    fe_timeline = new FETimeLine(dayCollection);
//    try {
//      for (int i = 0; i < dayCollection.size(); i++){
//        FEDay day = (FEDay) dayCollection.get(i);
//        for (int j = 0; j < day.size(); j++){
//          FETag tag = (FETag) day.get(j);
//          System.out.println(day.getDate() + " " + tag.getTagName() + " " + tag.size());
//        }
//      }
//    } catch (Exception e) {
//      e.printStackTrace();
//    }
  }
  
  frameRate(24);
  
  frame.addComponentListener(new ComponentAdapter() {
    public void componentResized(ComponentEvent e) {
       int minHeight = 600; int minWidth = 800; 
       if(e.getSource()==frame) { 
         if (frame.getHeight() < minHeight) { frame.setSize(frame.getWidth(), minHeight); }
         if (frame.getWidth() < minWidth) { frame.setSize(frame.getHeight(), minWidth); }
       }
    }
  }); 
}

void draw() {
  background(0);

  fe_worldmap.step();
  fe_worldmap.render();

  pg.render();

  photo.step().render();

  fe_timeline.step();
  fe_timeline.render();
  
  dateView.step();
  dateView.render();
}

void mouseClicked() {
  System.out.println("click");
  fe_worldmap.processMouseClick(mouseX, mouseY);
}

void keyPressed(){
  if(key=='w'||key=='W'){
    w_event = !w_event;
  }
  if(key == CODED) {
    if(keyCode==LEFT) {
      dateView.gotoPrevDay(); 
      System.out.println("goto prev day");
    }
    if(keyCode==RIGHT) {
      dateView.gotoNextDay(); 
      System.out.println("goto next day");
    }
  }
} 

void keyReleased() {
}
