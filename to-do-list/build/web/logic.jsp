<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:mysql://localhost:3306/db";
    String user = "root";
    String password = ""; // <-- change this

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, user, password);

    // Add Task
    String newTask = request.getParameter("task");
    if (newTask != null && !newTask.trim().equals("")) {
        PreparedStatement ps = con.prepareStatement("INSERT INTO tasks (task) VALUES (?)");
        ps.setString(1, newTask);
        ps.executeUpdate();
        ps.close();
    }

    // Delete Task
    String deleteId = request.getParameter("delete");
    if (deleteId != null) {
        PreparedStatement ps = con.prepareStatement("DELETE FROM tasks WHERE id=?");
        ps.setInt(1, Integer.parseInt(deleteId));
        ps.executeUpdate();
        ps.close();
    }

    // Fetch Tasks
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM tasks");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ToDo List</title>
    <style>
        body {
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .todo-container {
            background: white;
            width: 350px;
            padding: 20px;
            border-radius: 20px;
            box-shadow: 0px 4px 20px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
        }
        form {
            display: flex;
            margin-bottom: 15px;
        }
        input[type="text"] {
            flex: 1;
            padding: 10px;
            border-radius: 20px;
            border: 1px solid #ccc;
            outline: none;
        }
        button {
            background-color: #00c853;
            border: none;
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 20px;
            margin-left: 10px;
            cursor: pointer;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        li {
            background: #f8f8f8;
            margin: 5px 0;
            padding: 10px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        a {
            color: red;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="todo-container">
        <h2>📝 ToDo List</h2>
        <form method="post" action="logic.jsp">
            <input type="text" name="task" placeholder="Add your task" required>
            <button type="submit">+</button>
        </form>
        <ul>
            <%
                while(rs.next()) {
                    int id = rs.getInt("id");
                    String task = rs.getString("task");
            %>
            <li>
                <span><%= task %></span>
                <a href="logic.jsp?delete=<%= id %>">🗑</a>
            </li>
            <% } %>
        </ul>
    </div>
</body>
</html>

<%
    rs.close();
    st.close();
    con.close();
%>
