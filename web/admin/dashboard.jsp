<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador - Sistema de Solicitudes</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            <a href="<%=request.getContextPath()%>/admin/dashboard" class="px-4 py-3 flex items-center bg-red-700">
                <i class="fa fa-tachometer-alt mr-3"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests" class="px-4 py-3 flex items-center hover:bg-red-700">
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
    <h1 class="text-2xl font-bold mb-4">Panel de Administrador</h1>
    <%
        Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
        Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
        List<Solicitud> pending = (List<Solicitud>) request.getAttribute("pending");
        int total = 0;
        for (Integer v : counts.values()) total += v;
    %>
    <!-- Stats -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-white shadow rounded p-4">
            <p class="text-gray-500 text-sm">Total solicitudes</p>
            <p class="text-3xl font-bold"><%= total %></p>
        </div>
        <div class="bg-white shadow rounded p-4">
            <p class="text-gray-500 text-sm">Pendientes</p>
            <p class="text-3xl font-bold"><%= counts.getOrDefault("Pendiente", 0) %></p>
        </div>
        <div class="bg-white shadow rounded p-4">
            <p class="text-gray-500 text-sm">Aprobadas</p>
            <p class="text-3xl font-bold"><%= counts.getOrDefault("Aprobada", 0) %></p>
        </div>
        <div class="bg-white shadow rounded p-4">
            <p class="text-gray-500 text-sm">Rechazadas</p>
            <p class="text-3xl font-bold"><%= counts.getOrDefault("Rechazada", 0) %></p>
        </div>
    </div>
    <!-- Charts and system info -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="md:col-span-2 bg-white shadow rounded p-6">
            <h3 class="text-lg font-semibold mb-4">Rendimiento mensual (aprobadas)</h3>
            <canvas id="monthlyChart" width="400" height="200"></canvas>
        </div>
        <div class="bg-white shadow rounded p-6">
            <h3 class="text-lg font-semibold mb-4">Estado del sistema</h3>
            <p class="text-5xl text-green-600 font-bold text-center">Activo</p>
            <p class="text-center text-gray-600 mt-2">El sistema funciona correctamente.</p>
        </div>
    </div>
    <!-- Pending requests -->
    <div class="mt-8 bg-white shadow rounded p-6">
        <h3 class="text-lg font-semibold mb-4">Solicitudes pendientes</h3>
        <div class="overflow-x-auto">
        <table class="min-w-full text-sm">
            <thead>
            <tr class="bg-gray-50">
                <th class="px-4 py-2 text-left">ID</th>
                <th class="px-4 py-2 text-left">Estudiante</th>
                <th class="px-4 py-2 text-left">Tipo</th>
                <th class="px-4 py-2 text-left">Fecha</th>
                <th class="px-4 py-2 text-center">Acción</th>
            </tr>
            </thead>
            <tbody>
            <% for (Solicitud sol : pending) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%= sol.getId() %></td>
                    <td class="px-4 py-2"><%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></td>
                    <td class="px-4 py-2"><%= sol.getTipo().getNombre() %></td>
                    <td class="px-4 py-2"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
                    <td class="px-4 py-2 text-center">
                        <a href="<%=request.getContextPath()%>/admin/request-detail?id=<%= sol.getId() %>" class="text-red-600 hover:text-red-800"><i class="fa fa-eye"></i></a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        </div>
    </div>
    <script>
        // prepare data for Chart.js from JSP map
        const ctx = document.getElementById('monthlyChart').getContext('2d');
        const labels = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
        const dataCounts = [
            <%= monthly.getOrDefault(1, 0) %>,
            <%= monthly.getOrDefault(2, 0) %>,
            <%= monthly.getOrDefault(3, 0) %>,
            <%= monthly.getOrDefault(4, 0) %>,
            <%= monthly.getOrDefault(5, 0) %>,
            <%= monthly.getOrDefault(6, 0) %>,
            <%= monthly.getOrDefault(7, 0) %>,
            <%= monthly.getOrDefault(8, 0) %>,
            <%= monthly.getOrDefault(9, 0) %>,
            <%= monthly.getOrDefault(10, 0) %>,
            <%= monthly.getOrDefault(11, 0) %>,
            <%= monthly.getOrDefault(12, 0) %>
        ];
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Aprobadas',
                    data: dataCounts,
                    backgroundColor: 'rgba(220,38,38,0.6)',
                    borderColor: 'rgb(220,38,38)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</main>
</body>
</html>