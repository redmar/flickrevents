class FEGui implements Observer
{
  ArrayList checkBoxes = new ArrayList();
  ArrayList userLinks = new ArrayList();
  FEDayCollection dayCollection;
  Date selectedDate;
  boolean update = false;
  PImage logo;
  
  FEGui(FEDayCollection dayCollection)
  {
    logo = loadImage("logo.png"); 
    
    for (int i = 0; i < tagOrder.length; i++){
      CheckBox box = new CheckBox(1,1,10,10,getTagColor(tagOrder[i]),selectedTags.contains(tagOrder[i]), tagOrder[i]);
      checkBoxes.add(box);
    }
    for (int i = 0; i < 10; i++){
      Link link = new Link();
      userLinks.add(link);
    }
    selectedDate = calendar.getTime();
    this.dayCollection = dayCollection;
  }
  
  void update(Observable obj, Object arg)
  {
    dateView = (FEDateView)obj;
    selectedDate = dateView.currentDate();
    update = true;
  }
  
  void step()
  {
  }
  
  void render()
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
//    textFont(font, 50);
//    text("GLOBAL PARTY VIEWER", 10, 50);
    imageMode(CORNER);
    image(logo, 0, 0);
    
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
      String ownerName = ((String)topUsers.get(i)).split(":")[1];
      String owner = ((String)topUsers.get(i)).split(":")[0];
      if( selectedPhoto != null && selectedPhoto.getOwnerName().equals( ownerName)) { fill(1.0,0,0); }

      text((i+1) + ".", textX, textY);
      text(ownerName, textX + 25, textY);
      Link link = (Link) userLinks.get(i);
      link.update(textX + 25, textY -15, 200, 15, "http://www.flickr.com/photos/"+owner);
      textY += 15;

      if( selectedPhoto != null && selectedPhoto.getOwnerName().equals( ownerName )) { fill(1); }
    }
    
    //Tags
    textY += 20;
    textFont(font, 20);
    text("Top 10 Tags", textX, textY);
    //Top tags
    textY += 20;
    textFont(font, 12);
    for(int i = 0; i < topTags.size() && i < 10; i++){
      if( selectedPhoto != null && tagsForSelectedPhoto != null && tagsForSelectedPhoto.contains((String)topTags.get(i)) ) { fill(1.0,0,0); }
      
      text((i+1) + ".", textX, textY);
      text((String)topTags.get(i), textX + 25, textY);
      textY += 15;

      if( selectedPhoto != null && tagsForSelectedPhoto != null && tagsForSelectedPhoto.contains((String)topTags.get(i)) ) { fill(1); }
    }
    
    //Date
    textFont(font, 25);
    text(dateView.currentDayString(), width - 140, height - 100);
    text(dateView.currentMonthString(), width - 155, height - 65);
    text(dateView.currentYearString(), width - 155, height - 25);
    leftButton.x = width - 230;
    leftButton.y = height - 125;
    leftButton.w = 75;
    leftButton.h = 100;
    rightButton.x = width - 75;
    rightButton.y = height - 125;
    rightButton.w = 75;
    rightButton.h = 100;
    triangle(width - 230, height - 73, width - 175, height - 125, width - 175, height - 20);
    triangle(width - 20, height - 73, width - 75, height - 125, width - 75, height - 20);
    
    //Filter CheckBoxes
    textFont(font, 20);
    text("Filter Tags" + "  (" + (rock_count+classic_count+trance_count+pop_count+jazz_count)+")", textX, height - 240);
    int checkBoxX = textX;
    int checkBoxY = height - 230;
    for(int i = 0; i < checkBoxes.size(); i++){
      CheckBox box = (CheckBox) checkBoxes.get(i);
      box.x = checkBoxX;
      box.y = checkBoxY;
      checkBoxY += 15;
      box.update();
      box.display();
    }
  }
}
