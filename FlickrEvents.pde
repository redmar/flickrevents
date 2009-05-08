
// Global Preferences ////////////////
static final boolean DEBUG = true;
boolean search_on_startup  = false;
String[] tagOrder = {"rock","classic","trance","pop","jazz"};
ArrayList selectedTags = new ArrayList(Arrays.asList(tagOrder));
String[] unwantedTags = {"rock","classic","trance","pop","jazz","music"};
ArrayList tagFilter = new ArrayList(Arrays.asList(unwantedTags));
//////////////////////////////////////

FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
FEDateView dateView;
FEGui gui;
String cacheDir;
boolean w_event = true;
boolean debug = false;
PFont font = createFont("FuturaLT", 32);
GregorianCalendar calendar = new GregorianCalendar(2009, 3, 27);

void setup() {
  smooth();
  colorMode(RGB, 1.0);
  cacheDir = sketchPath + "/cache/";

  log("cachedir:" + cacheDir);
  frame.setResizable(true); 
//  size(screen.width, screen.height-50);
  size(1024, 768);
//  pg = new FEPhotoGroup(200,200,30);
//  photo = new FEPhoto(this);


  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  if(search_on_startup) {
//    try {
//      for(int i = 0; i < 31; i++){
//        calendar.add(Calendar.DATE, -1);
//        String prevDay = df.format(calendar.getTime());
//        if (!new File(cacheDir+prevDay).exists()){
//          FEFlickrData fe_data = new FEFlickrData(prevDay);
//        }
//      }
//    } catch (Exception e) {
//      e.printStackTrace();
//    }
  } else {
    FECacheReader cacheReader = new FECacheReader();
    FEDayCollection dayCollection = cacheReader.getDayCollection();
    fe_worldmap = new FEWorldMap(dayCollection);
    dateView = new FEDateView(this);
    dateView.addObserver(fe_worldmap);
    fe_timeline = new FETimeLine(dayCollection);
    dateView.addObserver(fe_timeline);
    gui = new FEGui(dayCollection);
    dateView.addObserver(gui);
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
  
  gui.step();
  gui.render();

  fe_worldmap.step();
  fe_worldmap.render();

  fe_timeline.step();
  fe_timeline.render();
  
  dateView.step();
  dateView.render();
}

void mousePressed() {
  fe_worldmap.processMousePressed(mouseX, mouseY);
}

void mouseReleased() {
  fe_worldmap.processMouseReleased(mouseX, mouseY);
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
    if(keyCode==UP) {
      for (int i=0; i < springCount; i++) {
        float oldx = springs[i].rest_posx; 
        float oldy = springs[i].rest_posy;
        float nx = oldx + random(100) - 50;
        float ny = oldy + random(100) - 50;
        springs[i].setPosition(nx, ny);
        springs[i].setTempPosition(oldx, oldy);
        //springs[i].setRadius(3 + random(200));
      }
    }
  }
} 

void keyReleased() {
}

void log(String what) {
  if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
}

static int getTagColor(String tag)
{
  if (tag.equals("rock")){
    return #FF0000;
  } else if (tag.equals("classic")){
    return #00FF00;
  } else if (tag.equals("trance")){
    return #0000FF;
  } else if (tag.equals("pop")){
    return #FFFF00;
  } else if (tag.equals("jazz")){
    return #FF00FF;
  }
  return -1;
}


HashMap addHashMapValues(HashMap first, HashMap second){
  ArrayList mapKeys = new ArrayList(second.keySet());
  for(int i = 0; i < mapKeys.size(); i++){
    int count = (Integer) second.get(mapKeys.get(i));
    if (first.containsKey(mapKeys.get(i))){
      count += (Integer) first.get(mapKeys.get(i));
    }
    first.put(mapKeys.get(i), count);
  }
  return first;
}

LinkedHashMap sortHashMapByValuesD(HashMap passedMap, boolean descending) {
  ArrayList mapKeys = new ArrayList(passedMap.keySet());
  ArrayList mapValues = new ArrayList(passedMap.values());
  Collections.sort(mapValues);
  Collections.sort(mapKeys);
  
  if (descending){
    Collections.reverse(mapValues);
  }
      
  LinkedHashMap sortedMap = 
      new LinkedHashMap();
  
  Iterator valueIt = mapValues.iterator();
  while (valueIt.hasNext()) {
    Object val = valueIt.next();
    Iterator keyIt = mapKeys.iterator();
    
    while (keyIt.hasNext()) {
      Object key = keyIt.next();
      String comp1 = passedMap.get(key).toString();
      String comp2 = val.toString();
      
      if (comp1.equals(comp2)){
          passedMap.remove(key);
          mapKeys.remove(key);
          sortedMap.put((String)key, (Object)val);
          break;
      }
    }
  }
  return sortedMap;
}

