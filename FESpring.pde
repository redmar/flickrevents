// Processing example spring changed to fit in FlickrEvents 
class FESpring 
{ 
  // Screen values 
  public float xpos, ypos;
  float tempxpos, tempypos; 

  float size = 20; 
  float tempsize = 20;
  float restsize = 20;
  float velsize = 0.0;
  
  boolean over = false; 
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
  FEGraphic displayFunctor = null;

  FESpring[] friends;
  int me;
  
  void setDisplayFunctor(FEGraphic aDisplayFunctor) { displayFunctor = aDisplayFunctor; }
  
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
    displayFunctor.setRadius(tempsize);

    force = -k * (tempypos - rest_posy);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    vely = damp * (vely + accel);         // Set the velocity 
    tempypos = tempypos + vely;           // Updated position 

    force = -k * (tempxpos - rest_posx);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    velx = damp * (velx + accel);         // Set the velocity 
    tempxpos = tempxpos + velx;           // Updated position 

    
    if ((over() || move) && !otherOver() ) { 
      over = true; 
    } else { 
      over = false; 
    } 
  } 
  
  void setPosition(float x, float y) {
    rest_posx = x; rest_posy = y;
  }
  
  void setTempPosition(float x, float y) {
    tempxpos = x; tempypos = y;
  }

  // Test to see if mouse is over this spring
  boolean over() {
    float disX = tempxpos - mouseX;
    float disY = tempypos - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < size/2 ) {
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
  }
  
  void display() 
  { 
    if (displayFunctor == null) return;
    
    if (over) { 
      displayFunctor.setMouseOver(true);
      displayFunctor.display(tempxpos,tempypos);
    } else { 
      displayFunctor.setMouseOver(false);
      displayFunctor.display(tempxpos,tempypos);
    } 
  } 

  void pressed() 
  { 
    if (over) { 
      move = true; 
    } else { 
      move = false; 
    }  
  } 

  void released() 
  { 
    move = false; 
    rest_posx = xpos;
    rest_posy = ypos;
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
} 

