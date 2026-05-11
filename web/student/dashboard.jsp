<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Estudiante - Sistema de Solicitudes</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex">
<%
    HttpSession sess = request.getSession(false);
    Student student = (Student) sess.getAttribute("user");
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    List<Solicitud> recent = (List<Solicitud>) request.getAttribute("recent");
%>
<!-- Sidebar -->
<aside class="w-60 bg-red-600 text-white flex flex-col justify-between">
    <div>
        <h2 class="text-xl font-bold p-4 border-b border-red-700">FESC</h2>
        <nav class="mt-4 flex flex-col">
            <a href="<%=request.getContextPath()%>/student/dashboard" class="px-4 py-3 flex items-center hover:bg-red-700 <%= request.getRequestURI().endsWith("dashboard") ? "bg-red-700" : "" %>">
                <i class="fa fa-home mr-3"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/student/new-request" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-plus mr-3"></i> Nueva Solicitud
            </a>
            <a href="<%=request.getContextPath()%>/student/requests" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-list mr-3"></i> Mis Solicitudes
            </a>
            <a href="#" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-user mr-3"></i> Perfil
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
    <h1 class="text-2xl font-bold mb-4">Bienvenido, <%=student.getNombre()%>!</h1>
    <!-- Stats cards -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-white shadow rounded p-4 flex items-center justify-between">
            <div>
                <p class="text-gray-500 text-sm">Enviadas</p>
                <p class="text-2xl font-bold"><%= counts.getOrDefault("Enviada", 0) %></p>
            </div>
            <i class="fa fa-paper-plane text-red-600 text-3xl"></i>
        </div>
        <div class="bg-white shadow rounded p-4 flex items-center justify-between">
            <div>
                <p class="text-gray-500 text-sm">Pendientes</p>
                <p class="text-2xl font-bold"><%= counts.getOrDefault("Pendiente", 0) %></p>
            </div>
            <i class="fa fa-hourglass-half text-yellow-500 text-3xl"></i>
        </div>
        <div class="bg-white shadow rounded p-4 flex items-center justify-between">
            <div>
                <p class="text-gray-500 text-sm">Aprobadas</p>
                <p class="text-2xl font-bold"><%= counts.getOrDefault("Aprobada", 0) %></p>
            </div>
            <i class="fa fa-check-circle text-green-600 text-3xl"></i>
        </div>
        <div class="bg-white shadow rounded p-4 flex items-center justify-between">
            <div>
                <p class="text-gray-500 text-sm">Rechazadas</p>
                <p class="text-2xl font-bold"><%= counts.getOrDefault("Rechazada", 0) %></p>
            </div>
            <i class="fa fa-times-circle text-red-600 text-3xl"></i>
        </div>
    </div>
    <!-- Recent requests table -->
    <div class="bg-white shadow rounded p-4">
        <h2 class="text-xl font-semibold mb-4">Solicitudes recientes</h2>
        <div class="overflow-x-auto">
        <table class="min-w-full text-sm">
            <thead>
            <tr class="bg-gray-50">
                <th class="px-4 py-2 text-left">ID</th>
                <th class="px-4 py-2 text-left">Tipo</th>
                <th class="px-4 py-2 text-left">Fecha</th>
                <th class="px-4 py-2 text-left">Estado</th>
                <th class="px-4 py-2 text-center">Acción</th>
            </tr>
            </thead>
            <tbody>
            <% for (Solicitud sol : recent) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%= sol.getId() %></td>
                    <td class="px-4 py-2"><%= sol.getTipo().getNombre() %></td>
                    <td class="px-4 py-2"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
                    <td class="px-4 py-2">
                        <% String est = sol.getEstado(); %>
                        <% if ("Pendiente".equals(est)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-yellow-200 text-yellow-800"><%= est %></span>
                        <% } else if ("Aprobada".equals(est)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-green-200 text-green-800"><%= est %></span>
                        <% } else if ("Rechazada".equals(est)) { %>
                            <span class="px-2 py-1 text-xs rounded bg-red-200 text-red-800"><%= est %></span>
                        <% } else { %>
                            <span class="px-2 py-1 text-xs rounded bg-gray-200 text-gray-800"><%= est %></span>
                        <% } %>
                    </td>
                    <td class="px-4 py-2 text-center">
                        <a href="<%=request.getContextPath()%>/student/request-detail?id=<%= sol.getId() %>" class="text-red-600 hover:text-red-800"><i class="fa fa-eye"></i></a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        </div>
    </div>
    <!-- Info card -->
    <div class="mt-8">
        <div class="bg-white shadow rounded p-4">
            <h3 class="text-lg font-semibold mb-2">Información Personal</h3>
            <p><span class="font-medium">Nombre:</span> <%= student.getNombreCompleto() %></p>
            <p><span class="font-medium">Correo:</span> <%= student.getEmail() %></p>
            <p><span class="font-medium">Programa ID:</span> <%= student.getProgramaId() != null ? student.getProgramaId() : "-" %></p>
        </div>
    </div>
</main>
</body>
</html>