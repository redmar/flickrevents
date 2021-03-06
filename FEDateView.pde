import java.util.*;

class FEDateView extends Observable {
  PImage original_img;
  PApplet parent;
  PFont font;
  boolean debug = false;
  
  // min : 28 maart 2009
  // max : 27 april 2009
  GregorianCalendar min_date = new GregorianCalendar(2009, 2, 28);
  GregorianCalendar max_date = new GregorianCalendar(2009, 3, 27);
  
  GregorianCalendar calendar;

  // used for date skipping
  float start_time = -1; 
  float last_time = -1;
  float current_time = -1;
  int calendar_type = Calendar.DATE;
  float amount = 1.0;

  float xpos = 200.0;
  float ypos = 200.0;
  float img_width = 320.0;
  float img_height = 200.0;
  float midx = 0;
  float midy = 0;
    
  FEDateView(PApplet parent) {
    this.parent = parent;
    initDateView();
  }
  
  void initDateView() {
    calendar = new GregorianCalendar(2009, 2, 30);
    log("Setting up calender to: " + currentFullDateString());
    log("Setting up calender to date: " + currentDate());
  }

  Date currentDate() {
    return calendar.getTime();
  }

  // return day number as string with padded zero in front of it (always giving back 2 decimals)
  String currentDayString() {
    return ((calendar.get(Calendar.DATE) < 10) ? "0"+calendar.get(Calendar.DATE) : ""+calendar.get(Calendar.DATE));
  }
  
  String currentMonthString() {
    String[] months = {"January", "Februari", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    return months[calendar.get(Calendar.MONTH)];
  }
  
  String currentYearString() {
    return ""+calendar.get(Calendar.YEAR);
  }
  
  String currentFullDateString() {
    return currentDayString() + " " + currentMonthString() + " " + currentYearString();
  }
    
  void setCurrentDate(Date date){
    calendar.setTime(date);
    scattered = false;
    setChanged();
    notifyObservers();
  }

  void gotoPrevDay() { gotoDay(-1); }
  void gotoNextDay() { gotoDay(1);  }
  void gotoDay(int count) {
    scattered = false;
//    current_time = millis();
//    
//    if (current_time - last_time < 500) {
//      if(current_time - start_time > 6000) { 
//        calendar_type = Calendar.YEAR;
//        amount = amount + 0.05;
//      }
//      else if(current_time - start_time > 2000) {
//        calendar_type = Calendar.MONTH;
//        amount = amount + 0.05;
//      }
//      else {  // normal date 
//       amount = 1.0; 
//      }
//    }
//    else {
//      start_time = current_time;
//      calendar_type = Calendar.DATE;
//      amount = 1.0;
//    }
//    if ( Math.round(amount) > 0.999) { 

      GregorianCalendar tmp_calendar = new GregorianCalendar();
      tmp_calendar.setTime(calendar.getTime());
      tmp_calendar.add(calendar_type, count);
//      calendar.add(calendar_type, count);
      if( ( tmp_calendar.getTime().compareTo(max_date.getTime()) <= 0) &&
          ( tmp_calendar.getTime().compareTo(min_date.getTime()) >= 0)) { calendar.add(calendar_type, count); }
       setChanged();
//       notifyObservers();
//       amount = 0;
//    }
    notifyObservers(currentDate());
//    last_time = current_time;
  }

  void render(){
//    ellipseMode(CENTER);
//    stroke(0.0, 1.0, 0);
//    fill(0, 1.0, 0, 0.5);
//    rect(xpos, ypos, this.img_width, this.img_height);      
//    fill(1.0, 1.0, 1.0, 1.0);
//    currentDayString() + " " + currentMonthString() + " " + currentYearString();
//    text(currentFullDateString(), xpos, midy);
  }
  
  void step() {
//    img_width = width*0.25;
//    img_height = height*0.2;
//    xpos = (width-img_width-(width*0.02));
//    ypos = (height-img_height-(height*0.02));
//    midx = xpos + (img_width / 2);
//    midy = ypos + (img_height / 2);
  }

  void log(String what) {
    if( DEBUG || this.debug ) System.out.println(getClass() + " : " + what);
  }
}
