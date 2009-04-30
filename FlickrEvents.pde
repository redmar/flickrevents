//Global global;
boolean w_event = true;
FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
String cacheDir = "/Users/benoist/flickrevents/cache/";

void setup() {
  smooth();
  colorMode(RGB, 1.0);

  frame.setResizable(true); 
  size(screen.width, screen.height-50);

  pg = new FEPhotoGroup(200,200,30);
  photo = new FEPhoto(this);

  fe_worldmap = new FEWorldMap();  
  fe_timeline = new FETimeLine();
  try {
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date date = df.parse("2009-04-28");
    for(int i = 0; i < 31; i++){
      String prevDay = df.format((date.getTime() - i * 1000*3600*24));
      if (!new File(cacheDir+prevDay).exists()){
        FEFlickrData fe_data = new FEFlickrData(prevDay);
      }
    }
  } catch (Exception e) {
    e.printStackTrace();
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
}

void mouseClicked() {
  System.out.println("click");
  fe_worldmap.processMouseClick(mouseX, mouseY);
}

void keyPressed(){
  if(key=='w'||key=='W'){
    w_event = !w_event;
  }
} 

void keyReleased() {
}
