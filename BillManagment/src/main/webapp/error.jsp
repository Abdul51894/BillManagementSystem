<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error Page</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-container {
            max-width: 700px;
            padding: 30px;
            border-radius: 15px;
            background-color: #ffffff;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .error-image {
            width: 150px;
            height: auto;
        }

        .exception-box {
            background-color: #f1f1f1;
            padding: 15px;
            border-radius: 10px;
            font-size: 14px;
            color: #333;
            word-wrap: break-word;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
        }
    </style>
</head>

<body>
	 <div class="container d-flex flex-column justify-content-center align-items-center error-container">
        <div class="text-center">
            <img src="img/error.jpeg" alt="Error" class="error-image mb-4">
            <h1 class="display-4 text-danger">Oops! Something went wrong.</h1>
            <p class="lead">We’re sorry, but an unexpected error occurred.</p>
            <a href="index.html" class="btn btn-primary mt-3">Go Back Home</a>

            <!-- Exception Display -->
            <div class="exception-box mt-4 text-start">
                <strong>Exception Details:</strong><br>
                <%= exception %>
            </div>
        </div>
    </div>
	
</body>
</html>