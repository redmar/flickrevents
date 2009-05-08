int springCount = 0;
int num = 100; 
FESpring[] springs = new FESpring[num]; 

class FEWorldMap implements Observer {
  PImage img;
  float xpos;
  float ypos;
  float drag = 30.0;
  float img_width, img_height;
  Vector photoGroups;
  boolean debug = false;
  Date selectedDate;
  FEDayCollection dayCollection;
  FEDay currentDay;
  boolean springs_synced = true;
  
  FEWorldMap(FEDayCollection aDayCollection) { //FEDayCollection
    dayCollection = aDayCollection;
    img = loadImage("mapbw.png");  // Load the image into the program
    xpos = 10;//(width/2)-(img_width/2);
    ypos = 50;//(height/2)-(img_height/2);
    photoGroups = new Vector();
  }

  // walk each photogroup if we're inside a given radius add it to that group
  public synchronized void addPhoto(FEFlickrPhoto p, String tagname) {
   
    boolean added = false;
    for (int i=0; i < photoGroups.size(); i++) {
//      GeoData geo = p.getGeoData();
      if( (((FEPhotoGroup)photoGroups.get(i)).getTagname()).equals(tagname) && ((FEPhotoGroup)photoGroups.get(i)).is_inside(p.getLongitude(), p.getLatitude()) ) { 
        ((FEPhotoGroup)photoGroups.get(i)).addPhoto(p); added = true;
      }
    }
    if(!added) {
      // create new photogroup and put this image in it!
      FEPhotoGroup newPhotoGroup = new FEPhotoGroup();
      newPhotoGroup.setTagname(tagname);
      newPhotoGroup.addPhoto(p);
      photoGroups.add(newPhotoGroup);
    }
    springs_synced = false;
  }
  
  void loadDay() {
    photoGroups = new Vector();
    int groupidx = 0;
    
    String[] tagOrder = {"rock","classic","trance","pop","jazz"};
    for(int i = 0; i < tagOrder.length; i++){
        FETag tag = currentDay.getTag(tagOrder[i]);
        for(int idx = 0; idx < tag.size(); idx++){
          FEFlickrPhoto tmpPhoto = ((FEFlickrPhoto)tag.get(idx));
          addPhoto( tmpPhoto, tag.getTagName() );
        }
    }        
  }
  
  void processMousePressed(float mx, float my) { 
    for (int i=0; i < springCount; i++) {
      if(springs[i].over()) {
        springs[i].pressed();
        System.out.println(springs[i].getPhotogroup().photos);
      }
    }
  }

  void processMouseReleased(float mx, float my) { 
    for (int i=0; i < springCount; i++) {
//      if(springs[i].over()) 
      springs[i].released();
    }
  }

  void step() {
    img_width = width-270;
    img_height = height-220;

    for (int i=0; i < photoGroups.size(); i++) {
      ((FEPhotoGroup)photoGroups.get(i)).step(this);
    }

    for (int i=0; i < springCount; i++) {
      springs[i].update();
    }
  }
  
  void render() {
    image(img, xpos, ypos, img_width, img_height);
    
    if( springs_synced == false ) {
      for (int i=0; i < photoGroups.size(); i++) {
        FEPhotoGroup group = ((FEPhotoGroup)photoGroups.get(i));
        group.worldmap = this;
        if(i < springCount) {
          springs[i].moveTo(group.getX(), group.getY());
//          springs[i].setPosition(group.getX(), group.getY());
          springs[i].setRadius(group.getRadius());
        }
        else {
          springs[i] = new FESpring(group.getX(), group.getY(), 3.0, 0.80, 10, 0.9, springs, 0);
          springs[i].setRadius(group.getRadius());
          springCount++;
        }
        FECircleGraphic myDisplayFunctor = new FECircleGraphic(20);
        myDisplayFunctor.setTag(group.getTagname());
        springs[i].setDisplayFunctor(myDisplayFunctor);
        springs[i].setPhotogroup(group);
      }
      // remove unused springs
      for(int i=photoGroups.size(); i < springCount; i++) { springs[i] = null; }
      springCount = photoGroups.size();
      springs_synced = true;
    }

    for(int i=0; i < springCount; i++) {
      if( springs[i].getPhotogroup() != null && 
          selectedTags.contains(springs[i].getPhotogroup().tagname) ) {
          springs[i].display();
      }
    }
  }
  
  void renderGeoPoint(float longitude_x, float latitude_y) 
  {
    float pointXlong = longToX(longitude_x);
    float pointYlat  = latToY(latitude_y);  //  -90     90 
    
    stroke(255,0,0);
    point(pointXlong, pointYlat);
  }
  
  float longToX(float longitude)
  {
    return xpos + ((img_width / 360.0) * (longitude + 180));
  }
  
  float latToY(float latitude)
  {
    return ypos + ((img_height / 180.0) * (-1 * (latitude - 90)));
  }
  
 /* This function will be called by the FEDateView class when it's date has changed.
  * Meaning the whole GUI has to change/recalculate to the new date. */
  void update(Observable o, Object arg) { 
    selectedDate = ((FEDateView)o).currentDate();
    currentDay = dayCollection.getDay(selectedDate);
    loadDay();
  }
  
  void log(String what) {
    if(DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
}

class FECircleGraphic extends FEGraphic
{
  float radius = 10.0;
  FETag mytag = null;
  
  FECircleGraphic(float aradius) { 
    this.radius = aradius; 
  }
  
  void display(float xpos, float ypos) {
    noStroke();
    if (mouseover) {
      if (mytag != null) {
        fill(getTagColor(mytag.getTagName()),0.5);
        stroke(getTagColor(mytag.getTagName()), 0.5);
      }
    }
    else {
      if (mytag != null) {
        fill(getTagColor(mytag.getTagName()),0.8);
        stroke(getTagColor(mytag.getTagName()), 0.8);
      }
    }
    ellipseMode(CENTER);
    ellipse(xpos, ypos, radius, radius);      
  }
  
  void setRadius(float asize) 
  {
    float logsize = (float)Math.log(max(asize,1.0));
    asize = max(logsize*15,5.0);
    this.radius = asize;
  }
  
  void setTag(String atag) {
    mytag = new FETag(atag);
  }
}
