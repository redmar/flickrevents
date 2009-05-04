import java.util.*;
//ArrayList with days
class FEDayCollection extends ArrayList
{
  public FEDayCollection() { }
  
  public FEDay getDay(Date date)
  {
    for(int i = 0; i < size(); i++){
      FEDay day = (FEDay) get(i);
      if (day.getDate() == date){
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
      result += tag.size();
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
}

//ArrayList with photos
class FETag extends ArrayList
{
  String tag;
  
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
  
  public String getTags(){
    return tags;
  }
}
