<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nueva contraseña</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="min-h-screen bg-[#f4f5f7] flex items-center justify-center p-4">

<%
    String error = (String) request.getAttribute("error");
    String token = (String) request.getAttribute("token");
    String profile = (String) request.getAttribute("profile");

    if (token == null) token = "";
    if (profile == null) profile = "";
%>

<div class="w-full max-w-md bg-white rounded-2xl shadow-sm border border-gray-100 p-8">

    <h1 class="text-2xl font-extrabold text-gray-900 mb-2">Crear nueva contraseña</h1>
    <p class="text-sm text-gray-400 mb-6">
        Escribe y confirma tu nueva contraseña.
    </p>

    <% if (error != null) { %>
        <div class="mb-4 rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 font-semibold">
            <%= error %>
        </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/recover-password" method="post" class="space-y-4">

        <input type="hidden" name="token" value="<%= token %>">
        <input type="hidden" name="profile" value="<%= profile %>">

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Nueva contraseña</label>
            <input type="password"
                   name="password"
                   required
                   class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/40">
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Confirmar contraseña</label>
            <input type="password"
                   name="confirmPassword"
                   required
                   class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/40">
        </div>

        <button type="submit"
                class="w-full rounded-xl bg-[#c8102e] py-3 text-sm font-bold text-white hover:bg-red-700">
            Guardar nueva contraseña
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