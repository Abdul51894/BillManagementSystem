<%@ page import="java.sql.*, com.helper.Helper"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%

Integer registerId = (Integer)session.getAttribute("id");
if (registerId == null) {
	response.sendRedirect("login.jsp");
	return;
}

String billNumber = request.getParameter("bill_number");
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<title>Bill - <%=billNumber%></title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
body {
	background: linear-gradient(135deg, #e0f7fa, #ffffff);
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	animation: fadeIn 1s ease-in-out;
}

.invoice-box {
	max-width: 800px;
	margin: 40px auto;
	padding: 30px;
	border: 1px solid #ccc;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	animation: slideUp 0.8s ease;
}

.invoice-header {
	text-align: center;
	margin-bottom: 30px;
}

.invoice-header h2 {
	margin: 0;
	font-weight: bold;
	color: #00796b;
}

.invoice-header p {
	margin: 0;
	font-size: 14px;
	color: #555;
}

.table td, .table th {
	vertical-align: middle;
}

@
keyframes fadeIn {
	from {opacity: 0;
}

to {
	opacity: 1;
}

}
@
keyframes slideUp {
	from {transform: translateY(20px);
	opacity: 0;
}

to {
	transform: translateY(0);
	opacity: 1;
}
}
</style>
</head>
<body>
	<div class="invoice-box">
		<div class="invoice-header">
			<h2>Khan Brother's</h2>
			<p>Kurla West, Mumbai - 400070</p>
			<p>
				<strong>GSTIN:</strong> 27XXXXXXXXXXZ5
			</p>
			<p>
				<strong>Contact:</strong> 94xxxxx3487
			</p>
			<hr>
		</div>

		<%
		try {
			con = Helper.helper();
			String sql = "SELECT b.*, p.party_name, p.phone, p.gst_number "
			+ "FROM bill b INNER JOIN party p ON b.party_id = p.party_id " + "WHERE b.bill_number = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, billNumber);
			rs = ps.executeQuery();

			if (rs.next()) {
		%>
		<table class="table table-bordered">
			<tr>
				<th>Bill Number</th>
				<td><%=rs.getString("bill_number")%></td>
				<th>Issue Bill Date</th>
				<td><%=rs.getDate("bill_date")%></td>
			</tr>
			<tr>
				<th>Due Date</th>
				<td><%=rs.getDate("due_date")%></td>
				<th>Status</th>
				<td><%=rs.getString("status")%></td>
			</tr>
		</table>

		<h5 class="mt-4">Party Details</h5>
		<table class="table table-bordered">
			<tr>
				<th>Name</th>
				<td><%=rs.getString("party_name")%></td>
				<th>Phone</th>
				<td><%=rs.getString("phone")%></td>
			</tr>
			<tr>
				<th>GST Number</th>
				<td colspan="3"><%=rs.getString("gst_number")%></td>
			</tr>
		</table>

		<h5 class="mt-4">Billing Details</h5>
		<table class="table table-bordered">
			<tr>
				<th>Total Amount</th>
				<td colspan="3">₹ <%=rs.getDouble("total_amount")%></td>
			</tr>
			<tr>
				<th>Remarks</th>
				<td colspan="3"><%=rs.getString("remarks")%></td>
			</tr>
		</table>

		<div class="d-flex justify-content-center gap-4 mt-4">
			<a href="desboard.jsp" class="btn btn-secondary ml-4">Back to
				Dashboard</a> <a href="payment.jsp" class="btn btn-primary ml-4">Payment</a>
		</div>



		<%
		} else {
		%>
		<div class="alert alert-danger">Bill not found!</div>
		<%
		}
		} catch (Exception e) {
		out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
		} finally {
		if (rs != null)
		rs.close();
		if (ps != null)
		ps.close();
		if (con != null)
		con.close();
		}
		%>
	</div>
</body>
</html>

<!-- This is comment -->