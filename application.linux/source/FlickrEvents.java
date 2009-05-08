import processing.core.*; 
import processing.xml.*; 

import java.io.*; 
import java.io.*; 
import java.util.*; 
import java.util.*; 
import java.io.IOException; 
import java.io.InputStream; 
import java.util.ArrayList; 
import java.util.Properties; 
import javax.xml.parsers.ParserConfigurationException; 
import org.xml.sax.SAXException; 
import com.aetrion.flickr.Flickr; 
import com.aetrion.flickr.FlickrException; 
import com.aetrion.flickr.REST; 
import com.aetrion.flickr.photos.*; 
import com.aetrion.flickr.util.IOUtilities; 
import gifAnimation.*; 
import java.util.*; 
import java.util.*; 
import gifAnimation.*; 
import java.lang.*; 

import com.aetrion.flickr.photosets.comments.*; 
import com.aetrion.flickr.interestingness.*; 
import com.aetrion.flickr.urls.*; 
import com.aetrion.flickr.test.*; 
import com.aetrion.flickr.photos.upload.*; 
import com.aetrion.flickr.groups.*; 
import com.aetrion.flickr.reflection.*; 
import com.aetrion.flickr.photosets.*; 
import com.aetrion.flickr.photos.*; 
import com.aetrion.flickr.uploader.*; 
import com.aetrion.flickr.util.*; 
import com.aetrion.flickr.activity.*; 
import com.aetrion.flickr.favorites.*; 
import com.aetrion.flickr.prefs.*; 
import com.aetrion.flickr.groups.pools.*; 
import com.aetrion.flickr.people.*; 
import com.aetrion.flickr.photos.transform.*; 
import com.aetrion.flickr.photos.geo.*; 
import com.aetrion.flickr.photos.comments.*; 
import com.aetrion.flickr.machinetags.*; 
import com.aetrion.flickr.auth.*; 
import com.aetrion.flickr.blogs.*; 
import com.aetrion.flickr.contacts.*; 
import com.aetrion.flickr.photos.notes.*; 
import com.aetrion.flickr.places.*; 
import com.aetrion.flickr.tags.*; 
import com.aetrion.flickr.photos.licenses.*; 
import com.aetrion.flickr.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class FlickrEvents extends PApplet {


// Global Preferences ////////////////
static final boolean DEBUG = true;
boolean search_on_startup  = false;
String[] tagOrder = {"rock","classic","trance","pop","jazz"};
ArrayList selectedTags = new ArrayList(Arrays.asList(tagOrder));
String[] unwantedTags = {"rock","classic","trance","pop","jazz","music"};
ArrayList tagFilter = new ArrayList(Arrays.asList(unwantedTags));
//////////////////////////////////////

FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
FEDateView dateView;
FEGui gui;
String cacheDir;
boolean w_event = true;
boolean debug = false;
PFont font = createFont("FuturaLT", 32);
GregorianCalendar calendar = new GregorianCalendar(2009, 3, 27);

public void setup() {
  smooth();
  colorMode(RGB, 1.0f);
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
       int minHeight = 600; int minWidth = 800; 
       if(e.getSource()==frame) { 
         if (frame.getHeight() < minHeight) { frame.setSize(frame.getWidth(), minHeight); }
         if (frame.getWidth() < minWidth) { frame.setSize(frame.getHeight(), minWidth); }
       }
    }
  }); 
}

public void draw() {
  background(0);
  
  gui.step();
  gui.render();

  fe_worldmap.step();
  fe_worldmap.render();

  fe_timeline.step();
  fe_timeline.render();
  
  dateView.step();
  dateView.render();
}

public void mousePressed() {
  fe_worldmap.processMousePressed(mouseX, mouseY);
}

public void mouseReleased() {
  fe_worldmap.processMouseReleased(mouseX, mouseY);
}

public void keyPressed(){
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

public void keyReleased() {
}

public void log(String what) {
  if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
}

public static int getTagColor(String tag)
{
  if (tag.equals("rock")){
    return 0xffFF0000;
  } else if (tag.equals("classic")){
    return 0xff00FF00;
  } else if (tag.equals("trance")){
    return 0xff0000FF;
  } else if (tag.equals("pop")){
    return 0xffFFFF00;
  } else if (tag.equals("jazz")){
    return 0xffFF00FF;
  }
  return -1;
}


public HashMap addHashMapValues(HashMap first, HashMap second){
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

public LinkedHashMap sortHashMapByValuesD(HashMap passedMap, boolean descending) {
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

class Button
{
  int x, y;
  int w, h;
  int basecolor, highlightcolor;
  int currentcolor;
  boolean over = false;
  boolean pressed = false;
  boolean locked = false;
  
  public void over() 
  {
    if( overRect(x, y, w, h) ) {
      over = true;
    } else {
      over = false;
    }
  }
  
  public void pressed() {
    if(over && mousePressed) {
      pressed = true;
      locked = true;
    } else {
      pressed = false;
    }    
  }
  
  public void release() {
    locked = false;
  }
  
  public boolean overRect(int x, int y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
}

class CheckBox extends Button
{
  int selectedColor;
  boolean checked;
  float spaceFactor = 0.15f;
  
  CheckBox(int ix, int iy, int iw, int ih, int isc)
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    selectedColor = isc;
    checked = false;
  }
  
  public void update()
  {
    over();
    pressed();
    if(!pressed && locked) {
      checked = !checked;
      release();
    }
  }
  
  public void display()
  {
    stroke(1);
    noFill();
    rect(x,y,w,h);
    if (checked){
      noStroke();
      fill(selectedColor,0.5f);
      rect(x+w*spaceFactor,y+h*spaceFactor, w+2-(2*w*spaceFactor), h+2-(2*h*spaceFactor));
    }
  }
}

class ImageButtons extends Button 
{
  PImage base;
  PImage roll;
  PImage down;
  PImage currentimage;

  ImageButtons(int ix, int iy, int iw, int ih, PImage ibase, PImage iroll, PImage idown) 
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    base = ibase;
    roll = iroll;
    down = idown;
    currentimage = base;
  }
  
  public void update() 
  {
    over();
    pressed();
    if(pressed) {
      currentimage = down;
    } else if (over){
      currentimage = roll;
    } else {
      currentimage = base;
    }
  }
    
  public void display() 
  {
    image(currentimage, x, y);
  }
}


class FECacheReader
{
  FEDayCollection dayCollection;
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  
  public FECacheReader(){
    dayCollection = new FEDayCollection();
    File folder = new File(cacheDir);
    String[] dirs = folder.list();
    for(int i = 0; i < dirs.length; i++)
    {
      if (dirs[i] != "." && dirs[i] != "..")
      {
        try{
          Date date = dateFormat.parse(dirs[i]);
          dayCollection.add(loadDay(date));
        } catch (Exception e){
          System.out.println(e.getMessage());
        }
      }
    }
  }
  
  public FEDay loadDay(Date date)
  {
    FEDay day = new FEDay(date);
    String folder = cacheDir + dateFormat.format(date) + "/";
    File dayFolder = new File(folder);
    String[] dirs = dayFolder.list();
    for(int i = 0; i < dirs.length; i++)
    {
      if (dirs[i] != "." && dirs[i] != "..")
      {
        day.add(loadTag(folder, dirs[i]));
      }
    }
    return day;
  }
  
  public FETag loadTag(String dir, String tagName)
  {
    FETag tag = new FETag(tagName.replaceAll(".txt",""));
    try{
      BufferedReader reader = new BufferedReader(new FileReader(dir + tagName));
      String line = null;
      while ((line=reader.readLine()) != null) {
        tag.add(loadPhoto(line));
      }
      reader.close();
    }
    catch (Exception e)
    {
      System.out.println(e.getStackTrace());
    }
    
    return tag;
  }
  
  public FEFlickrPhoto loadPhoto(String line)
  {
    Pattern p = Pattern.compile("^<photo id=\"(.*)\" owner=\"(.*)\" owner_name=\"(.*)\" secret=\"(.*)\" server=\"(.*)\" farm=\"(.*)\" latitude=\"(.*)\" longitude=\"(.*)\" tags=\"(.*)\"/>$");
    Matcher m = p.matcher(line);
    if (m.matches())
    {
      FEFlickrPhoto photo = new FEFlickrPhoto(m.group(1), m.group(2), m.group(3), m.group(4), m.group(5), m.group(6), m.group(7), m.group(8), m.group(9));
      return photo;
    } 
    else 
    {
      return null;
    }
  }
  
  public FEDayCollection getDayCollection(){
    return dayCollection;
  }
}


class FEDataSaver
{
  FileWriter fstream;
  BufferedWriter buf;
  
  public FEDataSaver(String date, String tag) throws IOException
  {
    try {
      File dir = new File(cacheDir+date);
      if (!dir.exists() && dir.mkdir()){
        System.out.println("Making dir");
      }
      fstream = new FileWriter(cacheDir + date + "/" + tag + ".txt");
      
      System.out.println("Write to: " + date + "/" + tag + ".txt");
      buf = new BufferedWriter(fstream);
    } catch (Exception e){
      System.out.println(e.getMessage());
    }
  }
  
  public synchronized void writePhoto(Photo p) throws IOException
  {
    String tags = "", photoString;
    Object[] tagArray = p.getTags().toArray();
    
    for(int i = 0; i < p.getTags().size(); i++){
      tags += ((Tag)tagArray[i]).getValue() + ",";
    }    
    photoString = "<photo id=\""+p.getId()+"\" owner=\""+p.getOwner().getId()+"\" owner_name=\""+p.getOwner().getUsername()+"\" secret=\""+p.getSecret()+"\" server=\""+p.getServer()+"\" farm=\""+p.getFarm()+"\" latitude=\""+p.getGeoData().getLatitude()+"\" longitude=\""+p.getGeoData().getLongitude()+"\" tags=\""+tags+"\"/>\n";
    
    writeString(photoString);
  }
  
  public synchronized void writeString(String string) throws IOException
  {
    buf.write(string);
    //System.out.println("Write string: " + string);
  }
  
  public synchronized void closeBuffer() throws IOException
  {
    buf.close();
  }
}


class FEDateView extends Observable {
  PImage original_img;
  PApplet parent;
  PFont font;
  boolean debug = false;
  
  GregorianCalendar calendar;

  // used for date skipping
  float start_time = -1; 
  float last_time = -1;
  float current_time = -1;
  int calendar_type = Calendar.DATE;
  float amount = 1.0f;

  float xpos = 200.0f;
  float ypos = 200.0f;
  float img_width = 320.0f;
  float img_height = 200.0f;
  float midx = 0;
  float midy = 0;
    
  FEDateView(PApplet parent) {
    this.parent = parent;
    initDateView();
  }
  
  public void initDateView() {
    calendar = new GregorianCalendar(2009, 3, 27);
    log("Setting up calender to: " + currentFullDateString());
    log("Setting up calender to date: " + currentDate());
  }

  public Date currentDate() {
    return calendar.getTime();
  }

  // return day number as string with padded zero in front of it (always giving back 2 decimals)
  public String currentDayString() {
    return ((calendar.get(Calendar.DATE) < 10) ? "0"+calendar.get(Calendar.DATE) : ""+calendar.get(Calendar.DATE));
  }
  
  public String currentMonthString() {
    String[] months = {"January", "Februari", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    return months[calendar.get(Calendar.MONTH)];
  }
  
  public String currentYearString() {
    return ""+calendar.get(Calendar.YEAR);
  }
  
  public String currentFullDateString() {
    return currentDayString() + " " + currentMonthString() + " " + currentYearString();
  }

  public void gotoPrevDay() { gotoDay(-1); }
  public void gotoNextDay() { gotoDay(1);  }
  public void gotoDay(int count) {
    current_time = millis();
    
    if (current_time - last_time < 500) {
      if(current_time - start_time > 6000) { 
        calendar_type = Calendar.YEAR;
        amount = amount + 0.05f;
      }
      else if(current_time - start_time > 2000) {
        calendar_type = Calendar.MONTH;
        amount = amount + 0.05f;
      }
      else {  // normal date 
       amount = 1.0f; 
      }
    }
    else {
      start_time = current_time;
      calendar_type = Calendar.DATE;
      amount = 1.0f;
    }
    if ( Math.round(amount) > 0.999f) { 
       calendar.add(calendar_type, count);  
       setChanged();
       notifyObservers();
       amount = 0;
    }
    notifyObservers(currentDate());
    last_time = current_time;
  }

  public void render(){
//    ellipseMode(CENTER);
//    stroke(0.0, 1.0, 0);
//    fill(0, 1.0, 0, 0.5);
//    rect(xpos, ypos, this.img_width, this.img_height);      
//    fill(1.0, 1.0, 1.0, 1.0);
//    currentDayString() + " " + currentMonthString() + " " + currentYearString();
//    text(currentFullDateString(), xpos, midy);
  }
  
  public void step() {
//    img_width = width*0.25;
//    img_height = height*0.2;
//    xpos = (width-img_width-(width*0.02));
//    ypos = (height-img_height-(height*0.02));
//    midx = xpos + (img_width / 2);
//    midy = ypos + (img_height / 2);
  }

  public void log(String what) {
    if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
}

//ArrayList with days
class FEDayCollection extends ArrayList
{  
  public FEDayCollection() { }
  
  public FEDay getDay(Date date)
  {
    for(int i = 0; i < size(); i++){
      FEDay day = (FEDay) get(i);
      if (day.getDate().equals(date)){
        return day;
      }
    }
    return null;
  }
  
  public int getMaxPhotos()
  {
    int result = 0;
    for(int i = 0; i < size(); i++){
      int numberPhotos = ((FEDay) get(i)).countPhotos();
      result = Math.max(numberPhotos, result);
    }
    return result;
  }
}

//ArrayList with tags
class FEDay extends ArrayList
{
  Date date;
  HashMap sortedTags, sortedUsers;
  
  public FEDay(Date date)
  {
    this.date = date;
  }
  
  public Date getDate()
  {
    return date;
  }
  
  public int countPhotos()
  {
    int result = 0;
    for (int i = 0; i < size(); i++){
      FETag tag = (FETag) get(i);
      if (selectedTags.contains(tag.getTagName())){
        result += tag.size();
      }
    }
    return result;
  }
  
  public FETag getTag(String tagName)
  {
    for(int i = 0; i < size(); i++){
      FETag tag = (FETag) get(i);
      if (tag.getTagName().equals(tagName)){
        return tag;
      }
    }
    return null;
  }
  
  public HashMap getSortedTags()
  {
    HashMap unsorted = new HashMap();
    for(int i = 0; i < size(); i++){
      FETag tag = (FETag) get(i);
      if (selectedTags.contains(tag.getTagName())){
        unsorted = addHashMapValues(unsorted, tag.getSortedTags());
      }
    }
    sortedTags = sortHashMapByValuesD(unsorted, true);
    return sortedTags;
  }
  
  public HashMap getSortedUsers()
  {
    HashMap unsorted = new HashMap();
    for(int i = 0; i < size(); i++){
      FETag tag = (FETag) get(i);
      if (selectedTags.contains(tag.getTagName())){
        unsorted = addHashMapValues(unsorted, tag.getSortedUsers());
      }
    }
    sortedUsers = sortHashMapByValuesD(unsorted, true);
    return sortedUsers;
  }
}

//ArrayList with photos
class FETag extends ArrayList
{
  String tag;
  HashMap sortedTags, sortedUsers;
  
  public FETag(String tag)
  {
    this.tag = tag;
  }
  
  public String getTagName()
  {
    return tag;
  }
  
  public FEFlickrPhoto getPhoto(String id)
  {
    for(int i = 0; i < size(); i++){
      FEFlickrPhoto photo = (FEFlickrPhoto) get(i);
      if (photo.getId() == id){
        return photo;
      }
    }
    return null;
  } 
  
  public void setColor(float a)
  {
      fill(getTagColor(tag),a);
      stroke(getTagColor(tag));
  }
  
  public HashMap getSortedTags()
  {
    if (sortedTags == null){
      HashMap unsorted = new HashMap();
      for(int i = 0; i < size(); i++){
        FEFlickrPhoto photo = (FEFlickrPhoto) get(i);
        ArrayList tags = photo.getTags();
        for(int j = 0; j < tags.size(); j++){
          int count = 0;
          if (unsorted.containsKey(tags.get(j))){
            count = (Integer) unsorted.get(tags.get(j));
          }
          count++;
          unsorted.put(tags.get(j) ,count); 
        }
      }
      sortedTags = sortHashMapByValuesD(unsorted, true);
    }
    return sortedTags;
  }
  
  public HashMap getSortedUsers()
  {
    if (sortedUsers == null){
      HashMap unsorted = new HashMap();
      int count = 0;
      for(int i = 0; i < size(); i++){
        FEFlickrPhoto photo = (FEFlickrPhoto) get(i);
        if (unsorted.containsKey(photo.getOwnerName())){
          count = (Integer) unsorted.get(photo.getOwnerName());
        }
        count++;
        unsorted.put(photo.getOwnerName(),count); 
      }
      sortedUsers = sortHashMapByValuesD(unsorted, true);
    }
    return sortedUsers;
  }

}

class FEFlickrPhoto
{
  String id;
  String owner;
  String ownerName;
  String secret;
  String server;
  String farm;
  String latitude;
  String longitude;
  String tags;
  
  public FEFlickrPhoto(String id, String owner, String ownerName, String secret, String server, String farm, String latitude, String longitude, String tags)
  {
    this.id = id;
    this.owner = owner;
    this.ownerName = ownerName;
    this.secret = secret;
    this.server = server;
    this.farm = farm;
    this.latitude = latitude;
    this.longitude = longitude;
    this.tags = tags;
  }
  
  public String getId(){
    return id;
  }
  
  public String getOwner(){
    return owner;
  }
  
  public String getOwnerName(){
    return ownerName;
  }
  
  public String getSecret(){
    return secret;
  }
  
  public String getServer(){
    return server;
  }
  
  public String getFarm(){
    return farm;
  }
  
  public String getLatitude(){
    return latitude;
  }
  
  public String getLongitude(){
    return longitude;
  }
  
  public ArrayList getTags(){
    String[] tagArray = tags.split(",");
    ArrayList tagList = new ArrayList();
    for(int i = 0; i < tagArray.length; i++){
      if (!tagFilter.contains(tagArray[i])){
        tagList.add(tagArray[i]);
      }
    }
    return tagList;
  }
  
  public String getFlickrURL() {
    return "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret + ".jpg";
  }
}















class FEFlickrData
{
  String _date;
  
  public FEFlickrData(String date)
  {
    _date = date;

    try {
      String[] tags = new String[5];
      tags[0] = "trance";
      tags[1] = "jazz";
      tags[2] = "classic";
      tags[3] = "rock";
      tags[4] = "pop";
      for (int i = 0; i < 5; i++){
        FEDataSaver dataSaverDance = new FEDataSaver(_date, tags[i]);
        Thread thread = new Thread(new FEFlickrDataCall(_date, tags[i], 1, dataSaverDance), tags[i]+"1");
        thread.start();
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }
}

class FEFlickrDataCall implements Runnable
{
  Flickr _flickr;
  Thread _runner;
  String _tag;
  int _page;
  String _date;
  FEDataSaver _dataSaver;
  
  public FEFlickrDataCall(){}
  
  public FEFlickrDataCall(String date, String tag, int page, FEDataSaver dataSaver) throws ParserConfigurationException, IOException, SAXException
  {
    _flickr = new Flickr(
        "980124ce17646145142cb845bef6f495",
        "0e3d9f74e071939d",
        new REST()
    );
    
    _date = date;
    _tag = tag;
    _page = page;
    _dataSaver = dataSaver;
  }
  
  public FEFlickrDataCall(String threadName){
    _runner = new Thread(threadName);
    _runner.start();
  }
  
  public void run()
  {
    try {
      PhotoList photos = getPhotos(_page);
      System.out.println("Photo found: " + photos.size());
      if (_page == 1){
        for(int i = 2; i <= photos.getPages(); i++) {
          System.out.println("Next page");
          Thread thread = new Thread(new FEFlickrDataCall(_date, _tag, i, _dataSaver), _tag + i);
          thread.start();
        }
      }
      
      for (int i = 0; i < photos.size(); i++){
        _dataSaver.writePhoto((Photo) photos.get(i));
      }
      if (_page == photos.getPage()){
        _dataSaver.closeBuffer();
      }
      _runner.stop();
      
    } catch (Exception e) {
      //System.out.println("Run error: " + e.getMessage());
    }
  }
  
  public PhotoList getPhotos(int page) throws IOException, SAXException, FlickrException, ParseException
  {
    SearchParameters params = new SearchParameters();
    params.setExtras(true);
    params.setHasGeo(true);
    
    String[] tags = new String[2];
    tags[0] = _tag;
    tags[1] = "music";
    params.setTags(tags);
    params.setTagMode("all");
    
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date date = df.parse(_date);
    Date nextDay = df.parse(df.format((date.getTime() + 1000*3600*24)));
    params.setMinUploadDate(date);
    params.setMaxUploadDate(nextDay);
    System.out.println("GetPhotos: " + date + " - " + nextDay + " " + _tag + " " + page);
    
    return _flickr.getPhotosInterface().search(params, 500, page);
  }
}
  
  
class FEGraphic {
  boolean mouseover;
  public void display(float xpos, float ypos) { };
  public void setMouseOver(boolean mouse_is_over_me) { this.mouseover = mouse_is_over_me; };
  public void setRadius(float asize) {  };
}
class FEGui implements Observer
{
  ArrayList checkBoxes;
  FEDayCollection dayCollection;
  Date selectedDate;
  boolean update = false;
  
  FEGui(FEDayCollection dayCollection)
  {
    checkBoxes = new ArrayList();

    selectedDate = calendar.getTime();
    this.dayCollection = dayCollection;
  }
  
  public void update(Observable obj, Object arg)
  {
    dateView = (FEDateView)obj;
    selectedDate = dateView.currentDate();
    update = true;
  }
  
  public void step()
  {
  }
  
  public void render()
  {
    FEDay day = dayCollection.getDay(selectedDate);
    ArrayList topUsers = new ArrayList(day.getSortedUsers().keySet());
    ArrayList topTags = new ArrayList(day.getSortedTags().keySet());
    stroke(1);
    int textX = width-240;
    //Lines section
    line(width-250,0,width-250,height);
    line(width-250,height-150,width,height-150);
    
    //Text sections
    //Title
    fill(1);
    textFont(font, 50);
    text("GLOBAL PARTY VIEWER", 10, 50);
    
    //Details
    int textY = 40;
    textFont(font, 30); 
    text("Details", textX, 40);
    //details
    textY += 30;
    textFont(font, 12);
    text("Number of photos:", textX, textY);
    text(day.countPhotos(), textX + 120, textY);
    textY += 15;
    text("Number of users:", textX, textY);
    text(topUsers.size(), textX + 120, textY);
    textY += 15;
    text("Number of tags:", textX, textY);
    text(topTags.size(), textX + 120, textY);
    textY += 35;    
    
    //Users
    textFont(font, 20);
    text("Top 10 Users",textX, textY);
    //top users
    textY += 20;
    textFont(font, 12);
    for(int i = 0; i < topUsers.size() && i < 10; i++){
      text((i+1) + ".", textX, textY);
      text((String)topUsers.get(i), textX + 25, textY);
      textY += 15;
    }
    
    //Tags
    textY += 20;
    textFont(font, 20);
    text("Top 10 Tags", textX, textY);
    //Top tags
    textY += 20;
    textFont(font, 12);
    for(int i = 0; i < topTags.size() && i < 10; i++){
      text((i+1) + ".", textX, textY);
      text((String)topTags.get(i), textX + 25, textY);
      textY += 15;
    }
    
    //Date
    textFont(font, 25);
    text(dateView.currentDayString(), width - 140, height - 100);
    text(dateView.currentMonthString(), width - 155, height - 65);
    text(dateView.currentYearString(), width - 155, height - 25);
  }
}


class FEPhoto {
  PImage original_img;
  Gif progress_img;  
  
  float xpos = 20.0f;
  float ypos = 20.0f;
  float drag = 30.0f;
  boolean loading = true;

  String farm_id, server_id, id, secret;
  String flickr_url = "";
  
  FEPhoto(PApplet parent, Photo p) {
    // extract photo info
    progress_img = new Gif(parent, "loader.gif"); //loadImage("loader.gif");  // Load the image into the program  
    progress_img.play();    
//    setFlickrURL(createFlickrURL("4", "3198", "3055949628", "4323e215d3"));
//    setFlickrURL("http://farm2.static.flickr.com/1023/529567127_cf62646bd3.jpg?v=0");
  }
  
  FEPhoto(PApplet parent) {
    progress_img = new Gif(parent, "loader.gif"); //loadImage("loader.gif");  // Load the image into the program  
    progress_img.play();    
  }

  // requestImage(filename)
  //
  // LOAD SHIT ASYNC!
  //
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
  //	or
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
  //	or
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
  // 
  // http://farm4.static.flickr.com/3198/3055949628_4323e215d3.jpg?v=0
  
  public void setFlickrURL(String url) { 
    this.flickr_url = url;
    this.loading = true;
    this.original_img = requestImage(this.flickr_url);
  }

  public void setFlickrURL(String farm_id, String server_id, String id, String secret) {
    setFlickrURL(createFlickrURL(farm_id, server_id, id, secret));    
  } 
  
  public String createFlickrURL(String farm_id, String server_id, String id, String secret) {
    return "http://farm" + farm_id + ".static.flickr.com/" + server_id + "/" + id + "_" + secret + ".jpg";
  }

  public FEPhoto step() {
    if( loading && original_img != null) {
      switch(original_img.width) {
        case 0: 
            // still loading do nothing
            break;
        case -1: // loading failure
        default: 
            loading = false; // loaded successfully
      }
    }

    float difx = (mouseX)-(progress_img.width/2) - xpos;
    if( abs(difx) > 1.0f ) {
      xpos = xpos + difx/drag;
//      xpos = constrain(xpos, 0, (mouseX)-(progress_img.width/2));
    }  
  
    float dify = mouseY - progress_img.height - ypos;
    if( abs(dify) > 1.0f ) {
      ypos = ypos + dify/drag;
//      ypos = constrain(ypos, 0, mouseY-progress_img.height);
    }  
    return this;
  }

  public void render() {
    // Displays the image at point (100, 0) at half of its size
    if( loading ) {
       image(progress_img, xpos, ypos);  // when an error occurs just render nothing
    } else {
      if( original_img != null && original_img.width != -1) {
        image(original_img, xpos, ypos);
      }
    }
  }
}


class FEPhotoGroup {
  public float x, y, radius;
  public Vector photos;
  boolean showPhotos = false;
  boolean fadingIn = false;
  float calculated_radius;
  float calculated_radius_end;
  float calculated_radius_begin = 0;
  public FEWorldMap worldmap = null;
  String tagname;
  
  FEPhotoGroup() {
    this(0, 0, 1);
  }
  
  public void setTagname(String aTagname) { tagname = aTagname; }
  public String getTagname() { return tagname; }
  
  FEPhotoGroup(float x, float y, int radius) {
    this.radius = max(radius,1);
    this.x = x;
    this.y = y;
    photos = new Vector();
  }

  public void step(FEWorldMap worldmap) {
    calculated_radius_end = (radius*2)*(max(photos.size(),1));
    if (calculated_radius <= calculated_radius_end) {
      calculated_radius = calculated_radius + ((calculated_radius_end - calculated_radius_begin) * 0.02f);
    }
  }
  
  public void addPhoto(FEFlickrPhoto p) {
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

  public boolean is_inside(String latitude, String longitude) {
    return is_inside(Float.parseFloat(latitude), Float.parseFloat(longitude));
  }
  
  public boolean is_inside(float latitude, float longitude) {
    return dist(x, y, latitude, longitude) < 0.005f ;  
  }
  
  public void render() {
    ellipseMode(CENTER);
    float calculated_radius = (radius*2)*(max(photos.size(),1));
    stroke(1.0f, 0, 0);
    fill(1.0f, 0, 0, 0.5f);
    ellipse(x, y, calculated_radius, calculated_radius);
//    ellipse(x, y, radius, radius);
  }
  
  public void render(FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 

    ellipseMode(CENTER);
    float calculated_radius = (radius*2)*(max(photos.size(),1));
   if( !showPhotos ) {
    stroke(1.0f, 0, 0);
    fill(1.0f, 0, 0, 0.5f);
   }
   else {
    stroke(1.0f, 1.0f, 1.0f);
    fill(1.0f, 1.0f, 1.0f, 0.2f);
   }
    ellipse(pointXlong, pointYlat, calculated_radius, calculated_radius);

    stroke(1.0f, 1.0f, 1.0f);
    fill(1.0f, 1.0f, 1.0f);
    ellipse(pointXlong, pointYlat, 1, 1);
    
   if( showPhotos ) {
     for(int i=0; i<photos.size(); i++) {
       
//       ((FEPhoto)photos.get(i)).render(this);
     }
   }
  }
  
  public void toggleShowPhotos() {
    showPhotos = !showPhotos;
  }
  
  public float getX() { return worldmap.longToX(x); } 
  public float getY() { return worldmap.latToY(y); } 
  public float getRadius() { return (radius*2)*(max(photos.size(),1)); }
  
  public boolean mouse_inside(float mx, float my, FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 
    float calculated_radius = (radius*2)*(max(photos.size(),1));
    return dist(mx,my,pointXlong,pointYlat) <= calculated_radius;
  }
}


class FEPhotoGroupRedmar {
  float x, y, radius;
  Vector photos;
  boolean showPhotos = false;
  boolean fadingIn = false;
  float calculated_radius;
  float calculated_radius_end;
  float calculated_radius_begin = 0;
  
  FEPhotoGroupRedmar() {
    this(0, 0, 1);
  }
  
  FEPhotoGroupRedmar(float x, float y, int radius) {
    this.radius = max(radius,1);
    this.x = x;
    this.y = y;
    photos = new Vector();
  }

  public void step(FEWorldMap worldmap) {
    calculated_radius_end = (radius*2)*(max(photos.size(),1));
    if (calculated_radius <= calculated_radius_end) {
      calculated_radius = calculated_radius + ((calculated_radius_end - calculated_radius_begin) * 0.02f);
    }
  }
  
  public void addPhoto(Photo p) {
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

  public boolean is_inside(float latitude, float longitude) {
    return dist(x, y, latitude, longitude) < 0.005f ;  
  }
  
//  void render() {
//    ellipseMode(CENTER);
//    float calculated_radius = (radius*2)*(max(photos.size(),1));
//    stroke(1.0, 0, 0);
//    fill(1.0, 0, 0, 0.5);
//    ellipse(x, y, calculated_radius, calculated_radius);
//  }
  
  public void render(FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 

    ellipseMode(CENTER);
//    float calculated_radius = (radius*2)*(max(photos.size(),1));

   if( !showPhotos ) {
    stroke(1.0f, 0, 0);
    fill(1.0f, 0, 0, 0.5f);
   }
   else {
    stroke(1.0f, 1.0f, 1.0f);
    fill(1.0f, 1.0f, 1.0f, 0.2f);
    
   }
    ellipse(pointXlong, pointYlat, calculated_radius, calculated_radius);

    stroke(1.0f, 1.0f, 1.0f);
    fill(1.0f, 1.0f, 1.0f);
    ellipse(pointXlong, pointYlat, 1, 1);
    
   if( showPhotos ) {
     for(int i=0; i<photos.size(); i++) {
       
//       ((FEPhoto)photos.get(i)).render(this);
     }
   }
  }
  
  public void toggleShowPhotos() {
    showPhotos = !showPhotos;
  }
  
  public boolean mouse_inside(float mx, float my, FEWorldMap worldmap) {
    float pointXlong = worldmap.longToX(x);
    float pointYlat  = worldmap.latToY(y); 
    float calculated_radius = (radius*2)*(max(photos.size(),1));
    return dist(mx,my,pointXlong,pointYlat) <= calculated_radius;
  }
}


class FEPhotoRedmar {
  PImage original_img;
  Gif progress_img;  
  
  float xpos = 20.0f;
  float ypos = 20.0f;
  float drag = 30.0f;
  boolean loading = true;

  String farm_id, server_id, id, secret;
  String flickr_url = "";
  
  FEPhotoRedmar(PApplet parent, Photo p) {
    // extract photo info
    progress_img = new Gif(parent, "loader.gif"); //loadImage("loader.gif");  // Load the image into the program  
    progress_img.play();    
//    setFlickrURL(createFlickrURL("4", "3198", "3055949628", "4323e215d3"));
//    setFlickrURL("http://farm2.static.flickr.com/1023/529567127_cf62646bd3.jpg?v=0");
  }
  
  FEPhotoRedmar(PApplet parent) {
    progress_img = new Gif(parent, "loader.gif"); //loadImage("loader.gif");  // Load the image into the program  
    progress_img.play();    
  }

  // requestImage(filename)
  //
  // LOAD SHIT ASYNC!
  //
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
  //	or
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
  //	or
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
  // 
  // http://farm4.static.flickr.com/3198/3055949628_4323e215d3.jpg?v=0
  
  public void setFlickrURL(String url) { 
    this.flickr_url = url;
    this.loading = true;
    this.original_img = requestImage(this.flickr_url);
  }

  public void setFlickrURL(String farm_id, String server_id, String id, String secret) {
    setFlickrURL(createFlickrURL(farm_id, server_id, id, secret));    
  } 
  
  public String createFlickrURL(String farm_id, String server_id, String id, String secret) {
    return "http://farm" + farm_id + ".static.flickr.com/" + server_id + "/" + id + "_" + secret + ".jpg";
  }

  public FEPhotoRedmar step() {
    if( loading && original_img != null) {
      switch(original_img.width) {
        case 0: 
            // still loading do nothing
            break;
        case -1: // loading failure
        default: 
            loading = false; // loaded successfully
      }
    }

    float difx = (mouseX)-(progress_img.width/2) - xpos;
    if( abs(difx) > 1.0f ) {
      xpos = xpos + difx/drag;
//      xpos = constrain(xpos, 0, (mouseX)-(progress_img.width/2));
    }  
  
    float dify = mouseY - progress_img.height - ypos;
    if( abs(dify) > 1.0f ) {
      ypos = ypos + dify/drag;
//      ypos = constrain(ypos, 0, mouseY-progress_img.height);
    }  
    return this;
  }

  public void render() {
    // Displays the image at point (100, 0) at half of its size
    if( loading ) {
       image(progress_img, xpos, ypos);  // when an error occurs just render nothing
    } else {
      if( original_img != null && original_img.width != -1) {
        image(original_img, xpos, ypos);
      }
    }
  }
}
// Processing example spring changed to fit in FlickrEvents 
class FESpring 
{ 
  // Screen values 
  public float xpos, ypos;
  float tempxpos, tempypos; 

  float size = 20; 
  float tempsize = 20;
  float restsize = 20;
  float velsize = 0.0f;
  
  FEPhotoGroup associated_photogroup = null;
  boolean showPhotos = false;
  
  boolean over = false; 
  boolean move = false; 
 
  // Spring simulation constants 
  float mass;       // Mass 
  float k = 0.2f;    // Spring constant 
  float damp;       // Damping 
  public float rest_posx;  // Rest position X 
  public float rest_posy;  // Rest position Y 

  // Spring simulation variables 
  //float pos = 20.0; // Position 
  float velx = 0.0f;   // X Velocity 
  float vely = 0.0f;   // Y Velocity 
  float accel = 0;    // Acceleration 
  float force = 0;    // Force 
  FEGraphic displayFunctor = null;

  FESpring[] friends;
  int me;
  
  public void setDisplayFunctor(FEGraphic aDisplayFunctor) { displayFunctor = aDisplayFunctor; }
  
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

  public void update() 
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

    
    if ((over() || move) /*&& !otherOver()*/ ) { 
      over = true; 
    } else { 
      over = false; 
    } 
  } 
  
  public void setPosition(float x, float y) {
    xpos = rest_posx = x; ypos = rest_posy = y;
  }
  
  public void setTempPosition(float x, float y) {
    tempxpos = x; tempypos = y;
  }

  // Test to see if mouse is over this spring
  public boolean over() {
    if (dist(tempxpos, tempypos, mouseX, mouseY) < tempsize) {
      return true;
    } else {
      return false;
    }
  }
  
  // Make sure no other springs are active
  public boolean otherOver() {
    for (int i=0; i<springCount; i++) {
      if (i != me) {
        if (friends[i].over == true) {
          return true;
        }
      }
    }
    return false;
  }

  public void setRadius(float asize) {
    tempsize = this.restsize;
    this.restsize = asize;
  }
  
  public void display() 
  { 
    if (displayFunctor == null) return;
    
    line(tempxpos, tempypos, xpos, ypos);
    
    if (over) { 
      displayFunctor.setMouseOver(true);
      displayFunctor.display(tempxpos,tempypos);
    } else { 
      displayFunctor.setMouseOver(false);
      displayFunctor.display(tempxpos,tempypos);
    }
    
    if (showPhotos) {
      stroke(1.0f, 1.0f, 1.0f, 1.0f);
      fill(1.0f, 1.0f, 1.0f, 1.0f);
      rect(tempxpos, tempypos, 30, 30);
      // for each photo 
    }
  } 

  public void pressed() 
  { 
    if (over) { 
      move = true; 
    } else { 
      move = false; 
    }  
  } 

  public void released() 
  { 
    if (over) { 
      if(associated_photogroup!=null) { showPhotos = !showPhotos; }
    }
    move = false; 
    rest_posx = xpos;  
    rest_posy = ypos;
  } 
  
  public void moveTo(float movetox, float movetoy) {
    float oldx = rest_posx; 
    float oldy = rest_posy;
    float nx = movetox;
    float ny = movetoy;
    setPosition(nx, ny);
    setTempPosition(oldx, oldy);
//    springs[i].setRadius(3 + random(200));
  }
  
  public void setPhotogroup(FEPhotoGroup pg) {
    showPhotos = false;
    associated_photogroup = pg;
  }
  public FEPhotoGroup getPhotogroup() {
    return associated_photogroup;
  }
} 


class FETimeLine implements Observer {
  FEDayCollection dayCollection;
  float resizeFactor;
  float locationX, locationY, stdBinWidth;
  Date selectedDate;
  float selectedDateWidth;
  boolean update = false;
  boolean bounce = true;
  boolean debug = false;
  float totalWidth;
  
  FETimeLine(FEDayCollection dayCollection){
    this.dayCollection = dayCollection;
    resizeFactor = 200 / (float) dayCollection.getMaxPhotos();
    selectedDateWidth = 60;
    selectedDate = calendar.getTime();
    locationX = 110;
  }
  
  public void update(Observable obj, Object arg)
  {
    selectedDate = ((FEDateView)obj).currentDate();
    update = true;
  }
      
  public void step(){
    locationY = height - 30;
    stdBinWidth = (float) Math.floor((width - 400) / dayCollection.size()/2);
  }
  
  public void render(){
    float startX = locationX;
    for(int i = 0; i < dayCollection.size(); i++){
      FEDay day = (FEDay) dayCollection.get(i);
      FEDay nextDay;
      
      if (i == (dayCollection.size() - 1)){
        nextDay = null;
      } else {
        nextDay = (FEDay) dayCollection.get(i + 1);
      }
      
      if(day.getDate().equals(selectedDate)){
        renderDay(startX, day, nextDay, true);
        startX += selectedDateWidth + stdBinWidth;
      } else {
        renderDay(startX, day, nextDay, false);
        startX += stdBinWidth*2;
      }
    }
  }
  
  public void renderDay(float startX, FEDay day, FEDay nextDay, boolean isSelected){
    float startY = locationY, nextY = locationY, binWidth;
    if (isSelected){
      noStroke();
      fill(1,1,1,0.1f);
      rect(startX, locationY - 200, selectedDateWidth, 200 + stdBinWidth+5);
      binWidth = selectedDateWidth;
    } else {
      binWidth = stdBinWidth;
    }
    fill(1);
    textFont(font,stdBinWidth);
//    text(df.format(day.getDate()),startX + (binWidth/2 - 1- (stdBinWidth/2)), startY + stdBinWidth+3);
    for(int i = 0; i < tagOrder.length; i++){
      float h, nextH;
      
      //Render Rect
      FETag tag = day.getTag(tagOrder[i]);
      if (isSelected){
        tag.setColor(0.6f);
      } else {
        tag.setColor(0.4f);
      }
      
      h = (float) tag.size() * resizeFactor;
      rect(startX, startY - h, binWidth, h);
      
      //Render quad
      tag.setColor(0.4f);
      if (nextDay != null){
        FETag nextTag = nextDay.getTag(tagOrder[i]);
        nextH = (float) nextTag.size() * resizeFactor;
        quad(startX + binWidth, startY - h, startX + stdBinWidth + binWidth, nextY - nextH, startX + stdBinWidth + binWidth, nextY, startX + binWidth, startY);
      
        nextY -= nextH;
      }
      startY -= h;
    }
  }
  
  public void log(String what) {
    if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
  
}
int springCount = 0;
int num = 100; 
FESpring[] springs = new FESpring[num]; 

class FEWorldMap implements Observer {
  PImage img;
  float xpos;
  float ypos;
  float drag = 30.0f;
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
  
  public void loadDay() {
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
  
  public void processMousePressed(float mx, float my) { 
    for (int i=0; i < springCount; i++) {
      if(springs[i].over()) {
        springs[i].pressed();
        System.out.println(springs[i].getPhotogroup().photos);
      }
    }
  }

  public void processMouseReleased(float mx, float my) { 
    for (int i=0; i < springCount; i++) {
//      if(springs[i].over()) 
      springs[i].released();
    }
  }

  public void step() {
    img_width = width-270;
    img_height = height-220;

    for (int i=0; i < photoGroups.size(); i++) {
      ((FEPhotoGroup)photoGroups.get(i)).step(this);
    }

    for (int i=0; i < springCount; i++) {
      springs[i].update();
    }
  }
  
  public void render() {
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
          springs[i] = new FESpring(group.getX(), group.getY(), 3.0f, 0.80f, 10, 0.9f, springs, 0);
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

    for (int i=0; i < springCount; i++) {
      springs[i].display();
    }
  }
  
  public void renderGeoPoint(float longitude_x, float latitude_y) 
  {
    float pointXlong = longToX(longitude_x);
    float pointYlat  = latToY(latitude_y);  //  -90     90 
    
    stroke(255,0,0);
    point(pointXlong, pointYlat);
  }
  
  public float longToX(float longitude)
  {
    return xpos + ((img_width / 360.0f) * (longitude + 180));
  }
  
  public float latToY(float latitude)
  {
    return ypos + ((img_height / 180.0f) * (-1 * (latitude - 90)));
  }
  
 /* This function will be called by the FEDateView class when it's date has changed.
  * Meaning the whole GUI has to change/recalculate to the new date. */
  public void update(Observable o, Object arg) { 
    selectedDate = ((FEDateView)o).currentDate();
    currentDay = dayCollection.getDay(selectedDate);
    loadDay();
  }
  
  public void log(String what) {
    if(DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
}

class FECircleGraphic extends FEGraphic
{
  float radius = 10.0f;
  FETag mytag = null;
  
  FECircleGraphic(float aradius) { 
    this.radius = aradius; 
  }
  
  public void display(float xpos, float ypos) {
    noStroke();
    if (mouseover) {
      if (mytag != null) {
        fill(getTagColor(mytag.getTagName()),0.5f);
        stroke(getTagColor(mytag.getTagName()), 0.5f);
      }
    }
    else {
      if (mytag != null) {
        fill(getTagColor(mytag.getTagName()),0.8f);
        stroke(getTagColor(mytag.getTagName()), 0.8f);
      }
    }
    ellipseMode(CENTER);
    ellipse(xpos, ypos, radius, radius);      
  }
  
  public void setRadius(float asize) 
  {
    float logsize = (float)Math.log(max(asize,1.0f));
    asize = max(logsize*15,5.0f);
    this.radius = asize;
  }
  
  public void setTag(String atag) {
    mytag = new FETag(atag);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ffffff", "FlickrEvents" });
  }
}
