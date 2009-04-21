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

class FlickrData 
{
  String apiKey;
  String sharedSecret;
//  PhotosInterface photosInterface = new PhotosInterface();
  Flickr f;
  REST rest;
  RequestContext requestContext;
  Properties properties = null;
  
  public FlickrData() throws ParserConfigurationException, IOException, SAXException
  {
    f = new Flickr(
        "980124ce17646145142cb845bef6f495",
        "0e3d9f74e071939d",
        new REST()
    );
  }
  
  public PhotoList getPhotos(int page) throws IOException, SAXException, FlickrException, ParseException
  {
    SearchParameters params = new SearchParameters();
    params.setExtras(true);
    String[] tags = new String[1];
    tags[0] = "dance";
    params.setTags(tags);
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    params.setMinTakenDate(df.parse("2009-3-01"));
    params.setMaxTakenDate(df.parse("2009-3-02"));
    params.setHasGeo(true);
    return f.getPhotosInterface().search(params, 500, page);
  }
}
