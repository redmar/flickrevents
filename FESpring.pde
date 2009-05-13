// Processing example spring changed to fit in FlickrEvents 
class FESpring 
{ 
  // Screen values 
  public float xpos, ypos;
  float tempxpos, tempypos; 

  float size = 20; 
  float tempsize = 20;
  public float restsize = 20;
  float velsize = 0.0;
  int clickTime = 0;
  
  FEPhotoGroup associated_photogroup = null;
  boolean showPhotos = false;
  
  public boolean over = false; 
  boolean move = false; 
 
  // Spring simulation constants 
  float mass;       // Mass 
  float k = 0.2;    // Spring constant 
  float damp;       // Damping 
  public float rest_posx;  // Rest position X 
  public float rest_posy;  // Rest position Y 

  // Spring simulation variables 
  //float pos = 20.0; // Position 
  float velx = 0.0;   // X Velocity 
  float vely = 0.0;   // Y Velocity 
  float accel = 0;    // Acceleration 
  float force = 0;    // Force 
  public FEGraphic displayFunctor = null;
  FESpring[] springphotos = null;
  int springphotosCount = 0;
  FESpring[] friends;
  int me;
  
  void setDisplayFunctor(FEGraphic aDisplayFunctor) { 
    displayFunctor = aDisplayFunctor; 
    displayFunctor.setRadius(this.restsize);
  }
  
  // Constructor
  FESpring(float x, float y, float s, float d, float m, 
         float k_in, FESpring[] others, int id) 
  { 
    xpos = tempxpos = x; 
    ypos = tempypos = y;
    rest_posx = x;
    rest_posy = y;
    size = s;
    damp = d; 
    mass = m; 
    k = k_in;
    friends = others;
    me = id; 
  } 

  void update() 
  { 
    if (move) { 
      rest_posy = mouseY; 
      rest_posx = mouseX;
    } 

    force = -k * (tempsize - restsize);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    velsize = damp * (velsize + accel);         // Set the velocity 
    tempsize = tempsize + velsize;           // Updated position 

    force = -k * (tempypos - rest_posy);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    vely = damp * (vely + accel);         // Set the velocity 
    tempypos = tempypos + vely;           // Updated position 

    force = -k * (tempxpos - rest_posx);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    velx = damp * (velx + accel);         // Set the velocity 
    tempxpos = tempxpos + velx;           // Updated position 

    
    if ((over() || move) /*&& !otherOver()*/ ) { 
      over = true; 
    } else { 
      over = false; 
    } 
  } 
  
  void setPosition(float x, float y) {
    xpos = rest_posx = x; ypos = rest_posy = y;
  }
  
  void setTempPosition(float x, float y) {
    tempxpos = x; tempypos = y;
  }

  // Test to see if mouse is over this spring
  boolean over() {
    if (displayFunctor.over()) {
      return true;
    } else {
      return false;
    }
  }
  
  // Make sure no other springs are active
  boolean otherOver() {
    for (int i=0; i<springCount; i++) {
      if (i != me) {
        if (friends[i].over == true) {
          return true;
        }
      }
    }
    return false;
  }

  void setRadius(float asize) {
    tempsize = this.restsize;
    this.restsize = asize;
    if (displayFunctor != null) { displayFunctor.setRadius(asize); }
  }
  
  void display() 
  { 
    if (displayFunctor == null) return;
    displayFunctor.originx = xpos;
    displayFunctor.originy = ypos;
    
    if (over) { 
      displayFunctor.setMouseOver(true);
      displayFunctor.display(tempxpos,tempypos);
      displayFunctor.setRadius(tempsize);
    } else { 
      displayFunctor.setMouseOver(false);
      displayFunctor.display(tempxpos,tempypos);      
      displayFunctor.setRadius(tempsize);
    }
    
//    if( showPhotos ) {
//      displayFunctor.displayPhotos();      
//    }

//      if( photos == null ) initPhotos();
//      else renderPhotos();

//      stroke(1.0, 1.0, 1.0, 1.0);
//      fill(1.0, 1.0, 1.0, 1.0);
//      rect(tempxpos, tempypos, 30, 30);
// for each photo 
//    }
  } 

  void initPhotos() {
    // for all photos create bla bla
    if( getPhotogroup() == null) return;
    Vector FEFlickrPhotoVector = getPhotogroup().photos;
    for(int i=0; i<FEFlickrPhotoVector.size(); i++) {
      FEFlickrPhoto photodata = (FEFlickrPhoto)FEFlickrPhotoVector.get(i);
//      FESpring photoSpring = new FESpring(xpos, ypos, 3.0, 0.80, 10, 0.9, photos.toArray(), 0);
//      photoSpring.setDisplayfunctor = setDisplayFunctor(myDisplayFunctor);
//      springphotos[springphotosCount] = photoSpring;
//      springphotosCount++;
    }
  }
  
  void renderPhotos() {
    if( getPhotogroup() == null) return;
    // for all photos draw!
  }

  void pressed() 
  { 
    clickTime = millis();
    if (over) { 
      move = true; 
    } else { 
      move = false; 
    }  
    if(displayFunctor != null) displayFunctor.setMouseDown(true);
  } 

  void hardRelease() {
    showPhotos = false;
    if (displayFunctor != null) displayFunctor.setShowPhotos(false);
  }

  void released() 
  { 
    int deltaClick = millis() - clickTime;

    if(over && deltaClick < 200) { 
      if(associated_photogroup!=null) { 
         showPhotos = !showPhotos; 
         if(displayFunctor != null) {
           displayFunctor.setShowPhotos(showPhotos);
           if(showPhotos) {
             if(selectedSpring != null) selectedSpring.hardRelease();
             selectedSpring = this;
           }
           if(!showPhotos && selectedSpring == this) selectedSpring = null;
         }
      }
    }
    move = false; 
    rest_posx = xpos;  
    rest_posy = ypos;
    if(displayFunctor != null) displayFunctor.setMouseDown(false);
  } 
  
  void moveTo(position p) {
    moveTo(p.x, p.y);
  }
  
  void moveTo(float movetox, float movetoy) {
    float oldx = rest_posx; 
    float oldy = rest_posy;
    float nx = movetox;
    float ny = movetoy;
    setPosition(nx, ny);
    setTempPosition(oldx, oldy);
//    springs[i].setRadius(3 + random(200));
  }
  
  void setPhotoGroup(FEPhotoGroup pg) {
    springphotos = null;
    springphotosCount = 0;
    showPhotos = false;
    associated_photogroup = pg;
  }
  FEPhotoGroup getPhotogroup() {
    return associated_photogroup;
  }
  
  position position() {
    return new position(rest_posx, rest_posy);
  }
  
  boolean atRest() {
    return velx < 0.01 && vely < 0.01;
  }
} 

