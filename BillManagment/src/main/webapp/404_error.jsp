<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sorry! Page Not Found</title>
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr"
        crossorigin="anonymous">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .error-container {
            height: 100vh;
            overflow-y: auto;
        }
        .error-image {
            width: 400px;
            max-width: 80%;
            height: auto;
        }
    </style>
</head>
<body>

    <div class="container d-flex flex-column justify-content-center align-items-center error-container">
        <div class="text-center">
            <img src="img/404.jpg" alt="404 Error" class="error-image mb-4">
            <h1 class="display-4 text-warning">404 - Page Not Found</h1>
            <p class="lead">Oops! The page you are looking for doesn’t exist or was moved.</p>
            <a href="home.jsp" class="btn btn-primary mt-3">Go Back Home</a>
        </div>
    </div>

</body>
</html>
