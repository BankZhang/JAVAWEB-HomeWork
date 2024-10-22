package com.gzu.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Batch_Insert {
    public static void main(String[] args){
        String url = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
        String user = "root";
        String password = "15685256858zyh";

        //定义sql语句
        String sql = "INSERT INTO teacher (`id`, `name`, `course`, `birthday`) VALUES (?, ?, ?, ?)";

        try(Connection conn = DriverManager.getConnection(url, user, password)){
            // 关闭自动提交
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(sql)){

                // 模拟插入500条数据
                for(int id = 0; id < 500; id++){
                    ps.setInt(1,id);
                    String name = "teacher" + id;
                    String course = "course" + id;
                    String birthday = "2002-12-27";

                    // 设置参数
                    ps.setString(2,name);
                    ps.setString(3,course);
                    ps.setString(4,birthday);

                    // 添加到批处理
                    ps.addBatch();
                    if(id % 100 == 0){ //每100条记录执行一次
                        System.out.println("已满100条记录，执行批量更新数据");
                        ps.executeBatch();// 执行批处理
                        ps.clearBatch();// 清空批处理
                    }
                }
                ps.executeBatch();// 执行批处理
                conn.commit();// 提交修改
                conn.setAutoCommit(true);// 重新开启自动提交
                System.out.println("已完成批量更新数据");
            }catch (SQLException e){
                //如果try块中出现异常则回滚
                conn.rollback();
                e.printStackTrace();
                System.out.println("批量更新数据失败，已回滚。");
            }
        } catch (SQLException e) {
            System.out.println("批量更新数据失败!");
            e.printStackTrace();
        }
    }
}

//基本步骤：
//1. 创建PreparedStatement对象。
//2. 设置参数并调用addBatch()添加到批处理。
//3. 重复步骤2直到添加了所有需要插入的数据。
//4. 调用executeBatch()执行批处理。