import gifAnimation.*;

class FEPhotoRedmar {
  PImage original_img;
  Gif progress_img;  
  
  float xpos = 20.0;
  float ypos = 20.0;
  float drag = 30.0;
  boolean loading = true;

  String farm_id, server_id, id, secret;
  String flickr_url = "";
  
  FEPhotoRedmar(PApplet parent, Photo p) {
    // extract photo info
    progress_img = new Gif(parent, "loader.gif"); //loadImage("loader.gif");  // Load the image into the program  
    progress_img.play();    
//    setFlickrURL(createFlickrURL("4", "3198", "3055949628", "4323e215d3"));
//    setFlickrURL("http://farm2.static.flickr.com/1023/529567127_cf62646bd3.jpg?v=0");
  }
  
  FEPhotoRedmar(PApplet parent) {
    progress_img = new Gif(parent, "loader.gif"); //loadImage("loader.gif");  // Load the image into the program  
    progress_img.play();    
  }

  // requestImage(filename)
  //
  // LOAD SHIT ASYNC!
  //
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
  //	or
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
  //	or
  //  http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
  // 
  // http://farm4.static.flickr.com/3198/3055949628_4323e215d3.jpg?v=0
  
  void setFlickrURL(String url) { 
    this.flickr_url = url;
    this.loading = true;
    this.original_img = requestImage(this.flickr_url);
  }

  void setFlickrURL(String farm_id, String server_id, String id, String secret) {
    setFlickrURL(createFlickrURL(farm_id, server_id, id, secret));    
  } 
  
  String createFlickrURL(String farm_id, String server_id, String id, String secret) {
    return "http://farm" + farm_id + ".static.flickr.com/" + server_id + "/" + id + "_" + secret + ".jpg";
  }

  FEPhotoRedmar step() {
    if( loading && original_img != null) {
      switch(original_img.width) {
        case 0: 
            // still loading do nothing
            break;
        case -1: // loading failure
        default: 
            loading = false; // loaded successfully
      }
    }

    float difx = (mouseX)-(progress_img.width/2) - xpos;
    if( abs(difx) > 1.0 ) {
      xpos = xpos + difx/drag;
//      xpos = constrain(xpos, 0, (mouseX)-(progress_img.width/2));
    }  
  
    float dify = mouseY - progress_img.height - ypos;
    if( abs(dify) > 1.0 ) {
      ypos = ypos + dify/drag;
//      ypos = constrain(ypos, 0, mouseY-progress_img.height);
    }  
    return this;
  }

  void render() {
    // Displays the image at point (100, 0) at half of its size
    if( loading ) {
       image(progress_img, xpos, ypos);  // when an error occurs just render nothing
    } else {
      if( original_img != null && original_img.width != -1) {
        image(original_img, xpos, ypos);
      }
    }
  }
}
