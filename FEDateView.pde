import java.util.*;

class FEDateView {
  PImage original_img;
  PApplet parent;
  PFont font;
  
  GregorianCalendar calendar;

  float xpos = 200.0;
  float ypos = 200.0;
  float img_width = 320.0;
  float img_height = 200.0;
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
    initDateView();
  }
  
  void initDateView() {
	calendar = new GregorianCalendar(2009, 4, 28);
	System.out.println("Setting up calender to: " + currentDateString());
	// calendar = new GregorianCalendar(year(), month(), day());  // do this for current date
	
    PFont font = createFont("FuturaLT", 48);
    textFont(font, 48); 
//    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//    Date date = df.parse("2009-04-28");
  }

  Date currentDate() {
    return null;
  }

  String currentDateString() {
    String[] months = {"January", "Februari", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    String day_padded = ((calendar.get(Calendar.DATE) < 10) ? "0"+calendar.get(Calendar.DATE) : ""+calendar.get(Calendar.DATE));
    return day_padded + " " + months[calendar.get(Calendar.MONTH)] + " " + calendar.get(Calendar.YEAR);
  }

  void gotoPrevDay() {
	calendar.add(Calendar.DATE, -1);
  }

  void gotoNextDay() {
	calendar.add(Calendar.DATE, 1);
  }

  void render(){
    ellipseMode(CENTER);
    stroke(0.0, 1.0, 0);
    fill(0, 1.0, 0, 0.5);
//    ellipse(xpos, ypos, 5, 5);  
    rect(xpos, ypos, this.img_width, this.img_height);  
//    line(midx - (img_width/2), midy, midx + (img_width/2), midy);
    
//    fill(1.0, 1.0, 1.0, 1.0);
//    beginShape();
//      vertex(30, 20);
//      vertex(85, 20);
//      vertex(85, 75);
//      vertex(30, 75);
//    endShape(CLOSE);
//
//    beginShape();
//      curveVertex(midx,  ypos);
//      curveVertex(xpos,  midy);
//      curveVertex(midx,  ypos + img_height);
//      curveVertex(midx,  ypos);
//    endShape(CLOSE);
    
    fill(1.0, 1.0, 1.0, 1.0);
    text(currentDateString(), xpos, midy);
  }
  
  void step() {
    img_width = width*0.25;
    img_height = height*0.2;
    xpos = (width-img_width-(width*0.02));
    ypos = (height-img_height-(height*0.02));
    midx = xpos + (img_width / 2);
    midy = ypos + (img_height / 2);
  }

}
