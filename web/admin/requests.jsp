<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitudes - FESC Admin</title>
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
    List<Solicitud> list = (List<Solicitud>) request.getAttribute("list");
    if (list == null) {
        list = new ArrayList<Solicitud>();
    }

    String selectedState = (String) request.getAttribute("selectedState");
    if (selectedState == null) {
        selectedState = "";
    }

    int currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 0;
    int totalRecords = request.getAttribute("totalRecords") != null ? (Integer) request.getAttribute("totalRecords") : list.size();

    LocalDate today = LocalDate.now();
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="requests" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div></div>
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

    <div class="p-8 flex-1">

        <div class="flex flex-col md:flex-row items-start md:items-end justify-between mb-6 gap-4">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">Listado de Solicitudes</h1>
                <p class="text-sm text-gray-400 mt-1">
                    Gestión y revisión de requerimientos estudiantiles.
                    Total de registros:
                    <strong class="text-gray-700"><%= totalRecords %></strong>
                </p>
            </div>

            <form method="get" action="<%=request.getContextPath()%>/admin/requests"
                  class="flex items-center gap-3 bg-white p-2 rounded-xl shadow-sm border border-gray-100">
                <span class="text-xs font-bold text-gray-400 uppercase tracking-wider pl-2">Filtro:</span>

                <select name="state" class="text-sm font-medium text-gray-700 bg-gray-50 border-none rounded-lg py-1.5 px-3 focus:ring-2 focus:ring-[#c8102e]/30 cursor-pointer outline-none">
                    <option value="" <%= selectedState.isEmpty() ? "selected" : "" %>>Todos los estados</option>
                    <option value="Enviada" <%= "Enviada".equals(selectedState) ? "selected" : "" %>>Enviada</option>
                    <option value="Pendiente" <%= "Pendiente".equals(selectedState) ? "selected" : "" %>>Pendiente</option>
                    <option value="Aprobada" <%= "Aprobada".equals(selectedState) ? "selected" : "" %>>Aprobada</option>
                    <option value="Rechazada" <%= "Rechazada".equals(selectedState) ? "selected" : "" %>>Rechazada</option>
                </select>

                <button type="submit" class="bg-[#c8102e] text-white w-8 h-8 rounded-lg hover:bg-red-800 transition-colors flex items-center justify-center shadow-sm shadow-red-600/20">
                    <i class="fa-solid fa-magnifying-glass text-sm"></i>
                </button>
            </form>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead>
                    <tr class="border-b border-gray-100">
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">ID</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Estudiante</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Tipo</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Fecha</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Fecha límite</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Indicador</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Estado</th>
                        <th class="pb-3 text-right text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Acción</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (list.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="py-10 text-center text-sm text-gray-400">
                                No hay solicitudes para mostrar.
                            </td>
                        </tr>
                    <% } %>

                    <% for (Solicitud sol : list) { %>
                        <%
                            String estado = sol.getEstado();

                            boolean cerrada = "Aprobada".equals(estado) || "Rechazada".equals(estado) || "Anulada".equals(estado);

                            String indicadorClass = "bg-green-50 text-green-600 border-green-100";
                            String indicadorIcon = "fa-circle-check";
                            String indicadorText = "En tiempo";

                            if (!cerrada && sol.getFechaLimite() != null) {
                                LocalDate limite = sol.getFechaLimite().toLocalDate();

                                if (limite.isBefore(today)) {
                                    indicadorClass = "bg-red-50 text-red-600 border-red-100";
                                    indicadorIcon = "fa-triangle-exclamation";
                                    indicadorText = "Vencida";
                                } else if (!limite.isAfter(today.plusDays(2))) {
                                    indicadorClass = "bg-amber-50 text-amber-600 border-amber-100";
                                    indicadorIcon = "fa-clock";
                                    indicadorText = "Por vencer";
                                }
                            } else if ("Anulada".equals(estado)) {
                                indicadorClass = "bg-gray-100 text-gray-500 border-gray-200";
                                indicadorIcon = "fa-ban";
                                indicadorText = "Anulada";
                            } else if (cerrada) {
                                indicadorClass = "bg-gray-100 text-gray-500 border-gray-200";
                                indicadorIcon = "fa-lock";
                                indicadorText = "Cerrada";
                            }
                        %>

                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 px-2 text-sm font-bold text-gray-400">#<%= sol.getId() %></td>

                            <td class="py-4 px-2">
                                <div class="flex items-center gap-2.5">
                                    <div class="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0">
                                        <i class="fa-solid fa-user text-gray-500 text-[10px]"></i>
                                    </div>
                                    <span class="text-sm font-semibold text-gray-800">
                                        <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %>
                                    </span>
                                </div>
                            </td>

                            <td class="py-4 px-2">
                                <span class="inline-block text-xs font-semibold text-gray-600 bg-gray-100 px-2.5 py-1 rounded-lg">
                                    <%= sol.getTipo().getNombre() %>
                                </span>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "Sin fecha" %>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= sol.getFechaLimite() != null ? sol.getFechaLimite().toLocalDate().toString() : "Sin límite" %>
                            </td>

                            <td class="py-4 px-2 text-sm">
                                <span class="inline-flex items-center rounded-lg px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider border <%= indicadorClass %>">
                                    <i class="fa-solid <%= indicadorIcon %> mr-1"></i>
                                    <%= indicadorText %>
                                </span>
                            </td>

                            <td class="py-4 px-2">
                                <% if ("Pendiente".equals(estado)) { %>
                                    <span class="px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider rounded-lg bg-amber-50 text-amber-600 border border-amber-100">
                                        <i class="fa-solid fa-clock mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Aprobada".equals(estado)) { %>
                                    <span class="px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider rounded-lg bg-green-50 text-green-600 border border-green-100">
                                        <i class="fa-solid fa-check mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Rechazada".equals(estado)) { %>
                                    <span class="px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider rounded-lg bg-red-50 text-red-600 border border-red-100">
                                        <i class="fa-solid fa-xmark mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Anulada".equals(estado)) { %>
                                    <span class="px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider rounded-lg bg-gray-100 text-gray-600 border border-gray-200">
                                        <i class="fa-solid fa-ban mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Enviada".equals(estado)) { %>
                                    <span class="px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider rounded-lg bg-blue-50 text-blue-600 border border-blue-100">
                                        <i class="fa-solid fa-paper-plane mr-1"></i> <%= estado %>
                                    </span>
                                <% } else { %>
                                    <span class="px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider rounded-lg bg-gray-100 text-gray-600">
                                        <%= estado %>
                                    </span>
                                <% } %>
                            </td>

                            <td class="py-4 px-2 text-right">
                                <a href="<%=request.getContextPath()%>/admin/request-detail?id=<%= sol.getId() %>"
                                   class="w-8 h-8 inline-flex items-center justify-center rounded-full text-[#c8102e] hover:bg-red-50 transition-colors"
                                   title="Ver detalle">
                                    <i class="fa-regular fa-eye text-base"></i>
                                </a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <% if (totalPages > 1) { %>
                <div class="flex items-center justify-between px-2 pt-6">
                    <p class="text-sm text-gray-400">
                        Página <strong class="text-gray-700"><%= currentPage %></strong>
                        de <strong class="text-gray-700"><%= totalPages %></strong>
                    </p>

                    <div class="flex items-center gap-2">
                        <% if (currentPage > 1) { %>
                            <a href="<%=request.getContextPath()%>/admin/requests?state=<%= selectedState %>&page=<%= currentPage - 1 %>"
                               class="px-3 py-2 rounded-lg border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                                Anterior
                            </a>
                        <% } %>

                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <a href="<%=request.getContextPath()%>/admin/requests?state=<%= selectedState %>&page=<%= i %>"
                               class="px-3 py-2 rounded-lg text-sm font-bold <%= i == currentPage ? "bg-[#c8102e] text-white" : "border border-gray-200 text-gray-600 hover:bg-gray-50" %>">
                                <%= i %>
                            </a>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                            <a href="<%=request.getContextPath()%>/admin/requests?state=<%= selectedState %>&page=<%= currentPage + 1 %>"
                               class="px-3 py-2 rounded-lg border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                                Siguiente
                            </a>
                        <% } %>
                    </div>
                </div>
            <% } %>
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

</body>
</html>