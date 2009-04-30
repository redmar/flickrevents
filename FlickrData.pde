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

class FlickrData implements Runnable
{
  String apiKey;
  String sharedSecret;
//  PhotosInterface photosInterface = new PhotosInterface();
  Flickr f;
  REST rest;
  RequestContext requestContext;
  Properties properties = null;
  
  Thread runner;
  String tag;
  int page;
  PhotoList photos;
  FEWorldMap fe_worldmap;
  
  public FlickrData(){}
  
  public FlickrData(String tag, int page, FEWorldMap worldmap) throws ParserConfigurationException, IOException, SAXException
  {
    f = new Flickr(
        "980124ce17646145142cb845bef6f495",
        "0e3d9f74e071939d",
        new REST()
    );
    
    this.tag = tag;
    this.page = page;
    this.fe_worldmap = worldmap;
  }
  
  public FlickrData(String threadName){
    runner = new Thread(threadName);
    runner.start();
  }
  
  public void run()
  {
    try {
      System.out.println("loading photos");
      PhotoList photos = getPhotos(this.page);
      
      for (int i = 0; i < photos.size(); i++){
        fe_worldmap.addPhotoSync( (Photo) photos.get(i));
      }
      runner.stop();
      System.out.println("photos loaded!");
    } catch (Exception e) {}
  }
  
  public PhotoList getPhotos(int page) throws IOException, SAXException, FlickrException, ParseException
  {
    System.out.println(page);
    SearchParameters params = new SearchParameters();
    params.setExtras(true);
    String[] tags = new String[1];
    tags[0] = this.tag;
    params.setTags(tags);
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    params.setMinTakenDate(df.parse("2009-3-01"));
    params.setMaxTakenDate(df.parse("2009-3-02"));
    params.setHasGeo(true);
    return f.getPhotosInterface().search(params, 500, page);
  }
}
