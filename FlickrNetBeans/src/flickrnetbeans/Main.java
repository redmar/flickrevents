/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package flickrnetbeans;

import processing.core.*;

public class Main extends PApplet {

   public Main() {
   }

   public static void main(String[] args) {
       // must match the name of your class ie "letsp5.Main" = packageName.className
       PApplet.main( new String[]{"flickrnetbeans.Main"} );
   }

   public void setup () {
       size( 200, 200 );
       background(100);
   }

   public void draw () {

   }

   public void mouseDragged() {
       line(mouseX, mouseY, pmouseX, pmouseY);
   }

}
