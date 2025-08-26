<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Home - Bill Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #74ebd5, #acb6e5);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            margin-top: 80px;
        }
        .card {
            transition: transform 0.3s, box-shadow 0.3s;
            border: none;
            border-radius: 20px;
        }
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }
        .card i {
            font-size: 40px;
            color: #4e54c8;
        }
        .card-title {
            font-weight: 600;
            font-size: 1.3rem;
        }
        h2 {
            color: #2c3e50;
            margin-bottom: 40px;
            font-weight: 700;
        }
    </style>
</head>
<body>

<div class="container text-center">
    <h2>Welcome to Bill Management System</h2>
    <div class="row g-4 justify-content-center">
        <div class="col-md-4">
            <a href="party.jsp" class="text-decoration-none text-dark">
                <div class="card p-4 shadow-sm">
                    <i class="fas fa-file-invoice-dollar mb-3"></i>
                    <div class="card-body">
                        <h5 class="card-title">Add New Bill</h5>
                    </div>
                </div>
            </a>
        </div>


        <div class="col-md-4">
            <a href="desboard.jsp" class="text-decoration-none text-dark">
                <div class="card p-4 shadow-sm">
                    <i class="fas fa-users mb-3"></i>
                    <div class="card-body">
                        <h5 class="card-title">Manage Parties</h5>
                    </div>
                </div>
            </a>
        </div>

        <div class="col-md-4">
            <a href="logout" class="text-decoration-none text-dark">
                <div class="card p-4 shadow-sm">
                    <i class="fas fa-sign-out-alt mb-3"></i>
                    <div class="card-body">
                      <h5 class="card-title">Logout</h5>
                    </div>
                </div>
            </a>
        </div>
    </div>
</div>

</body>
</html>
