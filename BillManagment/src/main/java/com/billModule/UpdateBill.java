package com.billModule;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.helper.Helper;

@WebServlet("/updateBill")
public class UpdateBill extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // Get form data
        int billId = Integer.parseInt(req.getParameter("bill_id"));
        String partyName = req.getParameter("party_name"); // fixed
        String dueDate = req.getParameter("due_date");
        double totalAmount = Double.parseDouble(req.getParameter("total_amount"));
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        String paymentDate = req.getParameter("payment_date");
        String paymentMode = req.getParameter("payment_mode");

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = Helper.helper();

            // ✅ Get party_id from party name
            int partyId = 0;
            pst = con.prepareStatement("SELECT party_id FROM party WHERE party_name = ?");
            pst.setString(1, partyName);
            rs = pst.executeQuery();
            if (rs.next()) {
                partyId = rs.getInt("party_id");
            } else {
                throw new Exception("Party not found.");
            }
            rs.close();
            pst.close();

            // ✅ Update bill table
            pst = con.prepareStatement("UPDATE bill SET party_id = ?, due_date = ?, total_amount = ?, status = ?, remarks = ? WHERE bill_id = ?");
            pst.setInt(1, partyId);
            pst.setDate(2, Date.valueOf(dueDate));
            pst.setDouble(3, totalAmount);
            pst.setString(4, status);
            pst.setString(5, remarks);
            pst.setInt(6, billId);
            pst.executeUpdate();
            pst.close();

            // ✅ Get latest payment_id
            int latestPaymentId = 0;
            pst = con.prepareStatement("SELECT MAX(payment_id) FROM payment WHERE bill_id = ?");
            pst.setInt(1, billId);
            rs = pst.executeQuery();
            if (rs.next()) {
                latestPaymentId = rs.getInt(1);
            }
            rs.close();
            pst.close();

            // ✅ Update latest payment if found
            if (latestPaymentId > 0) {
                pst = con.prepareStatement("UPDATE payment SET payment_date = ?, payment_mode = ? WHERE payment_id = ?");
                pst.setDate(1, Date.valueOf(paymentDate));
                pst.setString(2, paymentMode);
                pst.setInt(3, latestPaymentId);
                pst.executeUpdate();
                pst.close();
            }

            // ✅ Success response
            out.println("<script type='text/javascript'>");
            out.println("alert('Bill and payment updated successfully!');");
            out.println("window.location='desboard.jsp';");
            out.println("</script>");

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script type='text/javascript'>");
            out.println("alert('Error: " + e.getMessage().replace("'", "\\'") + "');");
            out.println("window.location='desboard.jsp';");
            out.println("</script>");
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
