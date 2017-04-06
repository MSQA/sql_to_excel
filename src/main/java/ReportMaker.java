import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by zhangphil on 2017/3/16.
 */
public class ReportMaker {
    public static void createReport(int courseId) throws Exception {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet0 = workbook.createSheet("Summary");
        XSSFSheet sheet1 = workbook.createSheet("Event Details");
        XSSFSheet sheet2 = workbook.createSheet("Work Details");
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("courseId", courseId);
        writeBasicInfo(sheet0, paramMap);
        writeBasicInfo(sheet1, paramMap);
        writeBasicInfo(sheet2, paramMap);
        createSheet(sheet0, "summary", paramMap);
        createSheet(sheet1, "eventDetail", paramMap);
        createSheet(sheet2, "workoutDetail", paramMap);
//        String path = Main.class.getProtectionDomain().getCodeSource().getLocation().toURI().getPath();
//        String decodedPath = URLDecoder.decode(path, "UTF-8");
//        String dirPath = decodedPath.substring(1,decodedPath.lastIndexOf("/"));
        FileOutputStream fos = new FileOutputStream(GUI.getDirPath() + "\\course_report_" + courseId + ".xlsx");
        workbook.write(fos);
    }

    private static void writeBasicInfo(XSSFSheet sheet, Map paramMap) throws Exception {
        String basicInfoSql = "basicInfo";
        List resultList = DataMaker.getData(basicInfoSql, paramMap);
        Map singleMap = (Map) resultList.get(0);

        Row basicRow0 = sheet.createRow(0);
        Cell cell00 = basicRow0.createCell(0);
        cell00.setCellValue("Camp");
        Cell cell01 = basicRow0.createCell(1);
        cell01.setCellValue((String) singleMap.get("name"));
        Cell cell02 = basicRow0.createCell(2);
        cell02.setCellValue("https://sports.garmin.cn/web/camp/" + String.valueOf(singleMap.get("camp_id")));

        Row basicRow1 = sheet.createRow(1);
        Cell cell10 = basicRow1.createCell(0);
        cell10.setCellValue("Course");
        Cell cell11 = basicRow1.createCell(1);
        cell11.setCellValue((String) singleMap.get("title"));
        Cell cell12 = basicRow1.createCell(2);
        cell12.setCellValue("https://sports.garmin.cn/web/camp/" + String.valueOf(singleMap.get("camp_id")) + "/training/" + String.valueOf(paramMap.get("courseId")));

        Row basicRow2 = sheet.createRow(2);
        Cell cell20 = basicRow2.createCell(0);
        cell20.setCellValue("Course Progress");
        Cell cell21 = basicRow2.createCell(1);
        cell21.setCellValue(String.valueOf(singleMap.get("finished")) + "/" + String.valueOf(singleMap.get("total")));

    }

    static void createSheet(XSSFSheet sheet, String sql, Map paramMap) throws Exception {

        List<Map<String, Object>> resultList = DataMaker.getData(sql, paramMap);
        if(resultList.size() == 0){
            return;
        }
        List<String> columnList = new ArrayList<String>(resultList.get(0).keySet());
        int hasRowNum = sheet.getLastRowNum() + 1;
        //标题行
        Row rowTitle = sheet.createRow(hasRowNum + 1);
        for (int i = 0; i < columnList.size(); i++) {
            Cell cell = rowTitle.createCell(i);
            cell.setCellValue(columnList.get(i));
        }

        //数据
        for (int i = 0; i < resultList.size(); i++) {
            Map<String, Object> single = resultList.get(i);
            Row rowData = sheet.createRow(i + hasRowNum + 2);
            int j = 0;
            for (Map.Entry<String, Object> entry : single.entrySet()) {
                Cell cell = rowData.createCell(j++);
                cell.setCellValue(String.valueOf(entry.getValue()));
            }
        }
    }
}
