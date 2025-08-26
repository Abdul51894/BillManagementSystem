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

public class Payment extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html");
		PrintWriter out = resp.getWriter();

		try {
			int register_id = Integer.parseInt(req.getParameter("register_id"));
			int bill_id = Integer.parseInt(req.getParameter("bill_id"));
			double amount_paid = Double.parseDouble(req.getParameter("amount_paid"));
			Date payment_date = Date.valueOf(req.getParameter("payment_date"));
			String payment_mode = req.getParameter("payment_mode");

			Connection con = Helper.helper();

			// First, ensure bill exists
			PreparedStatement billCheck = con.prepareStatement("SELECT bill_id FROM bill WHERE bill_id = ?");
			billCheck.setInt(1, bill_id);
			if (!billCheck.executeQuery().next()) {
				out.println("<script>alert('Invalid bill selected!'); window.location='payment.jsp';</script>");
				return;
			}

			PreparedStatement pst = con.prepareStatement("INSERT INTO payment (register_id, bill_id, amount_paid, payment_date, payment_mode, created_at) VALUES (?, ?, ?, ?, ?, NOW())");
			pst.setInt(1, register_id);
			pst.setInt(2, bill_id);
			pst.setDouble(3, amount_paid);
			pst.setDate(4, payment_date);
			pst.setString(5, payment_mode);

			int rows = pst.executeUpdate();

			if (rows > 0) {
				out.println("<script>alert('Payment added successfully!'); window.location='desboard.jsp';</script>");
			} else {
				out.println("<script>alert('Payment failed!'); window.location='payment.jsp';</script>");
			}

			con.close();
			pst.close();
			billCheck.close();
		} catch (Exception e) {
			e.printStackTrace();
			out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='payment.jsp';</script>");
		}
	}
}
