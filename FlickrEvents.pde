//Global global;
boolean w_event = true;
FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FlickrData fe_data;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
float[] points;

void setup() {
//  createGraphics
  
  // suck in variables
  /*
  String lines[] = loadStrings("subset.csv");
  points = new float[lines.length*2];
  
  println("there are " + lines.length + " lines");
  for (int i=0; i < lines.length; i++) {
    String[] p = lines[i].split("\t");
    points[i*2]     = Float.parseFloat(p[0]);
    points[(i*2)+1] = Float.parseFloat(p[1]); 
  }
  */
  smooth();
  colorMode(RGB, 1.0);

  frame.setResizable(true); 
  size(screen.width, screen.height-50);

  pg = new FEPhotoGroup(200,200,30);
  photo = new FEPhoto(this);

  fe_worldmap = new FEWorldMap();  
  fe_timeline = new FETimeLine();
  try {
    //*
    fe_data = new FlickrData("dance", 1, fe_worldmap);
    PhotoList photoList = fe_data.getPhotos(1);
    
    for(int i = 1; i <= photoList.getPages(); i++) {
      Thread thread = new Thread(new FlickrData("dance", i, fe_worldmap), "thread " + i);
      thread.start();
    }
    
    fe_data = new FlickrData("classic", 1, fe_worldmap);
    photoList = fe_data.getPhotos(1);
    
    for(int i = 1; i <= photoList.getPages(); i++) {
      Thread thread = new Thread(new FlickrData("classic", i, fe_worldmap), "thread " + i);
      thread.start();
    }
    //*/
    
    /*
    fe_data = new FlickrData("dance",1);  
    PhotoList photoList = fe_data.getPhotos(1);
    System.out.println(photoList.getTotal());
    points = new float[1000*2];
    int count = 0;
    for(int j=1; j <= photoList.getPages() && j < 2 ; j++){
      photoList = fe_data.getPhotos(j);
      for (int i=0; i < 150; i++) {
        Photo photo = (Photo) photoList.get(i);
        GeoData geo = photo.getGeoData();
        if (geo != null){
          fe_worldmap.addPhoto(photo);
//          count++;
//          points[i*2]     = geo.getLatitude()+(i/20.0);
//          points[(i*2)+1] = geo.getLongitude(); 
        }
      }
    }
    //*/
      //System.out.println(count);
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
  
//  if(w_event) {
//     for (int i=0; i < points.length/2; i++) {
//      fe_worldmap.renderGeoPoint(points[(i*2)+1],points[i*2]);
//    }
//  }

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
//  if(key=='w'||key=='W'){
//    w_event=false;
//  }
}
