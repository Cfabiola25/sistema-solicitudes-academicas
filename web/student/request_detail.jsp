<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - Sistema de Solicitudes</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex">
<!-- Sidebar -->
<aside class="w-60 bg-red-600 text-white flex flex-col justify-between">
    <div>
        <h2 class="text-xl font-bold p-4 border-b border-red-700">FESC</h2>
        <nav class="mt-4 flex flex-col">
            <a href="<%=request.getContextPath()%>/student/dashboard" class="px-4 py-3 flex items-center hover:bg-red-700">
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
    <h1 class="text-2xl font-bold mb-4">Detalle de solicitud</h1>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <% Solicitud sol = (Solicitud) request.getAttribute("solicitud"); %>
        <!-- Details -->
        <div class="md:col-span-2 bg-white shadow rounded p-6 space-y-4">
            <div>
                <h3 class="text-lg font-semibold">Información general</h3>
                <p><span class="font-medium">ID:</span> <%= sol.getId() %></p>
                <p><span class="font-medium">Tipo:</span> <%= sol.getTipo().getNombre() %></p>
                <p><span class="font-medium">Fecha de solicitud:</span> <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></p>
                <p><span class="font-medium">Estado:</span>
                    <% String st = sol.getEstado(); %>
                    <% if ("Pendiente".equals(st)) { %>
                        <span class="px-2 py-1 text-xs rounded bg-yellow-200 text-yellow-800"><%= st %></span>
                    <% } else if ("Aprobada".equals(st)) { %>
                        <span class="px-2 py-1 text-xs rounded bg-green-200 text-green-800"><%= st %></span>
                    <% } else if ("Rechazada".equals(st)) { %>
                        <span class="px-2 py-1 text-xs rounded bg-red-200 text-red-800"><%= st %></span>
                    <% } else { %>
                        <span class="px-2 py-1 text-xs rounded bg-gray-200 text-gray-800"><%= st %></span>
                    <% } %>
                </p>
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
                <h3 class="text-lg font-semibold">Respuesta del administrador</h3>
                <p><span class="font-medium">Fecha de respuesta:</span> <%= sol.getFechaRespuesta().toLocalDate().toString() %></p>
                <p><span class="font-medium">Comentario:</span> <%= sol.getComentarioRespuesta() %></p>
                <% if (sol.getAdministrador() != null) { %>
                    <p><span class="font-medium">Atendido por:</span> <%= sol.getAdministrador().getNombre() %> (<%= sol.getAdministrador().getEmail() %>)</p>
                <% } %>
            </div>
            <% } %>
        </div>
        <!-- Timeline or status -->
        <div class="bg-white shadow rounded p-6">
            <h3 class="text-lg font-semibold mb-4">Historial</h3>
            <ul class="relative border-l-2 border-red-600 pl-4">
                <li class="mb-6">
                    <span class="absolute -left-2 top-0 w-4 h-4 bg-red-600 rounded-full"></span>
                    <p class="font-medium">Solicitud enviada</p>
                    <p class="text-sm text-gray-600"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></p>
                </li>
                <% if (sol.getFechaRespuesta() != null) { %>
                <li>
                    <span class="absolute -left-2 top-0 w-4 h-4 bg-red-600 rounded-full"></span>
                    <p class="font-medium">Respuesta</p>
                    <p class="text-sm text-gray-600"><%= sol.getFechaRespuesta().toLocalDate().toString() %> - <%= sol.getEstado() %></p>
                </li>
                <% } else { %>
                <li>
                    <span class="absolute -left-2 top-0 w-4 h-4 bg-yellow-400 rounded-full animate-pulse"></span>
                    <p class="font-medium">En proceso</p>
                    <p class="text-sm text-gray-600">Tu solicitud está siendo revisada.</p>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</main>
</body>
</html>