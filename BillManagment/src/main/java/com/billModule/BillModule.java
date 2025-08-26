package com.billModule;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.helper.Helper;

public class BillModule extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        try {
            int register_id = Integer.parseInt(req.getParameter("register_id"));
            int party_id = Integer.parseInt(req.getParameter("party_id"));
            String bill_number = req.getParameter("bill_number");
            LocalDate bill_date = LocalDate.parse(req.getParameter("bill_date"));

           
            String dueOffsetStr = req.getParameter("due_offset");
            LocalDate due_date = null;

            if (dueOffsetStr != null && !dueOffsetStr.isEmpty()) {
                int offset = Integer.parseInt(dueOffsetStr);
                if (offset == 30) {
                    due_date = bill_date.plusMonths(1);
                } else if (offset == 60) {
                    due_date = bill_date.plusMonths(2);
                } else {
                    due_date = bill_date.plusDays(offset);
                }
            }

            double total_amount = Double.parseDouble(req.getParameter("total_amount"));
            String status = req.getParameter("status");
            String remarks = req.getParameter("remarks");

            Connection con = Helper.helper();
            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO bill (register_id, party_id, bill_number, bill_date, due_date, total_amount, status, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            );

            pst.setInt(1, register_id);
            pst.setInt(2, party_id);
            pst.setString(3, bill_number);
            pst.setDate(4, Date.valueOf(bill_date));

            if (due_date != null) {
                pst.setDate(5, Date.valueOf(due_date));
            } else {
                pst.setNull(5, java.sql.Types.DATE);
            }

            pst.setDouble(6, total_amount);
            pst.setString(7, status);
            pst.setString(8, remarks);

            int rows = pst.executeUpdate();
            if (rows > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Bill Added Successfully!');");
                out.println("window.location.href='viewBill.jsp?bill_number=" + bill_number + "';");
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Failed to add bill. Please try again.');");
                out.println("window.location.href='bill.jsp';");
                out.println("</script>");
            }

            pst.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script type='text/javascript'>");
            out.println("alert('An error occurred. Please check your input.');");
            out.println("window.location.href='bill.jsp';");
            out.println("</script>");
        }
    }
}
