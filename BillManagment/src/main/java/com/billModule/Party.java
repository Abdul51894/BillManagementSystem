package com.billModule;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.helper.Helper;
@WebServlet (urlPatterns = "/party")
public class Party extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html");
		PrintWriter out = resp.getWriter();
		
		int register_id =Integer.parseInt(req.getParameter("register_id"));
		String party_name = req.getParameter("party_name");
		String phone = req.getParameter("phone");
		String gst_number = req.getParameter("gst_number");
		
		try {
			
			Connection con = Helper.helper();
			
			PreparedStatement pst = con.prepareStatement("insert into party(register_id,party_name,phone,gst_number)values (?,?,?,?)");
			
			pst.setInt(1, register_id);
			pst.setString(2, party_name);
			pst.setString(3, phone);
			pst.setString(4, gst_number);
			
			int row = pst.executeUpdate();
			
			
			if(row > 0) {
				
				out.println("<script type='text/javascript'>");
				out.println("alert('Party Add Successfully!');");
				out.println("window.location.href='bill.jsp'");
				out.println("</script>");
				}
			else {
				out.println("<script>");
				out.println("alert('Party is Not Add Please Try Again!')");
				out.println("window.location.href='party.jsp'");
				out.println("</script>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
