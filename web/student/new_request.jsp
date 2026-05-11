<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.TipoSolicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Solicitud - Sistema de Solicitudes</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex">
<%
    HttpSession sess = request.getSession(false);
%>
<!-- Sidebar same as dashboard -->
<aside class="w-60 bg-red-600 text-white flex flex-col justify-between">
    <div>
        <h2 class="text-xl font-bold p-4 border-b border-red-700">FESC</h2>
        <nav class="mt-4 flex flex-col">
            <a href="<%=request.getContextPath()%>/student/dashboard" class="px-4 py-3 flex items-center hover:bg-red-700">
                <i class="fa fa-home mr-3"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/student/new-request" class="px-4 py-3 flex items-center bg-red-700">
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
    <h1 class="text-2xl font-bold mb-4">Crear nueva solicitud</h1>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Form section -->
        <div class="md:col-span-2 bg-white shadow rounded p-6">
            <form action="<%=request.getContextPath()%>/student/new-request" method="post" enctype="multipart/form-data" class="space-y-4">
                <div>
                    <label class="block text-gray-700">Tipo de solicitud</label>
                    <select name="tipo" required class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500">
                        <option value="">Seleccione</option>
                        <% List<TipoSolicitud> tipos = (List<TipoSolicitud>) request.getAttribute("tipos");
                           for (TipoSolicitud t : tipos) { %>
                            <option value="<%= t.getId() %>"><%= t.getNombre() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-gray-700">Descripción</label>
                    <textarea name="descripcion" rows="4" required class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-red-500"></textarea>
                </div>
                <div>
                    <label class="block text-gray-700">Documento adjunto (opcional)</label>
                    <input type="file" name="documento" class="w-full" />
                </div>
                <button type="submit" class="bg-red-600 text-white px-6 py-2 rounded hover:bg-red-700">Enviar solicitud</button>
            </form>
        </div>
        <!-- Sidebar info -->
        <div class="bg-white shadow rounded p-6">
            <h3 class="text-lg font-semibold mb-3">Tiempo estimado</h3>
            <p class="text-4xl font-bold text-red-600">3-5 días</p>
            <hr class="my-4">
            <h3 class="text-lg font-semibold mb-2">Requisitos previos</h3>
            <ul class="list-disc list-inside text-gray-700 text-sm">
                <li>Revisar los requisitos del tipo de solicitud seleccionado.</li>
                <li>Adjuntar documentos en formato PDF.</li>
                <li>Verificar que la información esté completa y correcta.</li>
            </ul>
        </div>
    </div>
</main>
</body>
</html>