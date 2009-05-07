
// Global Preferences ////////////////
static final boolean DEBUG = true;
boolean search_on_startup  = false;
String[] tagOrder = {"rock","classic","trance","pop","jazz"};
ArrayList selectedTags;
//////////////////////////////////////

FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
FEDateView dateView;
String cacheDir;
boolean w_event = true;
boolean debug = false;
GregorianCalendar calendar = new GregorianCalendar(2009, 3, 27);
CheckBox check = new CheckBox(10,10,20,20,#FF0000);

void setup() {
  smooth();
  colorMode(RGB, 1.0);
  cacheDir = sketchPath + "/cache/";
  selectedTags = new ArrayList();
  for(int i = 0; i < tagOrder.length; i++){
    selectedTags.add(tagOrder[i]);
  }
  
  frame.setResizable(true); 
//  size(screen.width, screen.height-50);
  size(1024, 768);
  
//  pg = new FEPhotoGroup(200,200,30);
//  photo = new FEPhoto(this);

  fe_worldmap = new FEWorldMap();
  dateView = new FEDateView(this);
  dateView.addObserver(fe_worldmap);

  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  if(search_on_startup) {
    try {
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
    dateView.addObserver(fe_timeline);
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

//  pg.render();

//  photo.step().render();

  fe_timeline.step();
  fe_timeline.render();
  
  dateView.step();
  dateView.render();
  
  check.update();
  check.display();
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
//      System.out.println("goto prev day");
    }
    if(keyCode==RIGHT) {
      dateView.gotoNextDay(); 
//      System.out.println("goto next day");
    }
  }
} 

void keyReleased() {
}

void log(String what) {
  if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
}
