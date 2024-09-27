package com.gzu;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

// 默认对所有的URL路径进行过滤
@WebFilter("/*")
public class LoginFilterServlet implements Filter {
    // 设置一个排除列表，此列表中的路径不需要就能访问
    private final List<String> excludePaths = Arrays.asList("/login", "/register", "/public", "index.jsp");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化过滤器
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        // 获取请求的URI
        String reqURI = req.getRequestURI();

        // 检查请求的URI是否在排除列表中
        if(isExcluded(reqURI)){

            // 经检查发现当前访问路径位于排除列表中，放行通过
            System.out.println("当前访问路径：" + reqURI + "位于排除列表中,允许请求通过！");
            filterChain.doFilter(req,resp);

        }
        else {

            // 经检查发现当前访问路径 不位于 排除列表中，进而检查用户是否已登录
            HttpSession session = req.getSession();

            if(session != null) {

                String userName = (String)session.getAttribute("userName");
                String password = (String)session.getAttribute("password");

                if (!Objects.equals(userName, "") && !Objects.equals(password, "")) {

                    // 经过判断session中的 用户名 与 密码 均不为空，则认定用户已经登录，继续执行请求
                    System.out.println("用户已登录,允许请求通过！");
                    filterChain.doFilter(req, resp);

                } else {

                    // 经过检查发现 路径不在排除列表 并且 用户未登录，则重定位到登录页面
                    System.out.println("当前访问路径："+ reqURI +"不位于排除列表中并且用户未登录,请求不被通过！");
                    System.out.println("将跳转到登录页面！");
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");

                }
            }
        }
    }

    @Override
    public void destroy() {
        // 销毁过滤器
    }

    // 定义一个检查当前请求路径是否在排除列表中的方法
    private boolean isExcluded(String reqURI){
        //遍历整个list 如果发现当前请求路径在排除列表中，则返回真，放行通过
        for(String path : excludePaths){
            if(reqURI.endsWith(path)){
                return true;
            }
        }
        return false;
    }
}
