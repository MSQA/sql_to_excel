import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

 public class DBUtils {
     static Connection conn = null;

     public static Connection getConnection() throws Exception{
         if (conn != null) {
             return conn;
         }
        try {
            //load property file
            File dbProperties = new File(GUI.getDirPath() + "\\db.properties");
            System.out.println(dbProperties.length());
            FileInputStream f = new FileInputStream(dbProperties);
            Properties pros = new Properties();
            pros.load(f);
            //assign db properties
            String url = pros.getProperty("url");
            String user = pros.getProperty("user");
            String password = pros.getProperty("password");
            //create connection
            conn = DriverManager.getConnection(url,user,password);
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
        return conn;
    }
}
