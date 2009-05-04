/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javaapplication2;
import java.util.regex.*;
/**
 *
 * @author benoist
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Pattern p = Pattern.compile("^<photo id=\"(.*)\" owner=\"(.*)\" owner_name=\"(.*)\" secret=\"(.*)\" server=\"(.*)\" farm=\"(.*)\" latitude=\"(.*)\" longitude=\"(.*)\" tags=\"(.*)\"/>$");
        Matcher m = p.matcher("<photo id=\"3473672371\" owner=\"14147007@N07\" owner_name=\"Dave Madden\" secret=\"1acca5c3bb\" server=\"3632\" farm=\"4\" latitude=\"52.41506\" longitude=\"-1.77785\" tags=\"music,gold,glasses,belt,watch,jazz,trousers,byron,westmidlands,saxophone,solihull,streetmusician,playingmusic,mallsquare,\"/>");
        //Pattern p = Pattern.compile("^<photo id=\"(.*)\"/>$");
        //Matcher m = p.matcher("<photo id=\"213\"/>");
        m.matches();
        for(int i = 1; i <= m.groupCount(); i++){
            System.out.println(m.group(i));
        }
    }

}
