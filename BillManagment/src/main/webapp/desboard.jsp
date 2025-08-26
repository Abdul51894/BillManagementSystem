<%@ page import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.helper.Helper"%>
<%@ page errorPage="error.jsp" %>

<% Integer registerId = (Integer)session.getAttribute("id");
if (registerId == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard - Bill Management</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
body {
	padding: 40px;
	background-color: #f0f2f5;
}
.container {
	background: #fff;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}
.btn-sm {
	margin-right: 5px;
}
</style>
</head>
<body>
	<div class="container">

		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2>Bill Dashboard</h2>
			<a href="logout" class="btn btn-danger btn-sm">Logout</a>
		</div>

		<div class="text-center mb-3">
			<a href="party.jsp" class="btn btn-primary btn-sm">Add New Bill</a>
		</div>

		<table class="table table-bordered table-hover">
			<thead class="thead-dark">
				<tr>
					<th>Bill Number</th>
					<th>Party</th>
					<th>Total</th>
					<th>Issue Bill Date</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<%
				Connection con = null;
				Statement st = null;
				ResultSet rs = null;
				try {
					con = Helper.helper();
					String sql = "SELECT bill.bill_number, party.party_name, bill.total_amount, bill.bill_date "
							+ "FROM bill INNER JOIN party ON bill.party_id = party.party_id";
					st = con.createStatement();
					rs = st.executeQuery(sql);

					while (rs.next()) {
				%>
				<tr>
					<td><%=rs.getString("bill_number")%></td>
					<td><%=rs.getString("party_name")%></td>
					<td><%=rs.getDouble("total_amount")%></td>
					<td><%=rs.getDate("bill_date")%></td>
					<td>
						<a href="paymentBill.jsp?bill_number=<%=rs.getString("bill_number")%>" class="btn btn-info btn-sm">View</a>
						<a href="update.jsp?bill_number=<%=rs.getString("bill_number")%>" class="btn btn-warning btn-sm">Update</a>
						<a href="deleteBill.jsp?bill_number=<%=rs.getString("bill_number")%>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure to delete this bill?');">Delete</a>
					</td>
				</tr>
				<%
					}
				} catch (Exception e) {
					out.println("<tr><td colspan='5' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
				} finally {
					if (rs != null) rs.close();
					if (st != null) st.close();
					if (con != null) con.close();
				}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>
