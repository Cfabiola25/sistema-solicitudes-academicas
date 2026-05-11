<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - Panel de Administrador</title>
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
    <h1 class="text-2xl font-bold mb-4">Detalle de solicitud</h1>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <% Solicitud sol = (Solicitud) request.getAttribute("solicitud"); %>
        <!-- Details section -->
        <div class="md:col-span-2 bg-white shadow rounded p-6 space-y-4">
            <div>
                <h3 class="text-lg font-semibold">Información de la solicitud</h3>
                <p><span class="font-medium">ID:</span> <%= sol.getId() %></p>
                <p><span class="font-medium">Tipo:</span> <%= sol.getTipo().getNombre() %></p>
                <p><span class="font-medium">Fecha de solicitud:</span> <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></p>
                <p><span class="font-medium">Estado actual:</span> <%= sol.getEstado() %></p>
            </div>
            <div>
                <h3 class="text-lg font-semibold">Estudiante</h3>
                <p><span class="font-medium">Nombre:</span> <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></p>
            </div>
            <div>
                <h3 class="text-lg font-semibold">Descripción</h3>
                <p class="text-gray-700"><%= sol.getDescripcion() %></p>
            </div>
            <div>
                <h3 class="text-lg font-semibold">Documento adjunto</h3>
                <% if (sol.getDocumento() != null && !sol.getDocumento().isEmpty()) { %>
                    <a href="<%=request.getContextPath()%>/<%= sol.getDocumento() %>" target="_blank" class="text-red-600 hover:underline"><i class="fa fa-file-pdf mr-2"></i>Ver documento</a>
                <% } else { %>
                    <p class="text-gray-500">No hay documento adjunto.</p>
                <% } %>
            </div>
            <% if (sol.getFechaRespuesta() != null) { %>
                <div>
                    <h3 class="text-lg font-semibold">Respuesta previa</h3>
                    <p><span class="font-medium">Fecha:</span> <%= sol.getFechaRespuesta().toLocalDate().toString() %></p>
                    <p><span class="font-medium">Comentario:</span> <%= sol.getComentarioRespuesta() %></p>
                </div>
            <% } %>
        </div>
        <!-- Action section -->
        <div class="bg-white shadow rounded p-6">
            <h3 class="text-lg font-semibold mb-4">Responder solicitud</h3>
            <form action="<%=request.getContextPath()%>/admin/request-detail" method="post" class="space-y-4">
                <input type="hidden" name="id" value="<%= sol.getId() %>" />
                <div>
                    <label class="block text-gray-700">Comentario</label>
                    <textarea name="comentario" rows="4" class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500" required></textarea>
                </div>
                <div class="flex justify-between">
                    <button type="submit" name="newState" value="Aprobada" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 flex-1 mr-2">Aprobar</button>
                    <button type="submit" name="newState" value="Rechazada" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 flex-1 ml-2">Rechazar</button>
                </div>
            </form>
        </div>
    </div>
</main>
</body>
</html>