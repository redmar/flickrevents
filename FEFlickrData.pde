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
  
  
