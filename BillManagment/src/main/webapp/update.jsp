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

String partyName = "", billDate = "", dueDate = "", status = "", remarks = "", paymentMode = "", paymentDate = "";
int billId = 0;
double totalAmount = 0.0;

try {
	con = Helper.helper();
	String sql = "SELECT b.*, p.party_name, pay.payment_mode, pay.payment_date " + "FROM bill b "
	+ "INNER JOIN party p ON b.party_id = p.party_id " + "LEFT JOIN payment pay ON pay.payment_id = ("
	+ "   SELECT MAX(payment_id) FROM payment WHERE bill_id = b.bill_id" + ") " + "WHERE b.bill_number = ?";

	ps = con.prepareStatement(sql);
	ps.setString(1, billNumber);
	rs = ps.executeQuery();

	if (rs.next()) {
		billId = rs.getInt("bill_id");
		partyName = rs.getString("party_name");
		billDate = rs.getString("bill_date");
		dueDate = rs.getString("due_date");
		status = rs.getString("status");
		remarks = rs.getString("remarks");
		totalAmount = rs.getDouble("total_amount");
		paymentMode = rs.getString("payment_mode") != null ? rs.getString("payment_mode") : "";
		paymentDate = rs.getString("payment_date") != null ? rs.getString("payment_date") : "";
	} else {
		out.print("<div class='alert alert-danger'>Bill not found!</div>");
		return;
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

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Bill</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
body {
	background-color: #f7f7f7;
	padding: 40px;
}

.container {
	background: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	max-width: 600px;
	margin: auto;
}
</style>
</head>
<body>

	<div class="container">
		<h3 class="mb-4 text-center">
			Update Bill -
			<%=billNumber%></h3>

		<form action="updateBill" method="post">
			<input type="hidden" name="bill_id" value="<%=billId%>">

			<div class="form-group">
				<label>Party Name</label> <input type="text" class="form-control"
					value="<%=partyName%>" readonly> <input type="hidden"
					name="party_name" value="<%=partyName%>">
			</div>


			<div class="form-group">
				<label>Bill Date</label> <input type="date" class="form-control"
					value="<%=billDate%>">
			</div>

			<div class="form-group">
				<label>Due Date</label> <input type="date" name="due_date"
					class="form-control" value="<%=dueDate%>" required>
			</div>

			<div class="form-group">
				<label>Total Amount</label> <input type="number" name="total_amount"
					step="0.01" class="form-control" value="<%=totalAmount%>" required>
			</div>

			<div class="form-group">
				<label>Payment Date</label> <input type="date" name="payment_date"
					class="form-control" value="<%=paymentDate%>">
			</div>

			<div class="form-group">
				<label>Payment Mode</label> <select name="payment_mode"
					class="form-control" required>
					<option value="">-- Select Payment Mode --</option>
					<option value="cash"
						<%="cash".equalsIgnoreCase(paymentMode) ? "selected" : ""%>>Cash</option>
					<option value="cheque"
						<%="cheque".equalsIgnoreCase(paymentMode) ? "selected" : ""%>>Cheque</option>
				</select>
			</div>


			<div class="form-group">
				<label>Status</label> <select name="status" class="form-control"
					required>
					<option value="unpaid"
						<%="unpaid".equals(status) ? "selected" : ""%>>Unpaid</option>
					<option value="partially_paid"
						<%="partially_paid".equals(status) ? "selected" : ""%>>Partially
						Paid</option>
					<option value="paid" <%="paid".equals(status) ? "selected" : ""%>>Paid</option>
				</select>
			</div>

			<div class="form-group">
				<label>Remarks</label>
				<textarea name="remarks" class="form-control" rows="3"><%=remarks%></textarea>
			</div>

			<div class="text-center">
				<button type="submit" class="btn btn-success">Update Bill</button>
				<a href="desboard.jsp" class="btn btn-secondary">Cancel</a>
			</div>
		</form>
	</div>

</body>
</html>
