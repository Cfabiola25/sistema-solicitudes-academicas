<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Solicitud, model.SolicitudMensaje" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - FESC Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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

<!-- ───────── SIDEBAR ───────── -->
<aside class="w-[210px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png" alt="FESC Logo"
                class="h-10 object-contain"
                onerror="this.outerHTML='<div class=\'flex items-center gap-2\'><div class=\'w-8 h-8 rounded-lg bg-[#c8102e] flex items-center justify-center\'><i class=\'fa-solid fa-graduation-cap text-white text-sm\'></i></div><span class=\'font-extrabold text-[#c8102e] text-lg tracking-tight\'>FESC Gestión</span></div>'">
        </div>

        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-xs"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">Administración</p>
                <p class="text-[10px] text-gray-400 mt-0.5">Panel Central</p>
            </div>
        </div>

        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-400 transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests"
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i> Solicitudes
            </a>
            <a href="<%=request.getContextPath()%>/admin/students"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center text-gray-400"></i> Estudiantes
            </a>
            <a href="<%=request.getContextPath()%>/admin/reports"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center text-gray-400"></i> Reportes
            </a>
        </nav>
    </div>

    <a href="<%=request.getContextPath()%>/logout"
       class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i> Cerrar sesión
    </a>
</aside>

<!-- ───────── MAIN CONTENT ───────── -->
<main class="flex-1 ml-[210px] min-h-screen flex flex-col">

    <!-- Top bar -->
    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div class="flex items-center gap-4 text-sm font-semibold text-gray-500">
            <a href="<%=request.getContextPath()%>/admin/requests" class="hover:text-[#c8102e] transition-colors flex items-center gap-2">
                <i class="fa-solid fa-arrow-left"></i> Volver a Solicitudes
            </a>
        </div>
        <div class="flex items-center gap-4">
            <button class="relative w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors">
                <i class="fa-regular fa-bell text-base"></i>
                <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-[#c8102e] rounded-full border-2 border-white"></span>
            </button>
            <div class="w-px h-6 bg-gray-200"></div>
            <span class="text-sm font-semibold text-gray-600">Ajustes</span>
            <div class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-sm"></i>
            </div>
        </div>
    </header>

    <!-- Page body -->
    <div class="p-8 flex-1">

        <% Solicitud sol = (Solicitud) request.getAttribute("solicitud"); %>
        
        <div class="flex items-start justify-between mb-6">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">Detalle de Solicitud #<%= sol.getId() %></h1>
                <p class="text-sm text-gray-400 mt-1">Revisión y gestión de la solicitud del estudiante.</p>
            </div>
            <% String state = sol.getEstado(); %>
            <% if ("Pendiente".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-amber-50 text-amber-600 border border-amber-100 flex items-center gap-2 shadow-sm"><i class="fa-solid fa-clock"></i> Pendiente</span>
            <% } else if ("Aprobada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-green-50 text-green-600 border border-green-100 flex items-center gap-2 shadow-sm"><i class="fa-solid fa-check"></i> Aprobada</span>
            <% } else if ("Rechazada".equals(state)) { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-red-50 text-red-600 border border-red-100 flex items-center gap-2 shadow-sm"><i class="fa-solid fa-xmark"></i> Rechazada</span>
            <% } else { %>
                <span class="px-3 py-1.5 text-xs font-bold uppercase tracking-wider rounded-lg bg-blue-50 text-blue-600 border border-blue-100 flex items-center gap-2 shadow-sm"><i class="fa-solid fa-paper-plane"></i> <%= state %></span>
            <% } %>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Details section -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Info Card -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4 border-b border-gray-50 pb-3"><i class="fa-regular fa-file-lines text-gray-400 mr-2"></i> Información General</h3>
                    
                    <div class="grid grid-cols-2 gap-y-4 text-sm">
                        <div>
                            <p class="text-gray-400 font-semibold mb-1 text-xs uppercase tracking-wide">Tipo de Solicitud</p>
                            <p class="font-bold text-gray-800"><%= sol.getTipo().getNombre() %></p>
                        </div>
                        <div>
                            <p class="text-gray-400 font-semibold mb-1 text-xs uppercase tracking-wide">Fecha de Envío</p>
                            <p class="font-bold text-gray-800"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "-" %></p>
                        </div>
                        <div class="col-span-2 mt-2">
                            <p class="text-gray-400 font-semibold mb-1 text-xs uppercase tracking-wide">Estudiante</p>
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center border border-gray-100">
                                    <i class="fa-solid fa-user text-gray-400"></i>
                                </div>
                                <div>
                                    <p class="font-bold text-gray-800"><%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Description Card -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4 border-b border-gray-50 pb-3"><i class="fa-solid fa-align-left text-gray-400 mr-2"></i> Descripción Detallada</h3>
                    <div class="bg-gray-50 rounded-xl p-4 text-sm text-gray-700 leading-relaxed border border-gray-100">
                        <%= sol.getDescripcion() %>
                    </div>
                    
                    <div class="mt-6">
                        <h4 class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3">Documentos Adjuntos</h4>
                        <% if (sol.getDocumento() != null && !sol.getDocumento().isEmpty()) { %>
                            <a href="<%=request.getContextPath()%>/<%= sol.getDocumento() %>" target="_blank" 
                               class="inline-flex items-center gap-3 p-3 rounded-xl border border-gray-200 hover:border-[#c8102e] hover:bg-red-50 transition-colors group">
                                <div class="w-10 h-10 rounded-lg bg-red-100 flex items-center justify-center text-[#c8102e] group-hover:bg-[#c8102e] group-hover:text-white transition-colors">
                                    <i class="fa-solid fa-file-pdf"></i>
                                </div>
                                <div>
                                    <p class="text-sm font-bold text-gray-800 group-hover:text-[#c8102e] transition-colors">Ver Documento PDF</p>
                                    <p class="text-xs text-gray-400">Click para abrir en nueva pestaña</p>
                                </div>
                            </a>
                        <% } else { %>
                            <div class="flex items-center gap-3 p-3 rounded-xl border border-dashed border-gray-200 bg-gray-50">
                                <div class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center text-gray-400">
                                    <i class="fa-solid fa-file-circle-xmark"></i>
                                </div>
                                <p class="text-sm font-semibold text-gray-500">No hay documentos adjuntos para esta solicitud.</p>
                            </div>
                        <% } %>
                    </div>
                </div>


            </div>

            <!-- Action section -->
            <div class="flex flex-col gap-6">
                <!-- Chat Messages -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4"><i class="fa-solid fa-comments text-[#c8102e] mr-2"></i> Conversación con el estudiante</h3>
                    
                    <div class="bg-gray-50 rounded-xl p-4 space-y-3 mb-4 max-h-80 overflow-y-auto">
                        <% List<model.SolicitudMensaje> mensajes = (List<model.SolicitudMensaje>) request.getAttribute("mensajes");
                           if (mensajes == null || mensajes.isEmpty()) { %>
                            <p class="text-center text-sm text-gray-400 py-8">Sin mensajes aún. Inicia la conversación.</p>
                        <% } %>
                        <% if (mensajes != null) { %>
                            <% for (model.SolicitudMensaje msg : mensajes) { %>
                                <% if ("student".equals(msg.getAutorRol())) { %>
                                    <div class="flex justify-end">
                                        <div class="max-w-xs bg-blue-100 text-blue-900 rounded-xl rounded-tr-none p-2.5">
                                            <p class="text-xs font-semibold mb-1">Estudiante</p>
                                            <p class="text-sm"><%= msg.getMensaje() %></p>
                                            <p class="text-[10px] mt-1 opacity-70"><%= msg.getFechaEnvio().toLocalTime().toString().substring(0, 5) %></p>
                                        </div>
                                    </div>
                                <% } else { %>
                                    <div class="flex justify-start">
                                        <div class="max-w-xs bg-[#c8102e] text-white rounded-xl rounded-tl-none p-2.5">
                                            <p class="text-xs font-semibold mb-1">Tú (Admin)</p>
                                            <p class="text-sm"><%= msg.getMensaje() %></p>
                                            <p class="text-[10px] mt-1 opacity-70"><%= msg.getFechaEnvio().toLocalTime().toString().substring(0, 5) %></p>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                        <% } %>
                    </div>

                    <form action="<%=request.getContextPath()%>/admin/request-detail" method="post" class="flex gap-2 mb-4">
                        <input type="hidden" name="id" value="<%= sol.getId() %>" />
                        <input type="hidden" name="action" value="message" />
                        <input type="text" name="comentario" placeholder="Responde al estudiante..." maxlength="500" required 
                               class="flex-1 px-3 py-2 bg-gray-50 border border-gray-100 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50" />
                        <button type="submit" class="px-3 py-2 bg-[#c8102e]/10 text-[#c8102e] rounded-lg font-semibold hover:bg-[#c8102e]/20 transition-colors">
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </form>
                </div>

                <!-- Resolution section -->
                <% if (!"Aprobada".equals(sol.getEstado()) && !"Rechazada".equals(sol.getEstado())) { %>
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6">
                    <h3 class="font-bold text-gray-800 mb-4"><i class="fa-solid fa-gavel text-[#c8102e] mr-2"></i> Resolución</h3>
                    
                    <form action="<%=request.getContextPath()%>/admin/request-detail" method="post" class="flex flex-col gap-4">
                        <input type="hidden" name="id" value="<%= sol.getId() %>" />
                        
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">Comentario final</label>
                            <textarea name="comentario" rows="3" placeholder="Explica el motivo de la decisión..."
                                      class="w-full px-3 py-2 bg-gray-50 border border-gray-100 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 resize-none" required></textarea>
                        </div>

                        <div class="flex flex-col gap-2">
                            <button type="submit" name="newState" value="Aprobada" 
                                    class="w-full bg-green-500 text-white font-bold py-2 rounded-lg hover:bg-green-600 transition-colors flex justify-center items-center gap-2 text-sm">
                                <i class="fa-solid fa-check"></i> Aprobar
                            </button>
                            <button type="submit" name="newState" value="Rechazada" 
                                    class="w-full bg-white text-[#c8102e] border-2 border-[#c8102e] font-bold py-1.5 rounded-lg hover:bg-red-50 transition-colors flex justify-center items-center gap-2 text-sm">
                                <i class="fa-solid fa-xmark"></i> Rechazar
                            </button>
                        </div>
                    </form>
                </div>
                <% } %>
        </div>

    </div>

    <!-- Footer -->
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

</body>
</html>