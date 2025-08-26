package com.billModule;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.helper.Helper;

public class Login extends HttpServlet{
	
	Connection con = null;
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		
		resp.setContentType("text/html");
		PrintWriter out = resp.getWriter();
		
		try {
			con = Helper.helper();
			PreparedStatement pts = con.prepareStatement("SELECT * FROM register WHERE username = ? AND password = ?");
			pts.setString(1, username);
			pts.setString(2, password); 
			
			ResultSet rs = pts.executeQuery();
			
			if(rs.next()) {
				
				int id = rs.getInt("id");
				
				HttpSession session = req.getSession();
				session.setAttribute("username", username);
				session.setAttribute("id", id);
				
				out.println("<script type='text/javascript'>");
	            out.println("alert('Login successful!');");
	            out.println("window.location.href='home.jsp';");  
	            out.println("</script>");
				out.println("<h1>you are login successfully</h1>");
				
			}else {
				out.println("<h1>your Username or Passowrd is invalid</h1>");
				RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
				rd.include(req, resp);
			}
			
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
	}
}
