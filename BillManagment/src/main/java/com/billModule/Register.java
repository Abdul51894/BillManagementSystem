package com.billModule;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.helper.Helper;

public class Register extends HttpServlet{
	
	
	String q = "INSERT INTO register(name, email, phone_no, gender, username, password, confirm_password) VALUES (?, ?, ?, ?, ?, ?, ?)";
	String checkQuery = "SELECT * FROM register WHERE username = ?";
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String name = req.getParameter("name");
		String email= req.getParameter("email");
		String phone_no = req.getParameter("phone");
		String gender = req.getParameter("gender");
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		String confirmPassword = req.getParameter("confirmPassword");
		
		PrintWriter out = resp.getWriter();
		resp.setContentType("text/html");

		
		if(!password.equals(confirmPassword)) {
			
			out.println("<h1>Your Password is not Matched Please try again</h1>");
			
			RequestDispatcher rd = req.getRequestDispatcher("Register.jsp");
			rd.include(req, resp);
				
			return;
		}
		
		//jdbc part
		
		try {
		
			Connection con = Helper.helper();
			
			PreparedStatement chekpst = con.prepareStatement(checkQuery);
			chekpst.setString(1, username);
			ResultSet rs = chekpst.executeQuery();
			if(rs.next()) {
				 out.println("<h3 style='color:red;'>Username already exists. Please try a different one.</h3>");
				 RequestDispatcher rd = req.getRequestDispatcher("Register.jsp");
					rd.include(req, resp);
					
					return;
					
			}
			else {
				PreparedStatement pdst = con.prepareStatement(q);
				pdst.setString(1, name);
				pdst.setString(2, email);
				pdst.setString(3, phone_no);
	            pdst.setString(4, gender);
	            pdst.setString(5, username);
	            pdst.setString(6, password);
	            pdst.setString(7, confirmPassword);
	            
	            int rows = pdst.executeUpdate();
	            
	            if (rows > 0) {
	            	
	                out.println("<script type='text/javascript'>");
	                out.println("alert('Registration successful!');");
	                out.println("window.location.href='login.jsp';");  // Change this if needed
	                out.println("</script>");
	            } else {
	                out.println("<script type='text/javascript'>");
	                out.println("alert('Registration failed. Please try again.');");
	                out.println("window.location.href='Register.jsp';");
	                out.println("</script>");
	            }
			}
			

           
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
}
