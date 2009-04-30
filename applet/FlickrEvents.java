import processing.core.*; 
import processing.xml.*; 

import java.io.*; 
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

boolean search_on_startup = false;
boolean w_event = true;
FETimeLine fe_timeline;  
FEWorldMap fe_worldmap;
FEPhotoGroup pg;  //tmp
FEPhoto photo;    // tmp
FEDateView dateView;
String cacheDir = "/Users/benoist/flickrevents/cache/";

public void setup() {
  smooth();
  colorMode(RGB, 1.0f);

  frame.setResizable(true); 
  size(screen.width, screen.height-50);

  pg = new FEPhotoGroup(200,200,30);
  photo = new FEPhoto(this);

  fe_worldmap = new FEWorldMap();  
  fe_timeline = new FETimeLine();
  dateView = new FEDateView(this);
  
  if(search_on_startup) {
    try {
      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
      Date date = df.parse("2009-04-28");
      for(int i = 0; i < 31; i++){
        String prevDay = df.format((date.getTime() - i * 1000*3600*24));
        if (!new File(cacheDir+prevDay).exists()){
          FEFlickrData fe_data = new FEFlickrData(prevDay);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
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

  fe_worldmap.step();
  fe_worldmap.render();

  pg.render();

  photo.step().render();

  fe_timeline.step();
  fe_timeline.render();
  
  dateView.step();
  dateView.render();
}

public void mouseClicked() {
  System.out.println("click");
  fe_worldmap.processMouseClick(mouseX, mouseY);
}

public void keyPressed(){
  if(key=='w'||key=='W'){
    w_event = !w_event;
  }
} 

public void keyReleased() {
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
    photoString = "<photo id=\""+p.getId()+"\" owner=\""+p.getOwner().getId()+"\" secret=\""+p.getSecret()+"\" server=\""+p.getServer()+"\" farm=\""+p.getFarm()+"\" latitude=\""+p.getGeoData().getLatitude()+"\" longitude=\""+p.getGeoData().getLongitude()+"\" tags=\""+tags+"\"/>\n";
    
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
class FEDateView {
  PImage original_img;
  PApplet parent;
  
  float xpos = 200.0f;
  float ypos = 200.0f;
  float img_width = 320.0f;
  float img_height = 200.0f;
  float midx = 0;
  float midy = 0;
  
//  float drag = 30.0;
//  boolean loading = true;
//
//  String farm_id, server_id, id, secret;
//  String flickr_url = "";

  FEDateView() {
    // 
    //
    //
  }
  
  FEDateView(PApplet parent) {
    this.parent = parent;
  }
  
  public void initDateView() {
//    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//    Date date = df.parse("2009-04-28");
  }
  
  public void render(){
    ellipseMode(CENTER);
    stroke(0.0f, 1.0f, 0);
    fill(0, 1.0f, 0, 0.5f);
    ellipse(xpos, ypos, 5, 5);  
    rect(xpos, ypos, this.img_width, this.img_height);  
    line(midx - (img_width/2), midy, midx + (img_width/2), midy);
    
    fill(1.0f, 1.0f, 1.0f, 1.0f);
    beginShape();
      vertex(30, 20);
      vertex(85, 20);
      vertex(85, 75);
      vertex(30, 75);
    endShape(CLOSE);

    beginShape();
      curveVertex(midx,  ypos);
      curveVertex(xpos,  midy);
      curveVertex(midx,  ypos + img_height);
      curveVertex(midx,  ypos);
    endShape(CLOSE);
    
    int d = day();    // Values from 1 - 31
    int m = month();  // Values from 1 - 12
    int y = year();   // 2003, 2004, 2005, etc.
    String s = String.valueOf(d);

//    PFont metaBold;
//    String[] fontList = PFont.list();
//    println(fontList);
    PFont myFont = createFont("FuturaLT", 48);
//    metaBold = loadFont("fonts/Meta-Bold.vlw.gz"); 
    textFont(myFont, 48); 
    text(s + " Januari " + "2009", midx, midy);
  }
  
  public void step() {
    img_width = width*0.25f;
    img_height = height*0.2f;
    xpos = (width-img_width-(width*0.02f));
    ypos = (height-img_height-(height*0.02f));
    midx = xpos + (img_width / 2);
    midy = ypos + (img_height / 2);
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
  float x, y, radius;
  Vector photos;
  boolean showPhotos = false;
  boolean fadingIn = false;
  float calculated_radius;
  float calculated_radius_end;
  float calculated_radius_begin = 0;
  
  FEPhotoGroup() {
    this(0, 0, 1);
  }
  
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
class FETimeLine {
  int[] a = new int[367];
  int[] b = new int[367];
  int maxPerDay = 0;
  float fe_timeline_height = 100;
  float fe_timeline_day_small_width;
  float fe_timeline_day_selected_width = 35;
  int selected_day = 11;
  
  FETimeLine(){
    generateArrays();
    fe_timeline_day_small_width = (float)1024 / 365.0f;
  }
  
  public void generateArrays(){
    Random generator = new Random(1);
    
    for(int i = 0; i < 367; i++){
      a[i] = generator.nextInt(50);
      b[i] = generator.nextInt(50);
      
      maxPerDay = Math.max(maxPerDay, Math.max(a[i], b[i]));
    }
  }
  
  public void step(){
    
    if (mouseX > 1024){
      selected_day = 365;
    } else {
      selected_day = (int)((float) mouseX / fe_timeline_day_small_width);
    }
  }
  
  public void render(){
    float x = 0;
    float y = 0;
    noStroke();
    for(int i = 1; i < 366; i++){
      //Draw a
      
      if (i == selected_day){
        fill(1.0f,1.0f,0);
        beginShape();
          vertex(x, y);
          y = a[i-1];
          vertex(x, y);
          x += fe_timeline_day_selected_width / 2.0f;
          y = a[i];
          vertex(x,y);
          x += fe_timeline_day_selected_width / 2.0f;
          y = a[i+1];
          vertex(x, y);
          y = 0;
          vertex(x, y);
        endShape(CLOSE);
        
        x -= fe_timeline_day_selected_width;
        
        fill(1.0f,0.0f,0);
        beginShape();
          y = a[i-1];
          vertex(x, y);
          y = a[i-1] + b[i-1];
          vertex(x, y);
          x += fe_timeline_day_selected_width / 2.0f;
          y = a[i] + b[i];
          vertex(x,y);
          x += fe_timeline_day_selected_width / 2.0f;
          y = a[i+1] + b[i+1];
          vertex(x, y);
          y = a[i+1];
          vertex(x, y);
          x -= fe_timeline_day_selected_width / 2.0f;
          y = a[i];
          vertex(x,y);
          x += fe_timeline_day_selected_width / 2.0f;
        endShape(CLOSE);
      } else {
        fill(1.0f,1.0f,0);
        rect(x,0,fe_timeline_day_small_width,a[i]);
        fill(1.0f,0,0);
        rect(x,a[i],fe_timeline_day_small_width, a[i] + b[i]);
        x += fe_timeline_day_small_width;
      }
      /*

      */
    }
  }
}
class FEWorldMap {
  PImage img;
  float xpos;
  float ypos;
  float drag = 30.0f;
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
  public synchronized void addPhoto(Photo p) {
   
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
  
  public void processMouseClick(float mx, float my) {
    for (int i=0; i < photoGroups.size(); i++) {
      if( ((FEPhotoGroup)photoGroups.get(i)).mouse_inside(mx,my, this) ) {
        System.out.println("INSIDE " + ((FEPhotoGroup)photoGroups.get(i)));
        ((FEPhotoGroup)photoGroups.get(i)).toggleShowPhotos();
      }
    }    
  }

  public void step() {
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

    img_width = width*0.7f;
    img_height = height*0.8f;
    xpos = (width*0.05f);
    ypos = (height*0.1f);

    for (int i=0; i < photoGroups.size(); i++) {
      ((FEPhotoGroup)photoGroups.get(i)).step(this);
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

  public void render() {
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
  public void renderGeoPoint(float longitude_x, float latitude_y) 
  {
    float pointXlong = longToX(longitude_x);
    float pointYlat  = latToY(latitude_y);  //  -90     90 
    
    stroke(255,0,0);
    point(pointXlong, pointYlat);
    //arc(pointXlong,pointYlat, Math.abs(longToX(-90.0) - pointXlong), Math.abs(latToY(-90.0) - pointYlat),PI,PI/2) ;
    //noFill();
    //arc(pointXlong,pointYlat, 100, 100,0,1) ;
  }
  
  public float longToX(float longitude)
  {
    return xpos + ((img_width / 360.0f) * (longitude + 180));
  }
  
  public float latToY(float latitude)
  {
    return ypos + ((img_height / 180.0f) * (-1 * (latitude - 90)));
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ffffff", "FlickrEvents" });
  }
}
