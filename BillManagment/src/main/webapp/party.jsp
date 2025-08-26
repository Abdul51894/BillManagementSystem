<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page errorPage="error.jsp" %>
<%
Integer registerId = (Integer)session.getAttribute("id");
if (registerId == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Party</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
body {
	background-color: #f5f5f5;
	padding: 40px;
}
.container {
    background: #fff;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
    
    max-width: 400px;  
    margin: auto;      
}
</style>
</head>
<body>
	<div class="container">
		<h2 class="mb-4">Add New Party</h2>

		<form action="party" method="post">
			<!-- hidden register ID -->
			<input type="hidden" name="register_id" value="<%=registerId%>">

			<div class="form-group">
				<label for="party_name">Party Name</label>
				<input type="text" name="party_name" class="form-control" required>
			</div>

			<div class="form-group">
				<label for="phone">Phone</label>
				<input type="text" name="phone" class="form-control">
			</div>

			<div class="form-group">
				<label for="gst_number">GST Number</label>
				<input type="text" name="gst_number" class="form-control">
			</div>

			<button type="submit" class="btn btn-primary">Add Party</button>
			<a href="desboard.jsp" class="btn btn-secondary">Cancel</a>
		</form>
	</div>
</body>
</html>
