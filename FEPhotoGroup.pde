import java.util.*;

class FEPhotoGroup {
  public float x, y, radius;
  public Vector photos;
  boolean showPhotos = false;
  boolean fadingIn = false;
  float calculated_radius;
  float calculated_radius_end;
  float calculated_radius_begin = 0;
  public FEWorldMap worldmap = null;
  public String tagname;
  
  FEPhotoGroup() {
    this(0, 0, 1);
  }
  
  void setTagname(String aTagname) { tagname = aTagname; }
  String getTagname() { return tagname; }
  
  FEPhotoGroup(float x, float y, int radius) {
    this.radius = max(radius,1);
    this.x = x;
    this.y = y;
    photos = new Vector();
  }

  void step(FEWorldMap worldmap) {
    calculated_radius_end = (radius*2)*(max(photos.size(),1));
    if (calculated_radius <= calculated_radius_end) {
      calculated_radius = calculated_radius + ((calculated_radius_end - calculated_radius_begin) * 0.02);
    }
  }
  
  void addPhoto(FEFlickrPhoto p) {
//    GeoData geo = p.getGeoData();

    if( !photos.contains(p) ) {
      photos.add(p);
      if( photos.size() == 1) { x = Float.parseFloat(p.getLongitude()); y = Float.parseFloat(p.getLatitude()); }
      else {
        x = (x+Float.parseFloat(p.getLongitude()))/2;
        y = (y+Float.parseFloat(p.getLatitude()))/2; 
      }
    }
  }

  boolean is_inside(String latitude, String longitude) {
    return is_inside(Float.parseFloat(latitude), Float.parseFloat(longitude));
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
  
  float getX() { return worldmap.longToX(x); } 
  float getY() { return worldmap.latToY(y); } 
  float getRadius() { return (radius*2)*(max(photos.size(),1)); }
  
  boolean mouse_inside(float mx, float my, FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 
    float calculated_radius = (radius*2)*(max(photos.size(),1));
    return dist(mx,my,pointXlong,pointYlat) <= calculated_radius;
  }
}

//-----------------------------------------SPRINGS LIBRARY
//Written by Michael Chang with help by Chaim Gingold from MAXIS
//last revision 02/03/05

vector getSpringForce(position from,position to,float desiredLength,float constant)
{
  vector force=new vector(from,to);
  
  if(dist(from,to)!=0)
  {
    vector deltaLength=new vector(force);
    position targetPos=new position(to.displace(getHeading(to,from),desiredLength));
    deltaLength=new vector(from,targetPos);
//    fill(255,0,0);
//    ellipse(targetPos.x,targetPos.y,5,5);
    force=new vector(deltaLength);
    force.m*=constant;
  }
  return force;
}

float getSpringForceScalar(float from,float to,float desiredLength,float constant)
{
  float force=to;
  force-=from;
  if(force!=0)
  {
    float deltaLength=force;
    float targetLength=desiredLength;
    deltaLength=deltaLength-targetLength;
    force=deltaLength;
    force*=constant;
  }

  return force;
}


//-----------------------------------------VECTOR/COORDINATE LIBRARY
//Written by Michael Chang
//last revision 11/30/03
static float conversionArc=180.0/PI;                              //180/PI used for many calculations
class position                                           //position class that stores 2 values x and y
{
  float x,y;
  position(){}
  position(float tx,float ty)
  {
    x=(tx);
    y=(ty);
  }
  position(position p)
  {
    if(p!=null)
    {
      x=p.x;
      y=p.y;
    }
  }
  position displace(float angle,float magnitude)         //returns the position displaced by an angle and distance
  {
    float ra=radians(angle);
    /*
    code optimization:
    ra is used for calculating radian conversion only once instead
    of once per line.
    */

    position newP=new position(x,y);
    newP.x+=(cos(ra)*magnitude);
    newP.y-=(sin(ra)*magnitude);
    return newP;
  }
  void set(float tx,float ty)                            //sets a new coordinate
  {
    x=(tx);
    y=(ty);
  }
  void set(position p)
  {
    x=p.x;
    y=p.y;
  }
}
class vector                                            //vector class that stores a position, angle, and magnitude
{
  float a,m;
  position p;

vector(){}
  vector(float tx,float ty,float angle,float magnitude)
  {
    p=new position(tx,ty);
    a=angle;
    m=magnitude;
  }
  vector(position start,position end)
  {
    p=new position(start);
    a=getHeading(start,end);
    m=dist(start,end);
  }
  vector(position pos,float angle,float magnitude)
  {
    p=new position(pos);
    a=angle;
    m=magnitude;
  }
  vector(vector v)
  {
    p=new position(v.p);
    a=v.a;
    m=v.m;
  }
  position endPoint()                                    //returns the endpoint of the vector as type position
  {
    return displace(p,a,m);
  }
  position ep()
  {
    return endPoint();
  }
  vector add(vector v)                                   //returns a vector addition
  {
    position newEnd=new position(endPoint().displace(v.a,v.m));
    float newAngle=getHeading(p,newEnd);
    vector newVector=new vector(p,newAngle,dist(p.x,p.y,newEnd.x,newEnd.y));
    return newVector;
  }
  vector add(float angle,float magnitude)                //returns a vector addition
  {
    vector v=new vector(p,angle,magnitude);
    position newEnd=new position(endPoint().displace(v.a,v.m));
    float newAngle=getHeading(p,newEnd);
    vector newVector=new vector(p,newAngle,dist(p.x,p.y,newEnd.x,newEnd.y));
    return newVector;
  }
  vector sub(vector v)                                   //returns a vector subration (unimplemented)
  {
    return v;
  }
  void set(vector v)
  {
    p.set(v.p);
    a=v.a;
    m=v.m;
  }
  void set(position np,float na,float nm)
  {
    p.set(np);
    a=na;
    m=nm;
  }
  void setStart(position np)                             //sets a new starting point for the vector
  {
    p=np;
  }
  void setEnd(position np)                               //sets a new ending point for the vector
  {
    a=getHeading(p,np);
    m=dist(p,np);
  }
  void setEnd(float px,float py)                         //sets a new ending point for the vector
  {
    position np=new position(px,py);
    a=getHeading(p,np);
    m=dist(p.x,p.y,np.x,np.y);
  }
  float x()
  {
    return p.x;
  }
  float y()
  {
    return p.y;
  }
  int isUnder(position s)
  {
    if(a==90||a==270)
    return 0;
    position e=new position(endPoint());
    float slope=(p.y-e.y)/(p.x-e.x);
    float yIntercept=p.y-(slope*p.x);
    float testY=(slope*s.x)+yIntercept;
    //    if(slope>0)
    //    {
      if(s.y>testY)
      return 1;
      else
      return -1;
    /*    }
    else
    {
      if(s.y>testY)
      return -1;
      else
      return 1;
    }*/
  }
}

position displace(position p,float angle,float magnitude) //displaces a position by an angle and a magnitude, then returns it
{
  position newP=new position(p);
  float ra=radians(angle);
  newP.x+=(cos(ra)*magnitude);
  newP.y-=(sin(ra)*magnitude);

  return newP;
}
float getHeading(position p1,position p2)                //gets the absolute heading between one position and another relative to the first
{
  if(p1.x==p2.x&&p1.y==p2.y)
  return 0;
  float xd=p2.x-p1.x;
  float yd=p2.y-p1.y;
  float angle=(new Double(Math.atan(yd/xd))).floatValue();
  //  angle=degrees(angle);
  angle=angle*conversionArc;
  if(xd>0&&yd<0)
  {
    angle=-1*angle;
  }
  else
  if(xd<0&&yd<0)
  angle=180-angle;
  else
  if(xd<0&&yd>0)
  angle=180-angle;
  else
  if(xd<0&&yd==0)
  angle=180;
  else
  if(xd==0&&yd<0)
  angle=90;
  else
  angle=360-angle;
  return angle;
}
float dist(position p1,position p2)
{
  return dist(p1.x,p1.y,p2.x,p2.y);
}
float normalizeHeading(float ang)                        //normalizes a heading between 0 and 360
{
  while(ang > 360)ang -= 360;
  while(ang < 0)ang += 360;
  return ang;
}
void drawVector(vector v)                                //draws a vector in white
{
  colorMode(RGB,255,255,255);
  stroke(255);
  noFill();
  ellipseMode(CENTER_DIAMETER);
  ellipse(v.p.x,v.p.y,5,5);
  position e=v.endPoint();
  line(v.p.x,v.p.y,e.x,e.y);
}
void drawVector(vector v,float s)                           //draws a vector with a longer line for representation in white
{
  colorMode(RGB,255,255,255);
  stroke(255);
  noFill();
  ellipseMode(CENTER_DIAMETER);
  ellipse(v.p.x,v.p.y,5,5);
  vector temp=new vector(v);
  temp.m*=s;
  position e=temp.endPoint();
  line(temp.p.x,temp.p.y,e.x,e.y);
}
void drawVector(vector v,int r,int g,int b,float s)                           //draws a vector with a longer line for representation in white
{
  colorMode(RGB,255,255,255);
  stroke(r,g,b);
  noFill();
  ellipseMode(CENTER_DIAMETER);
  ellipse(v.p.x,v.p.y,5,5);
  vector temp=new vector(v);
  temp.m*=s;
  position e=temp.endPoint();
  line(temp.p.x,temp.p.y,e.x,e.y);
}
void drawVector(vector v,int r,int g,int b)              //draws a vector in RGB
{
  colorMode(RGB,255,255,255);
  stroke(r,g,b);
  noFill();
  ellipseMode(CENTER_DIAMETER);
  ellipse(v.p.x,v.p.y,5,5);
  position e=v.endPoint();
  line(v.p.x,v.p.y,e.x,e.y);
}
