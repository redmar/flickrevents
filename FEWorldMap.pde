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
    selectedDate = calendar.getTime();
    currentDay = dayCollection.getDay(selectedDate);
    loadDay();
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
    if(currentDay == null) return;
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
//        System.out.println(springs[i].getPhotogroup().photos);
      } else {
        springs[i].hardRelease();
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
    imageMode(CORNER);
    image(img, xpos, ypos, img_width, img_height);
    
    if( springs_synced == false ) {
      for (int i=0; i < photoGroups.size(); i++) {
        FEPhotoGroup group = ((FEPhotoGroup)photoGroups.get(i));
        group.worldmap = this;
        if(springs[i] != null && i < springCount) {
        }
        else {
          springs[i] = new FESpring(0.0, 0.0, 1.0, 0.80, 10, 0.9, springs, 0);
          springCount++;
        }
        FECircleGraphic myDisplayFunctor = new FECircleGraphic(1.0);
        myDisplayFunctor.setTag(group.getTagname());
        myDisplayFunctor.setPhotoGroup(group);
        springs[i].setDisplayFunctor(myDisplayFunctor);
        springs[i].setPhotoGroup(group);
        springs[i].setRadius(group.getRadius());
        springs[i].moveTo(group.getX(), group.getY());
      }
      // remove unused springs
      for(int i=photoGroups.size(); i < springCount; i++) { springs[i] = null; }
      springCount = photoGroups.size()-1;
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
  float x, y;
  FETag mytag = null;
  FEPhotoGroup photoGroup = null;
  Vector photos = null;
  boolean releasephotos = false;
  boolean showphotos = false;
  public float tempxpos, tempypos;
  
  FECircleGraphic(float aradius) { 
    this.radius = aradius; 
  }
  
  void display(float xpos, float ypos) {
    this.x = xpos; this.y = ypos;
    noStroke();
    if (mouseover) {
      if (mytag != null) {
        fill(getTagColor(mytag.getTagName()),0.5);
        stroke(getTagColor(mytag.getTagName()), 0.5);
        line(tempxpos, tempypos, xpos, ypos);
      }
    }
    else {
      if (mytag != null) {
        fill(getTagColor(mytag.getTagName()),0.8);
        stroke(getTagColor(mytag.getTagName()), 0.8);
      }
    }
    ellipseMode(CENTER_DIAMETER);
//    ellipseMode(CENTER);
    ellipse(xpos, ypos, this.radius, this.radius);      
    if( showphotos ) { displayPhotos(); }
  }
  
  void releasePhotos() { 
    if( photos == null ) return;
    releasephotos = true;
    for(int i=0; i< max_photos(); i++) {
      ((FESpring)photos.get(i)).moveTo(x,y);
      ((FESpring)photos.get(i)).setRadius(1.0);
    }
  }
  
  void setShowPhotos(boolean yesorno) {
    if(yesorno == true) {
      showphotos = true;
    }
    else {
      releasePhotos();
    }
  }
      
  void displayPhotos() {
    if(photos == null) initPhotos();
    if( releasephotos ) {
      boolean all_at_rest = true;
      for(int i=0; i< max_photos(); i++) {
        FESpring currentSpring = ((FESpring)photos.get(i));
        currentSpring.update();
        currentSpring.display();
        if( !currentSpring.atRest() ) all_at_rest = false;
      }
      if( all_at_rest ) { photos = null; showphotos = false; } 
      return;
    }    

    for(int i=0; i< max_photos(); i++) {
      for(int j=0; j< max_photos(); j++) {
        if(j!=i)
        {
          vector f=getSpringForce(((FESpring)photos.get(i)).position(), ((FESpring)photos.get(j)).position(), 200, .5);
//          System.out.println(i + "," + j + " displace: " + ((FESpring)photos.get(i)).position().displace(f.a,0.15*f.m) );
          position newpos = ((FESpring)photos.get(i)).position().displace(f.a,0.15*f.m);
          ((FESpring)photos.get(i)).setPosition(newpos.x, newpos.y);
        }
        else {
//          boolean overphoto = ((FESpring)photos.get(i)).over();
          vector f=getSpringForce(((FESpring)photos.get(i)).position(), new position(x,y), getRadius()+50, .9);
//          System.out.println(i + "," + j + " displace: " + ((FESpring)photos.get(i)).position().displace(f.a,0.15*f.m) );
          position newpos = ((FESpring)photos.get(i)).position().displace(f.a,0.15*f.m);
          ((FESpring)photos.get(i)).setPosition(newpos.x, newpos.y);  
//          if( overphoto ) 
//            ((FESpring)photos.get(i)).setRadius(getRadius()*10);
        }
      }
    }
    for(int i=0; i< max_photos(); i++) {
      ((FESpring)photos.get(i)).update();
      ((FESpring)photos.get(i)).display();
    }
  }
  
  int max_photos() {
    // should be photos.size() if you want to see ALL photos!
    return min(12,photoGroup.getPhotoCount());
  }
  
  void initPhotos() {
    releasephotos = false;
//    photos = new Vector(photoGroup.getPhotoCount());
    photos = new Vector(max_photos());
    for(int i=0; i<max_photos(); i++) {
      FEFlickrPhoto p = (FEFlickrPhoto)photoGroup.photos.get(i);
      FESpring newSpring = new FESpring(x+random(50)-25, y+random(50)-25, 1.0, 0.80, 10, 0.9, null, 0);
      FEPhotoGraphic pgraphic = new FEPhotoGraphic(p,newSpring);
      newSpring.setDisplayFunctor(pgraphic);
      photos.add((Object)newSpring);
    }
    
  }
  
  void setRadius(float asize) 
  {
    float logsize = (float)Math.log(max(asize,1.0));
    asize = max(logsize*15,5.0);
    this.radius = asize;
  }
  
  float getRadius()
  {
    return this.radius;
  }
  
  void setPhotoGroup(FEPhotoGroup group) {
    photoGroup = group;
  }
  
  void setTag(String atag) {
    mytag = new FETag(atag);
  }
  
  boolean over() {
    if (dist(x, y, mouseX, mouseY) < (getRadius()/2)) {
      return true;
    } else {
      return false;
    }
  }

}

class FEPhotoGraphic extends FEGraphic {
  public PImage original_img;
  FEFlickrPhoto flickrPhoto = null;
  String farm_id, server_id, id, secret;
  String flickr_url = "";
  float iw = -1; float ih = -1;
  float xpos, ypos;
  FESpring myspring = null;
  
  FEPhotoGraphic(FEFlickrPhoto p, FESpring myspring) {
    flickrPhoto = p;
    this.myspring = myspring;
    setFlickrURL(flickrPhoto.getFlickrURL("t"));
  }
  
  boolean mouseover;
  void display(float xpos, float ypos) {
    this.xpos = xpos; this.ypos = ypos;
    if( original_img != null ) {
      switch(original_img.width) {
        case 0: 
          // still loading 
          drawBusy(xpos+random(6)-6,ypos+random(6)-6);
          break;
        case -1: return; // show nothing when in error!
        default: 
          // loaded successfully
          if( over() ) { 
            noFill(); 
            stroke(1.0, 1.0, 1.0, 0.8); 
            strokeWeight(12.0);
            strokeJoin(ROUND);
            rect(xpos-(iw/2)-3, ypos-(ih/2)-3, iw+6, ih+6); 
            strokeJoin(MITER);
            strokeWeight(1.0);
          }
          imageMode(CENTER);
          image(original_img, xpos, ypos, iw, ih);
          if( iw == -1 ) { iw = original_img.width; ih = original_img.height; myspring.setRadius(iw); } 
          if( over() ) { 
            selectedPhoto = flickrPhoto; 
            tagsForSelectedPhoto = flickrPhoto.getTags();
          } 
          else if( (selectedPhoto == flickrPhoto) && !over() ) { 
            selectedPhoto = null; 
            tagsForSelectedPhoto = null;
          }

//          else { myspring.setRadius(original_img.width); }
      }
    }
    else {
      drawBusy(xpos+random(6)-6,ypos+random(6)-6);
    }
  }
  
  void drawBusy(float xpos, float ypos) {
    fill(1.0, 1.0, 1.0, 0.5);
    noStroke();
    ellipseMode(CENTER_DIAMETER);
    ellipse(xpos, ypos, 5.0, 5.0);      
  }
  
  void setMouseOver(boolean mouse_is_over_me) { this.mouseover = mouse_is_over_me; };
  
  void setRadius(float asize) { 
//    asize = -1;
    if( original_img != null && original_img.width > 1) {
      if(asize == -1 ) {  // reset at -1
        iw = original_img.width; ih = original_img.height;
      } else {

        iw = asize; 
        ih = original_img.height * iw / original_img.width;
//        myspring.restsize = iw;

//        float ratio = original_img.height / original_img.width;
//        iw = asize;
//        ih = iw * ratio;
      }
    }
  }
  
  void displayPhotos() { };
  boolean over() { 
    if( (mouseX > (xpos - (iw/2))) && 
        (mouseX < (xpos + (iw/2))) &&
        (mouseY > (ypos - (ih/2))) &&
        (mouseY < (ypos + (ih/2))) ) {
      return true;
    }
    else {
      return false;
    }
  }
  
  void setFlickrURL(String url) { 
    this.flickr_url = url;
    this.original_img = requestImage(this.flickr_url);
  }

  void setFlickrURL(String farm_id, String server_id, String id, String secret) {
    setFlickrURL(createFlickrURL(farm_id, server_id, id, secret));    
  } 
  
  String createFlickrURL(String farm_id, String server_id, String id, String secret) { //_[mstb].jpg
    return "http://farm" + farm_id + ".static.flickr.com/" + server_id + "/" + id + "_" + secret + "_t.jpg";
  }
}
