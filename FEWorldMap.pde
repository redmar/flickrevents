class FEWorldMap {
  PImage img;
  float xpos;
  float ypos;
  float drag = 30.0;
  float img_width, img_height;
  Vector photoGroups;
  
  FEWorldMap() {
    img = loadImage("map.png");  // Load the image into the program  
    img_width = width/2;
    img_height = height/2;
    xpos = (width/2)-(img_width/2);
    ypos = (height/2)-(img_height/2);
    photoGroups = new Vector();
  }

  // walk each photogroup if we're inside a given radius add it to that group
  void addPhoto(Photo p) {
    boolean added = false;
    for (int i=0; i < photoGroups.size(); i++) {
      GeoData geo = p.getGeoData();
      if( ((FEPhotoGroup)photoGroups.get(i)).is_inside(geo.getLongitude(), geo.getLatitude()) ) { ((FEPhotoGroup)photoGroups.get(i)).addPhoto(p); added = true;}
    }
    if(!added) {
      // create new photogroup and put this image in it!
      FEPhotoGroup newPhotoGroup = new FEPhotoGroup();
      newPhotoGroup.addPhoto(p);
      photoGroups.add(newPhotoGroup);
    }
  }
  
  void processMouseClick(float mx, float my) {
    for (int i=0; i < photoGroups.size(); i++) {
      if( ((FEPhotoGroup)photoGroups.get(i)).mouse_inside(mx,my, this) ) {
        System.out.println("INSIDE " + ((FEPhotoGroup)photoGroups.get(i)));
        ((FEPhotoGroup)photoGroups.get(i)).toggleShowPhotos();
      }
    }    
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

    for (int i=0; i < photoGroups.size(); i++) {
      ((FEPhotoGroup)photoGroups.get(i)).step(this);
    }
  }

  void render() {
    // Displays the image at point (100, 0) at half of its size
    image(img, xpos, ypos, img_width, img_height);
    // render all the children (dots/photos etc)
    
//    renderGeoPoint();
    for (int i=0; i < photoGroups.size(); i++) {
      ((FEPhotoGroup)photoGroups.get(i)).render(this);
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
}
