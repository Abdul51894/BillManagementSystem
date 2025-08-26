<%@ page import="java.sql.*, com.helper.Helper"%>
<%
Integer registerId = (Integer) session.getAttribute("id");
if (registerId == null) {
	response.sendRedirect("login.jsp");
	return;
}

String billNumberParam = request.getParameter("bill_number");

if (billNumberParam != null && !billNumberParam.trim().isEmpty()) {
	Connection con = null;
	PreparedStatement pst = null;

	try {
		con = Helper.helper();

		String sql = "DELETE FROM bill WHERE bill_number = ?";
		pst = con.prepareStatement(sql);
		pst.setString(1, billNumberParam);

		int rowsDeleted = pst.executeUpdate();

		if (rowsDeleted > 0) {
%>
<script>
                    alert("Bill deleted successfully!");
                    window.location.href = "desboard.jsp";
                </script>
<%
} else {
%>
<script>
                    alert("Bill not found or could not be deleted.");
                    window.location.href = "desboard.jsp";
                </script>
<%
}
} catch (Exception e) {
%>
<script>
                alert("Error occurred: <%=e.getMessage()%>
	");
	window.location.href = "desboard.jsp";
</script>
<%
} finally {
if (pst != null)
	try {
		pst.close();
	} catch (Exception e) {
	}
if (con != null)
	try {
		con.close();
	} catch (Exception e) {
	}
}
} else {
%>
<script>
	alert("Invalid bill number.");
	window.location.href = "desboard.jsp";
</script>
<%
}
%>
