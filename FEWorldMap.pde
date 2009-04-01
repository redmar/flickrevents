class FEWorldMap {
  PImage img;
  float xpos;
  float ypos;
  float drag = 30.0;
  float img_width, img_height;

  FEWorldMap() {
    img = loadImage("map.png");  // Load the image into the program  
    img_width = width/2;
    img_height = height/2;
    xpos = (width/2)-(img_width/2);
    ypos = (height/2)-(img_height/2);
  }

  void step() {
//    img_width = width*0.9;
//    img_height = height*0.8;
//    xpos = (width/2)-(width*0.9/2);
//    ypos = (height/2)-(height*0.8/2);

    float difw = (width*0.9) - img_width;
    if(abs(difw) > 1.0) {
      img_width = img_width + difw/drag;
    }  

    float difh = (height*0.8) - img_height;
    if(abs(difh) > 1.0) {
      img_height = img_height + difh/drag;
    }  

    float difx = (width/2)-(img_width/2) - xpos;
    if(abs(difx) > 1.0) {
      xpos = xpos + difx/drag;
      xpos = constrain(xpos, 0, (width/2)+(img_width/2));
    }  
  
    float dify = (height/2)-(img_height/2) - ypos;
    if(abs(dify) > 1.0) {
      ypos = ypos + dify/drag;
      ypos = constrain(ypos, 0, (height/2)+(img_height));
    }  
  }

  void render() {
    // Displays the image at point (100, 0) at half of its size
    image(img, xpos, ypos, img_width, img_height);
//    renderGeoPoint();
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
