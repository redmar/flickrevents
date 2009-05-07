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
    img_width = width/2;
    img_height = height/2;
    xpos = (width/2)-(img_width/2);
    ypos = (height/2)-(img_height/2);
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
//          log("tmpPhoto " + idx + " : " + tmpPhoto);
          addPhoto( tmpPhoto, tag.getTagName() );
        }
    }    
    
//    for (int i=0; i < photoGroups.size(); i++) {
//      FEPhotoGroup group = ((FEPhotoGroup)photoGroups.get(i));
//      group.worldmap = this;
//      if(groupidx < springCount) {
//        // set new position and radius of this spring
//        springs[i].moveTo(group.getX(), group.getY());
//        groupidx++;
//      } else {
//        // cannot recycle any spring anymore, create extra 
//        springs[springCount] = new FESpring(group.getX(), group.getY(), 20, 0.80, 10, 0.9, springs, 0);
//        springs[springCount].setDisplayFunctor(new FECircleGraphic(20));
//        springCount++;
//      }
//      photoGroups.add(group);
//    }
//    // throw away old springs
//    for(int i=groupidx; i < springCount; i++) {
//      springs[i] = null;
//    }
//    springCount = groupidx;
  }
  
  void processMouseClick(float mx, float my) { 
//    springs[springCount] = new FESpring( mx, my, 20, 0.80, 10, 0.9, springs, 0);
//    springs[springCount].setDisplayFunctor(new FECircleGraphic(20));
//    springCount++;
    
//    if( ((FEPhotoGroup)photoGroups.get(i)).mouse_inside(mx,my, this) ) {
//      System.out.println("INSIDE " + ((FEPhotoGroup)photoGroups.get(i)));
//      ((FEPhotoGroup)photoGroups.get(i)).toggleShowPhotos();
//    }   
  }

  void step() {
//    float difw = (width*0.9) - img_width;
//    if(abs(difw) > 1.0) {
//      img_width = img_width + difw/drag;
//    }  
//
//    float difh = (height*0.8) - img_height;
//    if(abs(difh) > 1.0) {
//      img_height = img_height + difh/drag;
//    }  
//
//    float difx = (width/2)-(img_width/2) - xpos;
//    if(abs(difx) > 1.0) {
//      xpos = xpos + difx/drag;
//      xpos = constrain(xpos, 0, (width/2)+(img_width/2));
//    }  
//  
//    float dify = (height/2)-(img_height/2) - ypos;
//    if(abs(dify) > 1.0) {
//      ypos = ypos + dify/drag;
//      ypos = constrain(ypos, 0, (height/2)+(img_height));
//    }  

    img_width = width*0.7;
    img_height = height*0.8;
    xpos = (width*0.05);
    ypos = (height*0.1);
//
    for (int i=0; i < photoGroups.size(); i++) {
      ((FEPhotoGroup)photoGroups.get(i)).step(this);
    }

    for (int i=0; i < springCount; i++) {
      springs[i].update();
    }
  }

//  void step() {
////    float difw = (width*0.9) - img_width;
////    if(abs(difw) > 1.0) {
////      img_width = img_width + difw/drag;
////    }  
////
////    float difh = (height*0.8) - img_height;
////    if(abs(difh) > 1.0) {
////      img_height = img_height + difh/drag;
////    }  
////
////    float difx = (width/2)-(img_width/2) - xpos;
////    if(abs(difx) > 1.0) {
////      xpos = xpos + difx/drag;
////      xpos = constrain(xpos, 0, (width/2)+(img_width/2));
////    }  
////  
////    float dify = (height/2)-(img_height/2) - ypos;
////    if(abs(dify) > 1.0) {
////      ypos = ypos + dify/drag;
////      ypos = constrain(ypos, 0, (height/2)+(img_height));
////    }  
//
//    img_width = width*0.7;
//    img_height = height*0.8;
//    xpos = (width*0.05);
//    ypos = (height*0.1);
//  }

//    for (int i=0; i < photoGroups.size(); i++) {
//      FEPhotoGroup group = ((FEPhotoGroup)photoGroups.get(i));
//      group.worldmap = this;
//      if(groupidx < springCount) {
//        // set new position and radius of this spring
//        springs[i].moveTo(group.getX(), group.getY());
//        groupidx++;
//      } else {
//        // cannot recycle any spring anymore, create extra 
//        springs[springCount] = new FESpring(group.getX(), group.getY(), 20, 0.80, 10, 0.9, springs, 0);
//        springs[springCount].setDisplayFunctor(new FECircleGraphic(20));
//        springCount++;
//      }
//      photoGroups.add(group);
//    }
//    // throw away old springs
//    for(int i=groupidx; i < springCount; i++) {
//      springs[i] = null;
//    }
//    springCount = groupidx;

  void render() {
    // Displays the image at point (100, 0) at half of its size
    image(img, xpos, ypos, img_width, img_height);
    // render all the children (dots/photos etc)
    
//    renderGeoPoint();
    if( springs_synced == false ) {
      for (int i=0; i < photoGroups.size(); i++) {
        FEPhotoGroup group = ((FEPhotoGroup)photoGroups.get(i));
        group.worldmap = this;
        if(i < springCount) {
          springs[i].moveTo(group.getX(), group.getY());
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
      }
      // remove unused springs
      for(int i=photoGroups.size(); i < springCount; i++) { springs[i] = null; }
      springCount = photoGroups.size();
      springs_synced = true;
    }

    for (int i=0; i < springCount; i++) {
      springs[i].display();
    }

  }
  
  // equirectangular projection!
  // should be OHMP, Amsterdam
  //         90
  //              latitude (Y)
  // -180                          180  longitude
  //
  //        -90
  void renderGeoPoint(float longitude_x, float latitude_y) 
  {
    float pointXlong = longToX(longitude_x);
    float pointYlat  = latToY(latitude_y);  //  -90     90 
    
    stroke(255,0,0);
    point(pointXlong, pointYlat);
    //arc(pointXlong,pointYlat, Math.abs(longToX(-90.0) - pointXlong), Math.abs(latToY(-90.0) - pointYlat),PI,PI/2) ;
    //noFill();
    //arc(pointXlong,pointYlat, 100, 100,0,1) ;
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
//    Date newDate = ((FEDateView)o).currentDate();
    selectedDate = ((FEDateView)o).currentDate();
    currentDay = dayCollection.getDay(selectedDate);
    loadDay();
//    update = true;
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
//      fill(153,0,0); 
    }
    else {
//      fill(255,0,0); 
    }
    if (mytag != null) {
      mytag.setColor(0.5);
    }
    ellipseMode(CENTER);
    ellipse(xpos, ypos, this.radius, this.radius);
  }
  
  void setRadius(float asize) {
    asize = max(asize,3.0);
    this.radius = asize;
  }
  
  void setTag(String atag) {
    mytag = new FETag(atag);
  }
}
