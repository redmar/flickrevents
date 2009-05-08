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
