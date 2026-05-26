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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .nav-link.active { background: #c8102e; color: white !important; border-radius: 10px; }
        .nav-link.active i { color: white !important; }
        .nav-link:hover:not(.active) { background: #f4f5f7; border-radius: 10px; }
        ::-webkit-scrollbar { width: 5px; height: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 9999px; }
    </style>
</head>
<body class="bg-[#f4f5f7] min-h-screen flex">
<%
    List<TipoSolicitud> tipos = (List<TipoSolicitud>) request.getAttribute("tipos");
    if (tipos == null) tipos = new ArrayList<TipoSolicitud>();
%>
<jsp:include page="/components/student_sidebar.jsp">
    <jsp:param name="activePage" value="new-request" />
</jsp:include>

<main class="flex-1 ml-[220px] min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">Crear solicitud</p>
            <h1 class="text-lg font-extrabold text-gray-900">Nueva solicitud académica</h1>
        </div>
        <div class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
            <i class="fa-solid fa-plus text-[#c8102e] text-sm"></i>
        </div>
    </header>

    <div class="p-8 flex-1">
        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-2xl font-extrabold text-gray-900 mb-6">Formulario de solicitud</h2>
                
                <form action="<%=request.getContextPath()%>/student/new-request" method="post" enctype="multipart/form-data" class="space-y-6">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2">Tipo de solicitud *</label>
                        <select name="tipo" required class="w-full px-4 py-3 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 cursor-pointer">
                            <option value="">Selecciona un tipo</option>
                            <% for (TipoSolicitud t : tipos) { %>
                                <option value="<%= t.getId() %>"><%= t.getNombre() %></option>
                            <% } %>
                        </select>
                        <p class="text-xs text-gray-400 mt-1.5">Elige el tipo de solicitud que necesitas presentar.</p>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2">Descripción detallada *</label>
                        <textarea name="descripcion" rows="5" required placeholder="Explica en detalle el motivo de tu solicitud..."
                                  class="w-full px-4 py-3 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 resize-none"></textarea>
                        <p class="text-xs text-gray-400 mt-1.5">Sé claro y específico para facilitar la revisión.</p>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2">Documento adjunto</label>
                        <div class="border-2 border-dashed border-gray-200 rounded-lg p-6 text-center cursor-pointer hover:border-[#c8102e] hover:bg-red-50/50 transition-colors" onclick="document.getElementById('fileInput').click();">
                            <i class="fa-solid fa-cloud-arrow-up text-[#c8102e] text-3xl mb-2"></i>
                            <p class="text-sm font-semibold text-gray-700">Arrastra un archivo o haz clic aquí</p>
                            <p class="text-xs text-gray-400 mt-1">Soportado: PDF, máx 10 MB</p>
                        </div>
                        <input type="file" name="documento" id="fileInput" class="hidden" accept=".pdf" />
                    </div>

                    <div class="flex gap-3 pt-4">
                        <button type="submit" class="flex-1 bg-[#c8102e] text-white font-bold py-3 rounded-lg hover:bg-red-700 transition-colors flex items-center justify-center gap-2 shadow-sm shadow-red-600/20">
                            <i class="fa-solid fa-paper-plane"></i> Enviar solicitud
                        </button>
                        <a href="<%=request.getContextPath()%>/student/requests" class="flex-1 bg-white border-2 border-gray-200 text-gray-700 font-bold py-3 rounded-lg hover:bg-gray-50 transition-colors flex items-center justify-center gap-2">
                            <i class="fa-solid fa-xmark"></i> Cancelar
                        </a>
                    </div>
                </form>
            </div>

            <div class="space-y-6">
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h3 class="text-lg font-bold text-gray-900 mb-4"><i class="fa-solid fa-circle-info text-[#c8102e] mr-2"></i> Información importante</h3>
                    <ul class="space-y-3 text-sm text-gray-600">
                        <li class="flex gap-2"><i class="fa-solid fa-check text-green-500 mt-0.5 flex-shrink-0"></i><span>Revisa los requisitos del tipo de solicitud seleccionado.</span></li>
                        <li class="flex gap-2"><i class="fa-solid fa-check text-green-500 mt-0.5 flex-shrink-0"></i><span>Adjunta documentos en formato PDF.</span></li>
                        <li class="flex gap-2"><i class="fa-solid fa-check text-green-500 mt-0.5 flex-shrink-0"></i><span>Verifica que la información esté completa y correcta.</span></li>
                        <li class="flex gap-2"><i class="fa-solid fa-check text-green-500 mt-0.5 flex-shrink-0"></i><span>Tiempo estimado de respuesta: 3-5 días hábiles.</span></li>
                    </ul>
                </div>

                <div class="bg-[#c8102e] rounded-2xl p-6 text-white shadow-lg shadow-red-500/10">
                    <h3 class="text-lg font-bold mb-3">¿Dudas?</h3>
                    <p class="text-sm text-white/80 mb-4">Puedes comunicarte con el administrador directamente desde el detalle de tu solicitud una vez que la envíes.</p>
                    <p class="text-xs text-white/60">El sistema incluye un hilo de mensajes para mantener la comunicación en un solo lugar.</p>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
