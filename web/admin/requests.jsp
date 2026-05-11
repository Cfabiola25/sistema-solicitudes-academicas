<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitudes - Panel de Administrador</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex">
<!-- Sidebar -->
<aside class="w-64 bg-red-600 text-white flex flex-col justify-between">
    <div>
        <h2 class="text-xl font-bold p-4 border-b border-red-700">FESC Admin</h2>
        <nav class="mt-4 flex flex-col">
            <a href="<%=request.getContextPath()%>/admin/dashboard" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-tachometer-alt mr-3"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests" class="px-4 py-3 flex items-center bg-red-700">
                <i class="fa fa-folder-open mr-3"></i> Solicitudes
            </a>
            <a href="#" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-users mr-3"></i> Estudiantes
            </a>
            <a href="#" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-chart-bar mr-3"></i> Reportes
            </a>
            <a href="#" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-cog mr-3"></i> Configuración
            </a>
        </nav>
    </div>
    <div class="p-4 border-t border-red-700">
        <a href="<%=request.getContextPath()%>/logout" class="flex items-center text-white hover:text-gray-200">
            <i class="fa fa-sign-out-alt mr-2"></i> Cerrar sesión
        </a>
    </div>
</aside>
<!-- Main content -->
<main class="flex-1 p-8">
    <h1 class="text-2xl font-bold mb-4">Todas las solicitudes</h1>
    <div class="mb-4 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <form method="get" class="flex items-center gap-2">
            <label for="state" class="text-gray-700">Estado:</label>
            <select id="state" name="state" class="px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500">
                <option value="" <%= request.getParameter("state") == null || request.getParameter("state").isEmpty() ? "selected" : "" %>>Todos</option>
                <option value="Enviada" <%= "Enviada".equals(request.getParameter("state")) ? "selected" : "" %>>Enviada</option>
                <option value="Pendiente" <%= "Pendiente".equals(request.getParameter("state")) ? "selected" : "" %>>Pendiente</option>
                <option value="Aprobada" <%= "Aprobada".equals(request.getParameter("state")) ? "selected" : "" %>>Aprobada</option>
                <option value="Rechazada" <%= "Rechazada".equals(request.getParameter("state")) ? "selected" : "" %>>Rechazada</option>
            </select>
            <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">Filtrar</button>
        </form>
    </div>
    <div class="bg-white shadow rounded p-4 overflow-x-auto">
        <table class="min-w-full text-sm">
            <thead>
            <tr class="bg-gray-50">
                <th class="px-4 py-2 text-left">ID</th>
                <th class="px-4 py-2 text-left">Estudiante</th>
                <th class="px-4 py-2 text-left">Tipo</th>
                <th class="px-4 py-2 text-left">Fecha</th>
                <th class="px-4 py-2 text-left">Estado</th>
                <th class="px-4 py-2 text-center">Acción</th>
            </tr>
            </thead>
            <tbody>
            <% List<Solicitud> list = (List<Solicitud>) request.getAttribute("list");
               for (Solicitud sol : list) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%= sol.getId() %></td>
                    <td class="px-4 py-2"><%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></td>
                    <td class="px-4 py-2"><%= sol.getTipo().getNombre() %></td>
                    <td class="px-4 py-2"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
                    <td class="px-4 py-2">
                        <% String st = sol.getEstado(); %>
                        <% if ("Pendiente".equals(st)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-yellow-200 text-yellow-800"><%= st %></span>
                        <% } else if ("Aprobada".equals(st)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-green-200 text-green-800"><%= st %></span>
                        <% } else if ("Rechazada".equals(st)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-red-200 text-red-800"><%= st %></span>
                        <% } else if ("Enviada".equals(st)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-blue-200 text-blue-800"><%= st %></span>
                        <% } else { %>
                            <span class="px-2 py-1 text-xs rounded bg-gray-200 text-gray-800"><%= st %></span>
                        <% } %>
                    </td>
                    <td class="px-4 py-2 text-center">
                        <a href="<%=request.getContextPath()%>/admin/request-detail?id=<%= sol.getId() %>" class="text-red-600 hover:text-red-800"><i class="fa fa-eye"></i></a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>