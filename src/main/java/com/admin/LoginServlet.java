package com.admin;

import com.bean.DBUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/LoginServlet")
public class LoginServlet extends HttpServlet {



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            // Admin users are stored in the SRS database (credentials from environment variables).
            con = DBUtil.getConnection("SRS");

            ps = con.prepareStatement(
                    "SELECT role, department, branch FROM users WHERE username=? AND password=?");

            ps.setString(1, uname);
            ps.setString(2, pass);

            rs = ps.executeQuery();

            if (rs.next()) {

                String role = rs.getString("role");
                String department = rs.getString("department");
                String branch = rs.getString("branch");

                // New session id after login (prevents session fixation).
                HttpSession old = request.getSession(false);
                if (old != null) {
                    old.invalidate();
                }
                HttpSession session = request.getSession(true);

                session.setAttribute("username", uname);
                session.setAttribute("role", role);
                session.setAttribute("department", department);
                session.setAttribute("branch", branch);

                // Redirect based on role/department

                if ("Global".equalsIgnoreCase(role)) {

                    response.sendRedirect("pages");

                } else if ("incharge".equalsIgnoreCase(role)
                        || "Finance".equalsIgnoreCase(department)) {

                    response.sendRedirect("Home");

                } else if ("HOSTEL".equalsIgnoreCase(department)) {

                    response.sendRedirect("TrackRequestServlet");

                } else {

                    response.sendRedirect("Home");
                }

            } else {

                request.setAttribute("error", "Invalid Username or Password!");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);

            }

        } catch (Exception e) {

            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("error", "Login is not available right now. Please try again later.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } finally {

            try {
                if (rs != null)
                    rs.close();
            } catch (Exception e) {
            }

            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {
            }

            try {
                if (con != null)
                    con.close();
            } catch (Exception e) {
            }

        }
    }
}