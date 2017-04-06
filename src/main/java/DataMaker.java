import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.*;


public class DataMaker {

    public static List<Map<String,Object>> getData(String sqlName, Map<String, Object> param) throws Exception {
        String sql = SqlUtils.getSql(sqlName);
        Connection conn;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> resultList = new LinkedList<Map<String, Object>>();
        try {
            conn = DBUtils.getConnection();
            pstmt = conn.prepareStatement(sql);
            for (Map.Entry<String, Object> entry : param.entrySet()) {
                int i = 0;
                pstmt.setObject(++i, entry.getValue());
            }
            rs = pstmt.executeQuery();
            ResultSetMetaData rsm = rs.getMetaData();
            while (rs.next()) {
                Map<String, Object> singleRsMap = new LinkedHashMap();
                for (int i = 0; i < rsm.getColumnCount(); i++) {
                    String name = rsm.getColumnName(i + 1);
                    Object value = rs.getObject(i + 1);
                    singleRsMap.put(name, value);
                }
                resultList.add(singleRsMap);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return resultList;
    }
}
