import java.io.*;

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
      if (dirs[i] != "." && dirs[i] != ".." && !dirs[i].contains("rock"))
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
  
  FEDay loadDay(Date date)
  {
    FEDay day = new FEDay(date);
    String folder = cacheDir + dateFormat.format(date) + "/";
    File dayFolder = new File(folder);
    String[] dirs = dayFolder.list();
    for(int i = 0; i < dirs.length; i++)
    {
      if (dirs[i] != "." && dirs[i] != ".." && !dirs[i].contains("rock"))
      {
        day.add(loadTag(folder, dirs[i]));
      }
    }
    return day;
  }
  
  FETag loadTag(String dir, String tagName)
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
  
  FEFlickrPhoto loadPhoto(String line)
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
