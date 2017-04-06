import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URLDecoder;

public class GUI {
    private JTextField idField;
    private JTextArea area;

    public static String getDirPath(){
        String path;
        String decodedPath = "";
        try{
            path = Main.class.getProtectionDomain().getCodeSource().getLocation().toURI().getPath();
            decodedPath = URLDecoder.decode(path, "UTF-8");
        }catch (Exception e){
            e.printStackTrace();
        }
        String dirPath = decodedPath.substring(1,decodedPath.lastIndexOf("/"));
        return dirPath;
    }

    public void prepare(){

        JLabel label = new JLabel("Enter course id");
        idField = new JTextField(7);
        JButton confirmBtn = new JButton("Make Report");
        confirmBtn.setActionCommand("makeReport");
        confirmBtn.addActionListener(new ButtonClickListener());

        JPanel panel = new JPanel();
        panel.add(label);
        panel.add(idField);
        panel.add(confirmBtn);

        area = new JTextArea();
        panel.add(area);

        JFrame frame = new JFrame("course_report");
        JFrame.setDefaultLookAndFeelDecorated(true);
        frame.add(panel);
        frame.pack();
        frame.setVisible(true);
        frame.setSize(300,80);
        frame.setResizable(false);
    }


    class ButtonClickListener implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String command = e.getActionCommand();
            if (command.equals("makeReport")) {
                String courseId = idField.getText();
                if (courseId != null) {
                    try {
                        ReportMaker.createReport(Integer.valueOf(courseId));
                    } catch (Exception e1) {
                        idField.setText(e1.toString());
                    }
                    idField.setText("Success");
                }
            }
        }
    }


}
