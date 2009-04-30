package flickrnetbeans;

import java.util.*;
import processing.core.*;
import java.math.*;

class FEPhotoGroup {
  float x, y, radius;
  Vector photos;
  boolean showPhotos = false;
  
  FEPhotoGroup() {
    this(0, 0, 1);
  }
  
  FEPhotoGroup(float x, float y, int radius) {
    this.radius = max(radius,1);
    this.x = x;
    this.y = y;
    photos = new Vector();
  }

  void step() {
  }
  
  void addPhoto(Photo p) {
    GeoData geo = p.getGeoData();

    if( !photos.contains(p) ) {
      photos.add(p);
      if( photos.size() == 1) { x = geo.getLongitude(); y = geo.getLatitude(); }
      else {
        x = (x+geo.getLongitude())/2;
        y = (y+geo.getLatitude())/2; 
      }
    }
  }

  boolean is_inside(float latitude, float longitude) {
    return dist(x, y, latitude, longitude) < 0.005 ;  
  }
  
  void render() {
    ellipseMode(CENTER);
    float calculated_radius = (radius*2)*(max(photos.size(),1));
    stroke(1.0, 0, 0);
    fill(1.0, 0, 0, 0.5);
    ellipse(x, y, calculated_radius, calculated_radius);
//    ellipse(x, y, radius, radius);
  }
  
  void render(FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 

    ellipseMode(CENTER);
    float calculated_radius = (radius*2)*(max(photos.size(),1));
   if( !showPhotos ) {
    stroke(1.0, 0, 0);
    fill(1.0, 0, 0, 0.5);
   }
   else {
    stroke(1.0, 1.0, 1.0);
    fill(1.0, 1.0, 1.0, 0.2);
   }
    ellipse(pointXlong, pointYlat, calculated_radius, calculated_radius);

    stroke(1.0, 1.0, 1.0);
    fill(1.0, 1.0, 1.0);
    ellipse(pointXlong, pointYlat, 1, 1);
    
   if( showPhotos ) {
     for(int i=0; i<photos.size(); i++) {
       
//       ((FEPhoto)photos.get(i)).render(this);
     }
   }
  }
  
  void toggleShowPhotos() {
    showPhotos = !showPhotos;
  }
  
  boolean mouse_inside(float mx, float my, FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 
    float calculated_radius = (radius*2)*(max(photos.size(),1));
    return dist(mx,my,pointXlong,pointYlat) <= calculated_radius;
  }
}
