<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Solicitud</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#f4f5f7] min-h-screen p-8">

<%
    Solicitud solicitud = (Solicitud) request.getAttribute("solicitud");
    String error = (String) request.getAttribute("error");
%>

<div class="max-w-3xl mx-auto bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
    <h1 class="text-2xl font-extrabold text-gray-900 mb-2">Editar solicitud</h1>
    <p class="text-sm text-gray-400 mb-6">
        Solo puedes editar solicitudes en estado Enviada o Pendiente.
    </p>

    <% if (error != null) { %>
        <div class="mb-5 rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 font-semibold">
            <%= error %>
        </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/student/edit-request" method="post" enctype="multipart/form-data" class="space-y-5">
        <input type="hidden" name="id" value="<%= solicitud.getId() %>">

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Tipo de solicitud</label>
            <input type="text"
                   value="<%= solicitud.getTipo() != null ? solicitud.getTipo().getNombre() : "" %>"
                   readonly
                   class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-500">
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Descripción</label>
            <textarea name="descripcion"
                      rows="6"
                      required
                      class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/40"><%= solicitud.getDescripcion() != null ? solicitud.getDescripcion() : "" %></textarea>
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Documento actual</label>

            <% if (solicitud.getDocumento() != null && !solicitud.getDocumento().isEmpty()) { %>
                <a href="<%=request.getContextPath()%>/<%= solicitud.getDocumento() %>"
                   target="_blank"
                   class="inline-flex items-center gap-2 text-sm font-semibold text-[#c8102e] hover:underline">
                    Ver documento actual
                </a>
            <% } else { %>
                <p class="text-sm text-gray-400">Esta solicitud no tiene documento adjunto.</p>
            <% } %>
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Cambiar documento</label>
            <input type="file"
                   name="documento"
                   class="w-full rounded-xl border border-gray-200 bg-white px-4 py-3 text-sm">
            <p class="text-xs text-gray-400 mt-2">
                Si no seleccionas un archivo nuevo, se conservará el documento actual.
            </p>
        </div>

        <div class="flex items-center justify-between pt-4">
            <a href="<%=request.getContextPath()%>/student/requests"
               class="rounded-xl border border-gray-200 px-5 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-50">
                Cancelar
            </a>

            <button type="submit"
                    class="rounded-xl bg-[#c8102e] px-5 py-2.5 text-sm font-bold text-white hover:bg-red-700">
                Guardar cambios
            </button>
        </div>
    </form>
</div>

</body>
</html>