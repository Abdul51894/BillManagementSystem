<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.helper.Helper"%>
<%@ page errorPage="error.jsp"%>

<%
    Integer register_id = (Integer) session.getAttribute("id");
    if (register_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int newBillNumber = 100;
    try {
        Connection con = Helper.helper();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT MAX(CAST(bill_number AS UNSIGNED)) AS last_bill_number FROM bill");

        if (rs.next()) {
            int lastBill = rs.getInt("last_bill_number");
            // Check if NULL
            if (rs.wasNull()) {
                newBillNumber = 100;
            } else {
                newBillNumber = lastBill + 1;
            }
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        newBillNumber = 100;
    }


    java.time.LocalDate today = java.time.LocalDate.now();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate New Bill</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f2f2f2;
            padding: 40px;
        }
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: auto;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4 text-center">Generate New Bill</h2>

    <form action="bill" method="post">
        <input type="hidden" name="register_id" value="<%= register_id %>">

        <!-- Party Dropdown -->
        <div class="form-group">
            <label>Party</label>
            <select name="party_id" class="form-control" required>
                <option value="">-- Select Party --</option>
                <%
                    Connection con = null;
                    Statement st = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con =DriverManager.getConnection("jdbc:mysql://switchback.proxy.rlwy.net:34435/railway","root","kJvdDQopAWrgSJBjXcMaLDawpSFjnGFD");
                        st = con.createStatement();
                        rs = st.executeQuery("SELECT party_id, party_name FROM party");

                        while (rs.next()) {
                %>
                    <option value="<%= rs.getInt("party_id") %>"><%= rs.getString("party_name") %></option>
                <%
                        }
                    } catch(Exception e) {
                        out.print("<option disabled>Error loading parties</option>");
                    } finally {
                        if(rs != null) rs.close();
                        if(st != null) st.close();
                        if(con != null) con.close();
                    }
                %>
            </select>
        </div>

        <!-- Bill Number -->
        <div class="form-group">
            <label>Bill Number</label>
            <input type="text" name="bill_number" class="form-control" value="<%= newBillNumber %>" readonly>
        </div>

        <!-- Bill Date -->
        <div class="form-group">
            <label>Bill Date</label>
            <input type="date" name="bill_date" class="form-control" value="<%= today %>" required>
        </div>

        <!-- Due Date Offset -->
        <div class="form-group">
            <label>Due Date Offset</label>
            <select name="due_offset" class="form-control" required>
                <option value="">-- Select Offset --</option>
                <option value="10">10 Days</option>
                <option value="20">20 Days</option>
                <option value="30">1 Month</option>
                <option value="60">2 Months</option>
            </select>
        </div>

        <!-- Hidden Due Date Field -->
        <input type="hidden" name="due_date" value="">

        <!-- Total Amount -->
        <div class="form-group">
            <label>Total Amount</label>
            <input type="number" name="total_amount" step="0.01" class="form-control" required>
        </div>

        <!-- Status -->
        <div class="form-group">
            <label>Status</label>
            <select name="status" class="form-control">
                <option value="unpaid" selected>Unpaid</option>
                <option value="partially_paid">Partially Paid</option>
                <option value="paid">Paid</option>
            </select>
        </div>

        <!-- Remarks -->
        <div class="form-group">
            <label>Remarks</label>
            <textarea name="remarks" class="form-control" rows="3"></textarea>
        </div>

        <!-- Buttons -->
        <div class="text-center">
            <button type="submit" class="btn btn-success">Generate Bill</button>
            <a href="desboard.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
