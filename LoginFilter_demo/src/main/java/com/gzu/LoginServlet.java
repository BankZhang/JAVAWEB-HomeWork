package com.gzu;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("LoginServlet已执行...");
        HttpSession session = req.getSession();
        String userName = req.getParameter("userName");
        String password = req.getParameter("password");
        session.setAttribute("userName",userName);
        session.setAttribute("password",password);
        resp.sendRedirect(req.getContextPath() + "/LoginSuccess.html");
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }
}
