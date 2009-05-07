class FEGui
{
  ArrayList checkBoxes;
  
  
  FEGui()
  {
    checkBoxes = new ArrayList();
    for(int i = 0; i < tagOrder.length; i++){
      
    }
  }
  
  void step()
  {
  }
  
  void render()
  {
    stroke(1);
    int textX = width-240;
    //Lines section
    line(width-250,0,width-250,height);
    line(width-250,height-150,width,height-150);
    
    //Text sections
    //Title
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
    text("100", textX + 120, textY);
    textY += 15;
    text("Number of users:", textX, textY);
    text("100", textX + 120, textY);
    textY += 15;
    text("Number of tags:", textX, textY);
    text("100", textX + 120, textY);
    textY += 35;    
    
    //Users
    textFont(font, 20);
    text("Top 10 Users",textX, textY);
    //top users
    textY += 20;
    textFont(font, 12);
    for(int i = 1; i < 11; i++){
      text(i + ". User", textX, textY);
      textY += 15;
    }
    
    
    //Tags
    textY += 20;
    textFont(font, 20);
    text("Top 10 Tags", textX, textY);
    //Top tags
    textY += 20;
    textFont(font, 12);
    for(int i = 1; i < 11; i++){
      text(i + ". User", textX, textY);
      textY += 15;
    }
  }
}
