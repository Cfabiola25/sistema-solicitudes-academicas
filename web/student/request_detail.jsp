<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="model.SolicitudMensaje" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - Sistema de Solicitudes</title>

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

<jsp:include page="/components/student_sidebar.jsp">
    <jsp:param name="activePage" value="requests" />
</jsp:include>

<main class="flex-1 ml-[220px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div class="flex items-center gap-4">
            <a href="<%=request.getContextPath()%>/student/requests"
               class="hover:text-[#c8102e] transition-colors flex items-center gap-2 text-sm font-semibold text-gray-500">
                <i class="fa-solid fa-arrow-left"></i>
                Volver
            </a>
        </div>

        <div class="flex items-center gap-4">
            <% if ("Pendiente".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-amber-50 text-amber-600 border border-amber-100">
                    <i class="fa-solid fa-clock mr-1"></i> Pendiente
                </span>
            <% } else if ("Aprobada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-green-50 text-green-600 border border-green-100">
                    <i class="fa-solid fa-check mr-1"></i> Aprobada
                </span>
            <% } else if ("Rechazada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-red-50 text-red-600 border border-red-100">
                    <i class="fa-solid fa-xmark mr-1"></i> Rechazada
                </span>
            <% } else { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-blue-50 text-blue-600 border border-blue-100">
                    <i class="fa-solid fa-paper-plane mr-1"></i> <%= state %>
                </span>
            <% } %>
        </div>
    </header>

    <div class="p-8 flex-1 flex flex-col">
        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6 flex-1">

            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-2xl font-extrabold text-gray-900 mb-6">
                    Solicitud #<%= sol.getId() %>
                </h2>

                <div class="grid grid-cols-2 gap-6 mb-6 pb-6 border-b border-gray-100">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Tipo</p>
                        <p class="text-lg font-bold text-gray-800">
                            <%= sol.getTipo().getNombre() %>
                        </p>
                    </div>

                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Fecha de envío</p>
                        <p class="text-lg font-bold text-gray-800">
                            <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "-" %>
                        </p>
                    </div>
                </div>

                <div class="mb-6 pb-6 border-b border-gray-100">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-2">Descripción</p>
                    <p class="text-sm text-gray-700 leading-relaxed">
                        <%= sol.getDescripcion() %>
                    </p>
                </div>

                <% if (sol.getDocumento() != null && !sol.getDocumento().isEmpty()) { %>
                    <div class="mb-6 pb-6 border-b border-gray-100">
                        <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-3">
                            Documento adjunto
                        </p>

                        <a href="<%=request.getContextPath()%>/<%= sol.getDocumento() %>"
                           target="_blank"
                           class="inline-flex items-center gap-3 p-3 rounded-xl border border-gray-200 hover:border-[#c8102e] hover:bg-red-50 transition-colors group">

                            <div class="w-10 h-10 rounded-lg bg-red-100 flex items-center justify-center text-[#c8102e]">
                                <i class="fa-solid fa-file"></i>
                            </div>

                            <p class="text-sm font-bold text-gray-800">
                                Ver documento adjunto
                            </p>
                        </a>
                    </div>
                <% } %>

                <div>
                    <h3 class="text-lg font-bold text-gray-800 mb-4">
                        <i class="fa-solid fa-comments text-[#c8102e] mr-2"></i>
                        Conversación
                    </h3>

                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null && !error.trim().isEmpty()) { %>
                        <div class="mb-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <i class="fa-solid fa-triangle-exclamation mr-2"></i><%= error %>
                        </div>
                    <% } %>

                    <div class="bg-gray-50 rounded-xl p-4 space-y-4 mb-4 max-h-96 overflow-y-auto">
                        <% if (mensajes.isEmpty()) { %>
                            <p class="text-center text-sm text-gray-400 py-8">
                                Aún no hay mensajes. El administrador responderá próximamente.
                            </p>
                        <% } %>

                        <% for (SolicitudMensaje msg : mensajes) { %>
                            <% boolean isStudent = "student".equals(msg.getAutorRol()); %>

                            <div class="flex <%= isStudent ? "justify-end" : "justify-start" %>">
                                <div class="max-w-xs rounded-xl p-3 <%= isStudent ? "bg-[#c8102e] text-white rounded-tr-none" : "bg-white border border-gray-200 rounded-tl-none" %>">

                                    <p class="text-xs font-semibold mb-1 <%= isStudent ? "" : "text-gray-600" %>">
                                        <%= isStudent ? "Tú" : "Administrador" %>
                                    </p>

                                    <% if (msg.getMensaje() != null && !msg.getMensaje().trim().isEmpty()) { %>
                                        <p class="text-sm <%= isStudent ? "" : "text-gray-700" %>">
                                            <%= msg.getMensaje() %>
                                        </p>
                                    <% } %>

                                    <% if (msg.getArchivo() != null && !msg.getArchivo().isEmpty()) { %>
                                        <a href="<%=request.getContextPath()%>/<%= msg.getArchivo() %>"
                                           target="_blank"
                                           class="mt-2 inline-flex items-center gap-2 text-[11px] underline font-semibold <%= isStudent ? "opacity-90 hover:opacity-100" : "text-[#c8102e] hover:text-red-800" %>">
                                            <i class="fa-solid fa-paperclip"></i>
                                            Ver archivo adjunto
                                        </a>
                                    <% } %>

                                    <% if (msg.getFechaEnvio() != null) { %>
                                        <p class="text-[10px] mt-2 <%= isStudent ? "opacity-70" : "text-gray-400" %>">
                                            <%= msg.getFechaEnvio().toLocalTime().toString().substring(0, 5) %>
                                        </p>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <form action="<%=request.getContextPath()%>/student/request-detail"
                          method="post"
                          enctype="multipart/form-data"
                          class="flex flex-col gap-3">

                        <input type="hidden" name="id" value="<%= sol.getId() %>" />

                        <div class="flex gap-3">
                            <input type="text"
                                   name="mensaje"
                                   placeholder="Escribe tu mensaje..."
                                   maxlength="500"
                                   class="flex-1 px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50" />

                            <button type="submit"
                                    class="px-4 py-2 bg-[#c8102e] text-white rounded-xl font-semibold hover:bg-red-700 transition-colors flex items-center gap-2">
                                <i class="fa-solid fa-paper-plane"></i>
                            </button>
                        </div>

                        <div>
                            <label class="block text-[11px] font-bold text-gray-400 uppercase tracking-wide mb-2">
                                Adjuntar archivo
                            </label>

                            <div id="messageDropzone" class="border-2 border-dashed border-gray-200 rounded-2xl p-5 text-center cursor-pointer hover:border-[#c8102e] hover:bg-red-50/50 transition-all duration-200 bg-white">
                                <i class="fa-solid fa-cloud-arrow-up text-[#c8102e] text-2xl mb-2"></i>
                                <p class="text-sm font-semibold text-gray-700">Arrastra un archivo o haz clic aquí</p>
                                <p class="text-xs text-gray-400 mt-1">Soportado: PDF</p>
                                <p id="messageFileLabel" class="text-xs font-semibold text-[#c8102e] mt-3 hidden"></p>
                            </div>

                            <input type="file"
                                   name="archivo"
                                   id="messageFileInput"
                                   accept=".pdf"
                                   class="hidden">
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</main>

<script>
    (function () {
        const dropzone = document.getElementById('messageDropzone');
        const fileInput = document.getElementById('messageFileInput');
        const fileLabel = document.getElementById('messageFileLabel');

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