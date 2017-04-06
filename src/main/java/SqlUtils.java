import java.io.*;

/**
 * Created by zhangphil on 2017/3/16.
 */
public class SqlUtils {

    public static String getSql(String sqlName) throws Exception {

        File f = new File(GUI.getDirPath() + "\\resources\\" + sqlName + ".sql");
        FileInputStream fip = new FileInputStream(f);
        InputStreamReader reader = new InputStreamReader(fip, "UTF-8");
        StringBuffer sb = new StringBuffer();
        while (reader.ready()) {
            sb.append((char) reader.read());
        }
        reader.close();
        fip.close();
        return sb.toString();
    }
}
