package com.gzu;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.http.HttpServletRequest;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Listener implements ServletRequestListener {

    @Override
    public void requestInitialized(ServletRequestEvent sre) {

        HttpServletRequest req = (HttpServletRequest) sre.getServletRequest();

        //  获得请求开始的时间，并将时间转化为 年-月-日 时-分-秒 的格式
        long startTimeSE = System.currentTimeMillis();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd :hh:mm:ss");
        String startTime = dateFormat.format(startTimeSE);

        //  获得 请求时间 客户端 IP 地址 请求方法 请求 URI 查询字符串 User-Agent
        String method = req.getMethod();
        String IP = req.getRemoteAddr();
        String URI = req.getRequestURI();
        String QueryString = req.getQueryString();
        String userAgent = req.getHeader("User-Agent");

        //  格式化字符串
        String logEntry = String.format("\n|  Request Start Time: %s\n" +
                                        "|  Client IP: %s\n" +
                                        "|  Method: %s   \n" +
                                        "|  URI: %s       \n" +
                                        "|  Query String: %s\n" +
                                        "|  User-Agent: %s",
                startTime, IP, method, URI, QueryString, userAgent);



        System.out.println(logEntry);

        //将开始时间的long形式存入
        req.setAttribute("startTime", startTimeSE);
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {

        HttpServletRequest req = (HttpServletRequest) sre.getServletRequest();

        //  获得之前存入的开始时间
        Long startTimeSE = (Long) req.getAttribute("startTime");

        if (startTimeSE != null) {
            //  获得请求截止的时间并格式化为 年-月-日 时-分-秒 的格式
            long endTimeSE = System.currentTimeMillis();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd :hh:mm:ss");
            String endTime = dateFormat.format(endTimeSE);
            long processingTime = endTimeSE - startTimeSE;

            String logEntry = String.format("|  Request End Time: %s\n" +
                                            "|  Processing Time: %d ms\n", endTime, processingTime);

            System.out.println(logEntry); // Replace with your logging framework
        }
    }
}
