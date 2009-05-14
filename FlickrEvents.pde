
// Global Preferences ////////////////
static final boolean DEBUG = true;
boolean search_on_startup  = false;
String[] tagOrder = {"rock","classic","trance","pop","jazz"};
ArrayList selectedTags = new ArrayList(Arrays.asList(tagOrder));
String[] unwantedTags = {"rock","classic","trance","pop","jazz","music"};
ArrayList tagFilter = new ArrayList(Arrays.asList(unwantedTags));
ArrayList tagsForSelectedPhoto = new ArrayList();
FEFlickrPhoto selectedPhoto = null;
FESpring selectedSpring = null;
PImage fullscreenImage = null;
int rock_count = 0;
int classic_count = 0;
int trance_count = 0;
int pop_count = 0;
int jazz_count = 0;
//////////////////////////////////////

FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
FEDateView dateView;
FEGui gui;
Button leftButton = new Button(), rightButton = new Button();
String cacheDir;
boolean w_event = true;
boolean debug = false;
PFont font = createFont("FuturaLT", 32);
GregorianCalendar calendar = new GregorianCalendar(2009, 2, 30);

void setup() {
  smooth();
  colorMode(RGB, 1.0);
  cacheDir = sketchPath + "/cache/";

  log("cachedir:" + cacheDir);
  frame.setResizable(true); 
//  size(screen.width, screen.height-50);
  size(1024, 768);
//  pg = new FEPhotoGroup(200,200,30);
//  photo = new FEPhoto(this);


  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  if(search_on_startup) {
//    try {
//      for(int i = 0; i < 31; i++){
//        calendar.add(Calendar.DATE, -1);
//        String prevDay = df.format(calendar.getTime());
//        if (!new File(cacheDir+prevDay).exists()){
//          FEFlickrData fe_data = new FEFlickrData(prevDay);
//        }
//      }
//    } catch (Exception e) {
//      e.printStackTrace();
//    }
  } else {
    FECacheReader cacheReader = new FECacheReader();
    FEDayCollection dayCollection = cacheReader.getDayCollection();
    fe_worldmap = new FEWorldMap(dayCollection);
    dateView = new FEDateView(this);
    dateView.setCurrentDate(calendar.getTime());
    dateView.addObserver(fe_worldmap);
    fe_timeline = new FETimeLine(dayCollection);
    dateView.addObserver(fe_timeline);
    gui = new FEGui(dayCollection);
    dateView.addObserver(gui);
//    try {
//      for (int i = 0; i < dayCollection.size(); i++){
//        FEDay day = (FEDay) dayCollection.get(i);
//        for (int j = 0; j < day.size(); j++){
//          FETag tag = (FETag) day.get(j);
//          System.out.println(day.getDate() + " " + tag.getTagName() + " " + tag.size());
//        }
//      }
//    } catch (Exception e) {
//      e.printStackTrace();
//    }
  }
  
  frameRate(24);
  
  frame.addComponentListener(new ComponentAdapter() {
    public void componentResized(ComponentEvent e) {
       int minHeight = 768; int minWidth = 1024; 
       if(e.getSource()==frame) { 
         if (frame.getHeight() < minHeight) { frame.setSize(frame.getWidth(), minHeight); }
         if (frame.getWidth() < minWidth) { frame.setSize(frame.getHeight(), minWidth); }
       }
    }
  }); 
}

void draw() {
  background(0);
  
  gui.step();
  gui.render();

  fe_worldmap.step();
  fe_worldmap.render();

  fe_timeline.step();
  fe_timeline.render();
  
  dateView.step();
  dateView.render();

  if(fullscreenImage != null && fullscreenImage.width > 1) {
    fill(0.0, 0.0, 0.0, 0.15);
    rect(0,0,width,height);
    imageMode(CENTER);
    image(fullscreenImage, width/2, height/2);
  }

//  if( selectedPhoto != null && selectedSpring != null) {
//    ((FEPhotoGraphic)selectedSpring.displayFunctor).setFlickrURL(selectedPhoto.getFlickrURL());
//
//    float oldx = selectedSpring.rest_posx; 
//    float oldy = selectedSpring.rest_posy;
//    selectedSpring.setPosition(width/2, height/2);
//    selectedSpring.setTempPosition(oldx, oldy);
//  }
}

void mousePressed() {
  fe_worldmap.processMousePressed(mouseX, mouseY);
}

void mouseReleased() {
  fe_worldmap.processMouseReleased(mouseX, mouseY);
  leftButton.over();
  rightButton.over();
  if (leftButton.over){
    dateView.gotoPrevDay();
  }
  if (rightButton.over){
    dateView.gotoNextDay();
  }
}

void keyPressed(){
  if(key=='w'||key=='W'){
    w_event = !w_event;
  }
  if(key == CODED) {
    if(keyCode==LEFT) {
      dateView.gotoPrevDay(); 
//      System.out.println("goto prev day");
    }
    if(keyCode==RIGHT) {
      dateView.gotoNextDay(); 
//      System.out.println("goto next day");
    }
    if(keyCode==UP) {
      for (int i=0; i < springCount; i++) {
        float oldx = springs[i].rest_posx; 
        float oldy = springs[i].rest_posy;
        float nx = oldx + random(100) - 50;
        float ny = oldy + random(100) - 50;
        springs[i].setPosition(nx, ny);
        springs[i].setTempPosition(oldx, oldy);
        //springs[i].setRadius(3 + random(200));
      }
    }
  }
} 

void keyReleased() {
}

void log(String what) {
  if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
}

static int getTagColor(String tag)
{
  if (tag.equals("rock")){
    return #FF0000;
  } else if (tag.equals("classic")){
    return #00FF00;
  } else if (tag.equals("trance")){
    return #0000FF;
  } else if (tag.equals("pop")){
    return #FFFF00;
  } else if (tag.equals("jazz")){
    return #FF00FF;
  }
  return -1;
}


HashMap addHashMapValues(HashMap first, HashMap second){
  ArrayList mapKeys = new ArrayList(second.keySet());
  for(int i = 0; i < mapKeys.size(); i++){
    int count = (Integer) second.get(mapKeys.get(i));
    if (first.containsKey(mapKeys.get(i))){
      count += (Integer) first.get(mapKeys.get(i));
    }
    first.put(mapKeys.get(i), count);
  }
  return first;
}

LinkedHashMap sortHashMapByValuesD(HashMap passedMap, boolean descending) {
  ArrayList mapKeys = new ArrayList(passedMap.keySet());
  ArrayList mapValues = new ArrayList(passedMap.values());
  Collections.sort(mapValues);
  Collections.sort(mapKeys);
  
  if (descending){
    Collections.reverse(mapValues);
  }
      
  LinkedHashMap sortedMap = 
      new LinkedHashMap();
  
  Iterator valueIt = mapValues.iterator();
  while (valueIt.hasNext()) {
    Object val = valueIt.next();
    Iterator keyIt = mapKeys.iterator();
    
    while (keyIt.hasNext()) {
      Object key = keyIt.next();
      String comp1 = passedMap.get(key).toString();
      String comp2 = val.toString();
      
      if (comp1.equals(comp2)){
          passedMap.remove(key);
          mapKeys.remove(key);
          sortedMap.put((String)key, (Object)val);
          break;
      }
    }
  }
  return sortedMap;
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
  public float x,y;
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
  String toString() { return "x:" + x + " y:" + y; }
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
