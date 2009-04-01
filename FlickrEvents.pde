//Global global;
boolean w_event = true;
FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FlickrData fe_data;
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
  frame.setResizable(true); 
  size(screen.width, screen.height-50);

  fe_worldmap = new FEWorldMap();  
  fe_timeline = new FETimeLine();
  try {
    fe_data = new FlickrData();  
    PhotoList photoList = fe_data.getPhotos(1);
    System.out.println(photoList.getTotal());
    points = new float[1000*2];
    int count = 0;
    for(int j=1; j <= photoList.getPages() && j < 2 ; j++){
      photoList = fe_data.getPhotos(j);
      for (int i=0; i < photoList.getPerPage(); i++) {
        Photo photo = (Photo) photoList.get(i);
        GeoData geo = photo.getGeoData();
        if (geo != null){
          count++;
          points[i*2]     = geo.getLatitude()+(i/20.0);
          points[(i*2)+1] = geo.getLongitude(); 
        }
      }
      
      //System.out.println(count);
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  frameRate(60);
  
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
  background(102);

  fe_worldmap.step();
  fe_worldmap.render();

  if(w_event) {
     for (int i=0; i < points.length/2; i++) {
      fe_worldmap.renderGeoPoint(points[(i*2)+1],points[i*2]);
    }
//    fe_worldmap.renderGeoPoint(4.895976, 52.369370); // adam
//    fe_worldmap.renderGeoPoint(-73.986951, 40.756054);  // ny
  }

  fe_timeline.step();
  fe_timeline.render();
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
