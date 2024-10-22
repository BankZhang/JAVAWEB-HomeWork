package com.gzu.DAO;

import java.sql.*;

public class Scrollable_ResultSet {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String user = "root";
        String password = "15685256858zyh";

        //定义sql语句
        String sql = "SELECT * FROM teacher WHERE id > ?";

        try(Connection conn = DriverManager.getConnection(url, user, password)){

            //创建 PreparedStatement 时指定结果集类型为 TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY。
            try(PreparedStatement ps = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)){

                //设置参数
                ps.setInt(1,50);

                //执行查询
                try(ResultSet rs = ps.executeQuery()){
                    rs.absolute(-2);
                    System.out.println("id:" + rs.getInt("id") + " name:" + rs.getString("name") + " course:" + rs.getString("course") + " birthday:" + rs.getString("birthday") );
                    //Usage:
                    //rs.first();将结果集的移动到第一行
                    //rs.last();将结果集移动到最后一行
                    //rs.absolute(n); 将结果集中的光标移动到第n行, 若为负数-m, 则移动到倒数第m行
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}

//创建可滚动结果集的步骤：
//1. 在创建PreparedStatement时，指定结果集类型 ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY
//2. 使用ResultSet的方法来移动光标。