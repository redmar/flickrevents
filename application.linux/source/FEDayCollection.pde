import java.util.*;
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
  
  HashMap getSortedTags()
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
  
  HashMap getSortedUsers()
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
  
  void setColor(float a)
  {
      fill(getTagColor(tag),a);
      stroke(getTagColor(tag));
  }
  
  HashMap getSortedTags()
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
  
  HashMap getSortedUsers()
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
