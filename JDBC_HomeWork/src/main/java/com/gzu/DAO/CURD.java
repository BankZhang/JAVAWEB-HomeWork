package com.gzu.DAO;

import org.junit.Test;

import java.sql.*;


//本次的CURD 操作为: 1.添加十条数据
                // 2.删除id为1的老师信息
                // 3.查询id为2的老师信息
                // 4.更新id为3的老师的授课
public class CURD {
    String url = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    String user = "root";
    String password = "15685256858zyh";


    @Test//插入
    public void Create() {
        //定义sql语句
        String sql =  "INSERT INTO teacher (`id`, `name`, `course`, `birthday`) VALUES" +
                            " (1, '张三', '数学', '1985-02-15')," +
                            " (2, '李四', '英语', '1980-05-22')," +
                            " (3, '王五', '物理', '1978-09-01')," +
                            " (4, '赵六', '化学', '1990-12-30')," +
                            " (5, '孙七', '生物', '1982-07-05')," +
                            " (6, '周八', '历史', '1988-03-21')," +
                            " (7, '吴九', '地理', '1975-11-12')," +
                            " (8, '郑十', '计算机科学', '1992-06-20')," +
                            " (9, '钱十一', '体育', '1984-08-08')," +
                            " (10, '孙十二', '音乐', '1986-03-03');";


        try(Connection conn = DriverManager.getConnection(url,user,password)){
            // 将自动提交关闭
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.executeUpdate();//执行插入
                conn.commit();//提交修改
                conn.setAutoCommit(true);//开启自动提交
                System.out.println("添加成功！");
            }
        } catch (SQLException e) {
            System.out.println("添加失败！");
            throw new RuntimeException(e);
        }
    }



    @Test//查询id为2的教师信息
    public void Retrieve(){
        //定义sql语句
        String sql = "SELECT * FROM teacher WHERE id = ?";

        try(Connection conn = DriverManager.getConnection(url, user, password)){
            // 将自动提交关闭
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(sql)){

                ps.setInt(1,2);// 设置参数
                conn.commit();//  提交修改
                conn.setAutoCommit(true);// 重新开启自动提交

                try(ResultSet rs = ps.executeQuery()){
                    if(rs.next()){
                        System.out.println("id:" + rs.getObject(1) + " name:" + rs.getObject(2) + " course:" + rs.getObject(3) + " birthday:" + rs.getObject(4));
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("查询失败！");
            throw new RuntimeException(e);
        }
    }



    @Test//修改id为3的教师的授课课程为软件工程
    public void Update(){
        //定义sql语句
        String sql = "UPDATE teacher SET course = ? WHERE id = ?";

        try(Connection conn =  DriverManager.getConnection(url, user, password)){
            // 关闭自动提交
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(sql)){
                //设置参数
                ps.setInt(2,3);
                ps.setString(1,"软件工程");
                ps.executeUpdate();

                conn.commit();// 提交修改
                conn.setAutoCommit(true);// 重新开启自动提交
                System.out.println("修改成功！");
            }
        } catch (SQLException e) {
            System.out.println("修改失败！");
            throw new RuntimeException(e);
        }
    }



    @Test//删除
    public void Delete(){
        //定义sql语句
        String sql = "DELETE FROM teacher WHERE id = ?";
        try(Connection conn = DriverManager.getConnection(url, user, password)){
            // 关闭自动提交
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(sql)){
                // 设置参数
                ps.setInt(1,1);
                // 执行删除
                ps.executeUpdate();
                // 提交修改
                conn.commit();
                // 重新开启自动提交
                conn.setAutoCommit(true);
                System.out.println("删除成功！");
            }
        } catch (SQLException e) {
            System.out.println("删除失败！");
            throw new RuntimeException(e);
        }

    }
}


//JDBC基本操作

//建立数据库连接
//建立数据库连接是JDBC操作的第一步。
//步骤：
//1. 加载JDBC驱动（Java 6及以上版本通常会自动加载）
//2. 提供数据库URL、用户名和密码
//3. 使用DriverManager.getConnection()方法获取连接

//创建PrepareStatement对象
//一旦建立了连接，下一步就是创建一个Statement对象，用于执行SQL语句。
//步骤：
//1. 使用Connection对象的createStatement()方法
//2. 或者使用prepareStatement()方法创建PreparedStatement对象（推荐）

//执行SQL查询
//使用Statement或PreparedStatement对象执行SQL查询。
//步骤：
//1. 对于Statement，使用executeQuery()方法执行SELECT语句
//2. 对于PreparedStatement，先设置参数，然后执行查询

//处理查询结果
//执行查询后，需要处理返回的ResultSet对象来获取数据。
//步骤：
//1. 使用while循环和next()方法遍历结果集
//2. 使用getXXX()方法获取每列的数据

//关闭数据库连接
//正确关闭数据库连接和相关资源是非常重要的。
//步骤：
//1. 关闭ResultSet（如果有）
//2. 关闭Statement
//3. 关闭Connection

//注意:try-with-resources 是Java 7引入的一个语法糖,用于自动管理资源的关闭