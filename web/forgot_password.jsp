<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recuperar contraseña</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="min-h-screen bg-[#f4f5f7] flex items-center justify-center p-4">

<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>

<div class="w-full max-w-md bg-white rounded-2xl shadow-sm border border-gray-100 p-8">

    <h1 class="text-2xl font-extrabold text-gray-900 mb-2">Recuperar contraseña</h1>
    <p class="text-sm text-gray-400 mb-6">
        Ingresa tu correo y tipo de perfil para generar un enlace de recuperación.
    </p>
    <div class="mb-6 rounded-2xl bg-yellow-50 border border-yellow-100 px-4 py-3 text-sm text-yellow-700 font-semibold">
        Debes dirigirte directamente a las oficinas de registro y control para asistencia con la recuperación de tu contraseña.
    </div>

    <div class="mt-6 text-center">
        <a href="<%=request.getContextPath()%>/login"
           class="text-sm font-bold text-[#c8102e] hover:underline">
            Volver al inicio de sesión
        </a>
    </div>
</div>

</body>
</html>