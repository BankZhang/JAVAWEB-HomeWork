package com.gzu.DAO;

import java.sql.*;

public class Updatable_ResultSet {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String user = "root";
        String password = "15685256858zyh";

        //定义sql语句
        String sql = "SELECT * FROM teacher WHERE id > ?";

        try(Connection conn = DriverManager.getConnection(url, user, password)){
            try(PreparedStatement ps = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE)){
                // 设置参数
                ps.setInt(1,50);

                // 执行查询
                try (ResultSet rs = ps.executeQuery()){
                    // 移动到倒数第二行
                    rs.absolute(-2);
                    // 修改倒数第二行的name
                    rs.updateString("name","张三");
                    // 提交修改
                    rs.updateRow();
                    System.out.println("修改成功!");
                }catch (SQLException e){
                    System.out.println("修改失败!");
                    e.printStackTrace();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
