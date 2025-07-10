package com.billModule;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.helper.Helper;

public class Payment extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		resp.setContentType("text/html");
		PrintWriter out = resp.getWriter();
		
		int register_id = Integer.parseInt(req.getParameter("register_id"));
		int bill_id = Integer.parseInt(req.getParameter("bill_id"));
		double amount_paid = Double.parseDouble(req.getParameter("amount_paid"));
		Date payment_date = Date.valueOf(req.getParameter("payment_date"));
		String payment_mode = req.getParameter("payment_mode");
		
		
		try {
			
			Connection con = Helper.helper();
			
			PreparedStatement pst = con.prepareStatement("INSERT INTO payment (register_id, bill_id, amount_paid, payment_date, payment_mode, created_at) VALUES (?, ?, ?, ?, ?, NOW())");
			pst.setInt(1, register_id);
			pst.setInt(2, bill_id);
			pst.setDouble(3, amount_paid);
			pst.setDate(4, payment_date);
			pst.setString(5, payment_mode); 
			
			
			int rows = pst.executeUpdate();
			
			if(rows > 0) {
				 if (rows > 0) {
		                out.println("<script type='text/javascript'>");
		                out.println("alert('Payment added successfully!');");
		                out.println("window.location.href = 'desboard.jsp';");
		                out.println("</script>");
		            } else {
		                out.println("<script type='text/javascript'>");
		                out.println("alert('Payment not added! Try again.');");
		                out.println("window.location.href = 'payment.jsp';");
		                out.println("</script>");
		            }
				 
				con.close();
				pst.close();

			}
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}
}
