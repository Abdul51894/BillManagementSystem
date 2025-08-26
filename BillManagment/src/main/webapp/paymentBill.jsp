<%@ page import="java.sql.*, com.helper.Helper"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
String billNumber = request.getParameter("bill_number");
Connection con = null;
PreparedStatement ps = null, ps2 = null, ps3 = null;
ResultSet rs = null, rs2 = null, rs3 = null;
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
}

.invoice-box {
	max-width: 800px;
	margin: 20px auto;
	padding: 20px;
	border: 1px solid #ccc;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.invoice-header {
	text-align: center;
	margin-bottom: 20px;
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

.btn-group {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 20px;
}

@media print {
	#actions {
		display: none !important;
	}
}
</style>

<!-- jsPDF for PDF generation -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

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

			String billSql = "SELECT b.*, p.party_name, p.phone, p.gst_number FROM bill b INNER JOIN party p ON b.party_id = p.party_id WHERE b.bill_number = ?";
			ps = con.prepareStatement(billSql);
			ps.setString(1, billNumber);
			rs = ps.executeQuery();

			if (rs.next()) {
				int billId = rs.getInt("bill_id");
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

		<h5 class="mt-3">Party Details</h5>
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

		<h5 class="mt-3">Billing Details</h5>
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

		<%
		String countSql = "SELECT COUNT(*) FROM payment WHERE bill_id = ?";
		ps2 = con.prepareStatement(countSql);
		ps2.setInt(1, billId);
		rs2 = ps2.executeQuery();

		boolean hasPayment = false;
		if (rs2.next()) {
			hasPayment = rs2.getInt(1) > 0;
		}

		if (hasPayment) {
		%>
		<h5 class="mt-3">Payment History</h5>
		<table class="table table-bordered">
			<tr>
				<th>Payment Date</th>
				<th>Payment Mode</th>
				<th>Amount Paid (₹)</th>
			</tr>
			<%
			double totalPaid = 0.0;
			String paymentSql = "SELECT * FROM payment WHERE bill_id = ?";
			ps3 = con.prepareStatement(paymentSql);
			ps3.setInt(1, billId);
			rs3 = ps3.executeQuery();

			while (rs3.next()) {
				double amt = rs3.getDouble("amount_paid");
				totalPaid += amt;
			%>
			<tr>
				<td><%=rs3.getDate("payment_date")%></td>
				<td><%=rs3.getString("payment_mode")%></td>
				<td>₹ <%=amt%></td>
			</tr>
			<%
			}
			%>
			<tr class="table-success font-weight-bold">
				<td colspan="2">Total Paid</td>
				<td>₹ <%=totalPaid%></td>
			</tr>
			<tr class="table-warning font-weight-bold">
				<td colspan="2">Remaining</td>
				<td>₹ <%=rs.getDouble("total_amount") - totalPaid%></td>
			</tr>
		</table>
		<%
		} else {
		%>
		<div class="alert alert-warning text-center mt-3">No payments
			made for this bill.</div>
		<%
		}
		%>

		<div class="btn-group mb-4" id="actions">
			<a href="desboard.jsp" class="btn btn-secondary">Back to
				Dashboard</a> <a href="payment.jsp?bill_id=<%=billId%>"
				class="btn btn-primary">Make Payment</a>
			<button onclick="printPage()" class="btn btn-info">🖨️ Print</button>
			<button onclick="downloadPDF()" class="btn btn-success">⬇️
				Download PDF</button>
		</div>



		<%
		} else {
		%>
		<div class="alert alert-danger text-center">Bill not found!</div>
		<%
		}
		} catch (Exception e) {
		out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
		} finally {
		if (rs3 != null)
		rs3.close();
		if (ps3 != null)
		ps3.close();
		if (rs2 != null)
		rs2.close();
		if (ps2 != null)
		ps2.close();
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

<!-- Load jsPDF and html2canvas -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

<script>
function printPage() {
  const el = document.getElementById("actions");
  el.style.display = "none";
  window.print();
  setTimeout(() => {
    el.style.display = "flex"; // or "block" based on layout
  }, 1000);
}

async function downloadPDF() {
  const el = document.getElementById("actions");
  el.style.display = "none";

  const invoice = document.querySelector(".invoice-box");

  // Create canvas image
  const canvas = await html2canvas(invoice, {
    scale: 2,
    useCORS: true
  });

  const imgData = canvas.toDataURL("image/png");
  const pdf = new jspdf.jsPDF("p", "pt", "a4");

  const pdfWidth = pdf.internal.pageSize.getWidth();
  const pdfHeight = (canvas.height * pdfWidth) / canvas.width;

  pdf.addImage(imgData, "PNG", 20, 20, pdfWidth - 40, pdfHeight);
  pdf.save("Bill_<%=billNumber%>.pdf");

  el.style.display = "flex"; // or "block"
}
</script>


</html>
