<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Service</title>
</head>
<body>

<h2>Book Service</h2>

<form action="${pageContext.request.contextPath}/user/book" method="post">
    Service Type:
    <select name="serviceType">
        <option value="Oil Change">Oil Change</option>
        <option value="Repair">Repair</option>
        <option value="Washing">Washing</option>
    </select>

    <button type="submit">Submit</button>
</form>

</body>
</html>