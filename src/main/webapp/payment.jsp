<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="com.helper.Helper"%>
<%@ page errorPage="error.jsp"%>

<%
Integer registerId = (Integer) session.getAttribute("id");
if (registerId == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Payment</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
body {
	background-color: #f8f9fa;
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
		<h2 class="mb-4">Add New Payment</h2>

		<form action="payment" method="post">
			<!-- Hidden field for register_id from session -->
			<input type="hidden" name="register_id" value="<%=registerId%>">

			<div class="form-group">
				<label for="bill_id">Bill Number</label> <select name="bill_id"
					class="form-control" required>
					<option value="">-- Select Bill ID --</option>
					<%
					try (Connection con = Helper.helper();
							Statement st = con.createStatement();
							ResultSet rs = st.executeQuery("SELECT bill_number FROM bill");) {
						while (rs.next()) {
					%>
					<option value="<%=rs.getInt("bill_number")%>"><%=rs.getInt("bill_number")%></option>
					<%
					}
					} catch (Exception e) {
					out.println("<option disabled>Error loading bill IDs</option>");
					e.printStackTrace();
					}
					%>
				</select>
			</div>

			<div class="form-group">
				<label for="amount_paid">Amount Paid</label> <input type="number"
					step="0.01" name="amount_paid" class="form-control" required>
			</div>

			<div class="form-group">
				<label for="payment_date">Payment Date</label> <input type="date"
					name="payment_date" class="form-control" required>
			</div>

			<div class="form-group">
				<label for="payment_mode">Payment Mode</label> <select
					name="payment_mode" class="form-control" required>
					<option value="cash">Cash</option>
					<option value="cheque">Cheque</option>
				</select>
			</div>


			<button type="submit" class="btn btn-success">Submit Payment</button>
			<a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
		</form>
	</div>
</body>
</html>
