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

    <% if (error != null) { %>
        <div class="mb-4 rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 font-semibold">
            <%= error %>
        </div>
    <% } %>

    <% if (success != null) { %>
        <div class="mb-4 rounded-xl bg-green-50 border border-green-100 px-4 py-3 text-sm text-green-600 font-semibold">
            <%= success %>
        </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/forgot-password" method="post" class="space-y-4">

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Correo</label>
            <input type="email"
                   name="email"
                   required
                   placeholder="correo@example.com"
                   class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/40">
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Tipo de perfil</label>
            <select name="role"
                    required
                    class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/40">
                <option value="">Selecciona una opción</option>
                <option value="student">Estudiante</option>
                <option value="admin">Administrador</option>
            </select>
        </div>

        <button type="submit"
                class="w-full rounded-xl bg-[#c8102e] py-3 text-sm font-bold text-white hover:bg-red-700">
            Generar enlace
        </button>
    </form>

    <div class="mt-6 text-center">
        <a href="<%=request.getContextPath()%>/login"
           class="text-sm font-bold text-[#c8102e] hover:underline">
            Volver al inicio de sesión
        </a>
    </div>
</div>

</body>
</html>