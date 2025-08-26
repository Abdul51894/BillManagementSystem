<%@ page import="java.sql.*, com.helper.Helper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>

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
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container mt-5">
		<h3 class="mb-4">Add New Payment</h3>
		<form action="payment" method="post">
			<input type="hidden" name="register_id" value="<%=registerId%>">

			<div class="form-group">
				<label>Bill Number</label>
				<select name="bill_id" class="form-control" required>
					<option value="">-- Select Bill --</option>
					<%
						try (Connection con = Helper.helper();
							 PreparedStatement ps = con.prepareStatement("SELECT b.bill_id, b.bill_number, p.party_name FROM bill b JOIN party p ON b.party_id = p.party_id")) {
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
					%>
					<option value="<%= rs.getInt("bill_id") %>">
						Bill #<%= rs.getString("bill_number") %> - <%= rs.getString("party_name") %>
					</option>
					<%
							}
						} catch (Exception e) {
							out.println("<option disabled>Error loading bills</option>");
							e.printStackTrace();
						}
					%>
				</select>
			</div>

			<div class="form-group">
				<label>Amount Paid</label>
				<input type="number" step="0.01" name="amount_paid" class="form-control" required>
			</div>

			<div class="form-group">
				<label>Payment Date</label>
				<input type="date" name="payment_date" class="form-control" required>
			</div>

			<div class="form-group">
				<label>Payment Mode</label>
				<select name="payment_mode" class="form-control" required>
					<option value="cash">Cash</option>
					<option value="cheque">Cheque</option>
				</select>
			</div>

			<button type="submit" class="btn btn-success">Submit Payment</button>
			<a href="desboard.jsp" class="btn btn-secondary">Cancel</a>
		</form>
	</div>
</body>
</html>
