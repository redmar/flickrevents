import java.io.*;

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
