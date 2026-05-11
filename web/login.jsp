<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Sistema de Solicitudes Académicas</title>
    <!-- Tailwind CSS via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="min-h-screen flex items-center justify-center bg-gray-100">
<div class="w-full max-w-4xl bg-white shadow-lg rounded-lg overflow-hidden flex flex-col md:flex-row">
    <!-- Left panel -->
    <div class="md:w-5/12 bg-red-600 text-white p-8 flex flex-col justify-center">
        <h1 class="text-3xl font-bold mb-4">Sistema de Solicitudes Académicas</h1>
        <p class="text-md">Facultad de Estudios Superiores - FESC</p>
        <div class="mt-8">
            <p class="text-sm">Ingrese sus credenciales para acceder al sistema y gestionar sus solicitudes académicas en línea.</p>
        </div>
    </div>
    <!-- Login form -->
    <div class="md:w-7/12 p-8">
        <h2 class="text-2xl font-semibold mb-6 text-gray-800">Iniciar Sesión</h2>
        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
            <div class="mb-4 p-3 bg-red-100 border border-red-300 text-red-700 rounded"> <%= error %> </div>
        <% } %>
        <form action="<%=request.getContextPath()%>/login" method="post" class="space-y-4">
            <div>
                <label class="block text-gray-700">Correo electrónico</label>
                <input type="email" name="email" required class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500" />
            </div>
            <div>
                <label class="block text-gray-700">Contraseña</label>
                <input type="password" name="password" required class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500" />
            </div>
            <div>
                <label class="block text-gray-700">Rol</label>
                <select name="role" required class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500">
                    <option value="student">Estudiante</option>
                    <option value="admin">Administrador</option>
                </select>
            </div>
            <button type="submit" class="w-full bg-red-600 text-white py-2 rounded hover:bg-red-700 transition">Ingresar</button>
        </form>
    </div>
</div>
</body>
</html>