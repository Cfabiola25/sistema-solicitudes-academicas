<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Solicitud" %>
<%@ page import="model.SolicitudMensaje" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - FESC Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous"
          referrerpolicy="no-referrer" />

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }

        .nav-link.active {
            background: #c8102e;
            color: white !important;
            border-radius: 10px;
        }

        .nav-link.active i { color: white !important; }

        .nav-link:hover:not(.active) {
            background: #f4f5f7;
            border-radius: 10px;
        }

        ::-webkit-scrollbar { width: 5px; height: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 9999px; }
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Solicitud sol = (Solicitud) request.getAttribute("solicitud");

    List<SolicitudMensaje> mensajes = (List<SolicitudMensaje>) request.getAttribute("mensajes");
    if (mensajes == null) {
        mensajes = new ArrayList<SolicitudMensaje>();
    }

    String state = sol != null ? sol.getEstado() : "";
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="requests" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div class="flex items-center gap-4 text-sm font-semibold text-gray-500">
            <a href="<%=request.getContextPath()%>/admin/requests"
               class="hover:text-[#c8102e] transition-colors flex items-center gap-2">
                <i class="fa-solid fa-arrow-left"></i>
                Volver a Solicitudes
            </a>
        </div>

        <div class="flex items-center gap-4">
            <div class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-sm"></i>
            </div>
        </div>
    </header>

    <div class="p-8 flex-1">

        <% String errorMessage = (String) request.getAttribute("error"); %>
        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="mb-6 rounded-2xl bg-red-50 border border-red-100 px-5 py-4 text-sm text-red-700 font-semibold">
                <i class="fa-solid fa-triangle-exclamation mr-2"></i>
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="flex items-start justify-between mb-6">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">
                    Detalle de Solicitud #<%= sol.getId() %>
                </h1>
                <p class="text-sm text-gray-400 mt-1">
                    Revisión, conversación y respuesta administrativa.
                </p>
            </div>

            <% if ("Pendiente".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-amber-50 text-amber-600 border border-amber-100 flex items-center gap-2 shadow-sm">
                    <i class="fa-solid fa-clock"></i> Pendiente
                </span>
            <% } else if ("Aprobada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-green-50 text-green-600 border border-green-100 flex items-center gap-2 shadow-sm">
                    <i class="fa-solid fa-check"></i> Aprobada
                </span>
            <% } else if ("Rechazada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-red-50 text-red-600 border border-red-100 flex items-center gap-2 shadow-sm">
                    <i class="fa-solid fa-xmark"></i> Rechazada
                </span>
            <% } else if ("Anulada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-gray-100 text-gray-600 border border-gray-200 flex items-center gap-2 shadow-sm">
                    <i class="fa-solid fa-ban"></i> Anulada
                </span>
            <% } else { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-blue-50 text-blue-600 border border-blue-100 flex items-center gap-2 shadow-sm">
                    <i class="fa-solid fa-paper-plane"></i> <%= state %>
                </span>
            <% } %>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

            <div class="lg:col-span-2 space-y-6">

                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4 border-b border-gray-50 pb-3">
                        <i class="fa-regular fa-file-lines text-gray-400 mr-2"></i>
                        Información General
                    </h3>

                    <div class="grid grid-cols-2 gap-y-4 text-sm">
                        <div>
                            <p class="text-gray-400 font-semibold mb-1 text-xs uppercase tracking-wide">
                                Tipo de Solicitud
                            </p>
                            <p class="font-bold text-gray-800">
                                <%= sol.getTipo().getNombre() %>
                            </p>
                        </div>

                        <div>
                            <p class="text-gray-400 font-semibold mb-1 text-xs uppercase tracking-wide">
                                Fecha de Envío
                            </p>
                            <p class="font-bold text-gray-800">
                                <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "-" %>
                            </p>
                        </div>

                        <div class="col-span-2 mt-2">
                            <p class="text-gray-400 font-semibold mb-1 text-xs uppercase tracking-wide">
                                Estudiante
                            </p>

                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center border border-gray-100">
                                    <i class="fa-solid fa-user text-gray-400"></i>
                                </div>

                                <div>
                                    <p class="font-bold text-gray-800">
                                        <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4 border-b border-gray-50 pb-3">
                        <i class="fa-solid fa-align-left text-gray-400 mr-2"></i>
                        Descripción Detallada
                    </h3>

                    <div class="bg-gray-50 rounded-xl p-4 text-sm text-gray-700 leading-relaxed border border-gray-100">
                        <%= sol.getDescripcion() %>
                    </div>

                    <div class="mt-6">
                        <h4 class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3">
                            Documentos Adjuntos
                        </h4>

                        <% if (sol.getDocumento() != null && !sol.getDocumento().isEmpty()) { %>
                            <a href="<%=request.getContextPath()%>/<%= sol.getDocumento() %>"
                               target="_blank"
                               class="inline-flex items-center gap-3 p-3 rounded-xl border border-gray-200 hover:border-[#c8102e] hover:bg-red-50 transition-colors group">

                                <div class="w-10 h-10 rounded-lg bg-red-100 flex items-center justify-center text-[#c8102e] group-hover:bg-[#c8102e] group-hover:text-white transition-colors">
                                    <i class="fa-solid fa-file"></i>
                                </div>

                                <div>
                                    <p class="text-sm font-bold text-gray-800 group-hover:text-[#c8102e] transition-colors">
                                        Ver documento adjunto
                                    </p>
                                    <p class="text-xs text-gray-400">
                                        Clic para abrir en nueva pestaña
                                    </p>
                                </div>
                            </a>
                        <% } else { %>
                            <div class="flex items-center gap-3 p-3 rounded-xl border border-dashed border-gray-200 bg-gray-50">
                                <div class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center text-gray-400">
                                    <i class="fa-solid fa-file-circle-xmark"></i>
                                </div>

                                <p class="text-sm font-semibold text-gray-500">
                                    No hay documentos adjuntos para esta solicitud.
                                </p>
                            </div>
                        <% } %>
                    </div>
                </div>

            </div>

            <div class="flex flex-col gap-6">

                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4">
                        <i class="fa-solid fa-comments text-[#c8102e] mr-2"></i>
                        Conversación con el estudiante
                    </h3>

                    <div class="bg-gray-50 rounded-xl p-4 space-y-3 mb-4 max-h-80 overflow-y-auto">
                        <% if (mensajes.isEmpty()) { %>
                            <p class="text-center text-sm text-gray-400 py-8">
                                Sin mensajes aún. Inicia la conversación.
                            </p>
                        <% } %>

                        <% for (SolicitudMensaje msg : mensajes) { %>
                            <% boolean isStudent = "student".equals(msg.getAutorRol()); %>

                            <div class="flex <%= isStudent ? "justify-end" : "justify-start" %>">
                                <div class="max-w-xs rounded-xl p-2.5 <%= isStudent ? "bg-blue-100 text-blue-900 rounded-tr-none" : "bg-[#c8102e] text-white rounded-tl-none" %>">

                                    <p class="text-xs font-semibold mb-1">
                                        <%= isStudent ? "Estudiante" : "Tú (Admin)" %>
                                    </p>

                                    <% if (msg.getMensaje() != null && !msg.getMensaje().trim().isEmpty()) { %>
                                        <p class="text-sm">
                                            <%= msg.getMensaje() %>
                                        </p>
                                    <% } %>

                                    <% if (msg.getArchivo() != null && !msg.getArchivo().isEmpty()) { %>
                                        <a href="<%=request.getContextPath()%>/<%= msg.getArchivo() %>"
                                           target="_blank"
                                           class="mt-2 inline-flex items-center gap-2 text-[11px] underline font-semibold opacity-90 hover:opacity-100">
                                            <i class="fa-solid fa-paperclip"></i>
                                            Ver archivo adjunto
                                        </a>
                                    <% } %>

                                    <% if (msg.getFechaEnvio() != null) { %>
                                        <p class="text-[10px] mt-1 opacity-70">
                                            <%= msg.getFechaEnvio().toLocalTime().toString().substring(0, 5) %>
                                        </p>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <form action="<%=request.getContextPath()%>/admin/request-detail"
                          method="post"
                          enctype="multipart/form-data"
                          class="flex flex-col gap-3 mb-4">

                        <input type="hidden" name="id" value="<%= sol.getId() %>" />
                        <input type="hidden" name="action" value="message" />

                        <div class="flex gap-2">
                            <input type="text"
                                   name="comentario"
                                   placeholder="Responde al estudiante..."
                                   maxlength="500"
                                   class="flex-1 px-3 py-2 bg-gray-50 border border-gray-100 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50" />

                            <button type="submit"
                                    class="px-4 py-2 bg-[#c8102e]/10 text-[#c8102e] rounded-lg font-semibold hover:bg-[#c8102e]/20 transition-colors">
                                <i class="fa-solid fa-paper-plane"></i>
                            </button>
                        </div>

                        <div>
                            <label class="block text-[11px] font-bold text-gray-400 uppercase tracking-wide mb-2">
                                Adjuntar archivo
                            </label>

                            <div id="adminChatDropzone" class="border-2 border-dashed border-gray-200 rounded-2xl p-5 text-center cursor-pointer hover:border-[#c8102e] hover:bg-red-50/50 transition-all duration-200 bg-white">
                                <i class="fa-solid fa-cloud-arrow-up text-[#c8102e] text-2xl mb-2"></i>
                                <p class="text-sm font-semibold text-gray-700">Arrastra un archivo o haz clic aquí</p>
                                <p class="text-xs text-gray-400 mt-1">Soportado: PDF, DOCX, JPG, JPEG, PNG y WEBP</p>
                                <p id="adminChatFileLabel" class="text-xs font-semibold text-[#c8102e] mt-3 hidden"></p>
                            </div>

                            <input type="file"
                                   name="archivo"
                                   id="adminChatFileInput"
                                   accept=".pdf,.docx,.jpg,.jpeg,.png,.webp"
                                   class="hidden">
                        </div>
                    </form>
                </div>

                <% if (!"Aprobada".equals(sol.getEstado()) && !"Rechazada".equals(sol.getEstado()) && !"Anulada".equals(sol.getEstado())) { %>
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                        <h3 class="font-bold text-gray-800 mb-4">
                            <i class="fa-solid fa-gavel text-[#c8102e] mr-2"></i>
                            Resolución
                        </h3>

                        <form action="<%=request.getContextPath()%>/admin/request-detail"
                              method="post"
                              class="flex flex-col gap-4">

                            <input type="hidden" name="id" value="<%= sol.getId() %>" />

                            <div>
                                <label class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">
                                    Comentario final
                                </label>

                                <textarea name="comentario"
                                          rows="3"
                                          placeholder="Explica el motivo de la decisión..."
                                          class="w-full px-3 py-2 bg-gray-50 border border-gray-100 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 resize-none"
                                          required></textarea>
                            </div>

                            <div class="flex flex-col gap-2">
                                <button type="submit"
                                        name="newState"
                                        value="Aprobada"
                                        class="w-full bg-green-500 text-white font-bold py-2 rounded-lg hover:bg-green-600 transition-colors flex justify-center items-center gap-2 text-sm">
                                    <i class="fa-solid fa-check"></i>
                                    Aprobar
                                </button>

                                <button type="submit"
                                        name="newState"
                                        value="Rechazada"
                                        class="w-full bg-white text-[#c8102e] border-2 border-[#c8102e] font-bold py-1.5 rounded-lg hover:bg-red-50 transition-colors flex justify-center items-center gap-2 text-sm">
                                    <i class="fa-solid fa-xmark"></i>
                                    Rechazar
                                </button>

                                <button type="submit"
                                        name="newState"
                                        value="Anulada"
                                        class="w-full bg-gray-100 text-gray-700 border-2 border-gray-200 font-bold py-1.5 rounded-lg hover:bg-gray-200 transition-colors flex justify-center items-center gap-2 text-sm">
                                    <i class="fa-solid fa-ban"></i>
                                    Anular
                                </button>
                            </div>
                        </form>
                    </div>
                <% } %>

            </div>
        </div>
    </div>

    <footer class="px-8 py-4 border-t border-gray-100 bg-white flex items-center justify-between text-[11px] text-gray-400">
        <div class="flex items-center gap-1.5">
            <span class="w-1.5 h-1.5 rounded-full bg-green-500"></span>
            <span class="font-semibold text-gray-500">Estado del Sistema: Operativo</span>
        </div>

        <div class="flex items-center gap-4">
            <a href="#" class="hover:text-gray-600">Política de Privacidad</a>
            <a href="#" class="hover:text-gray-600">Soporte Técnico</a>
        </div>
    </footer>
</main>

<script>
    (function () {
        const dropzone = document.getElementById('adminChatDropzone');
        const fileInput = document.getElementById('adminChatFileInput');
        const fileLabel = document.getElementById('adminChatFileLabel');

        if (!dropzone || !fileInput || !fileLabel) return;

        const updateLabel = () => {
            if (fileInput.files && fileInput.files.length > 0) {
                fileLabel.textContent = fileInput.files[0].name;
                fileLabel.classList.remove('hidden');
            } else {
                fileLabel.textContent = '';
                fileLabel.classList.add('hidden');
            }
        };

        dropzone.addEventListener('click', () => fileInput.click());
        dropzone.addEventListener('dragover', (event) => {
            event.preventDefault();
            dropzone.classList.add('border-[#c8102e]', 'bg-red-50/60');
        });
        dropzone.addEventListener('dragenter', (event) => {
            event.preventDefault();
            dropzone.classList.add('border-[#c8102e]', 'bg-red-50/60');
        });
        dropzone.addEventListener('dragleave', (event) => {
            event.preventDefault();
            dropzone.classList.remove('border-[#c8102e]', 'bg-red-50/60');
        });
        dropzone.addEventListener('drop', (event) => {
            event.preventDefault();
            dropzone.classList.remove('border-[#c8102e]', 'bg-red-50/60');
            if (event.dataTransfer.files.length > 0) {
                fileInput.files = event.dataTransfer.files;
                updateLabel();
            }
        });
        fileInput.addEventListener('change', updateLabel);
    })();
</script>

</body>
</html>