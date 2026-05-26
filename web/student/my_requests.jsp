<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Solicitudes - Sistema de Solicitudes</title>
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

<jsp:include page="/components/student_sidebar.jsp">
    <jsp:param name="activePage" value="requests" />
</jsp:include>

<main class="flex-1 ml-[220px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">Mis solicitudes</p>
            <h1 class="text-lg font-extrabold text-gray-900">Historial completo</h1>
        </div>

        <a href="<%=request.getContextPath()%>/student/new-request"
           class="flex items-center gap-2 rounded-xl bg-[#c8102e] px-4 py-2 text-sm font-bold text-white shadow-sm shadow-red-600/20 hover:bg-red-700 transition-colors">
            <i class="fa-solid fa-plus"></i> Crear solicitud
        </a>
    </header>

    <div class="p-8 flex-1">

        <form action="<%=request.getContextPath()%>/student/requests" method="get" class="flex items-center gap-3 mb-6">
            <label class="text-sm font-semibold text-gray-600">Filtro:</label>

            <select name="state" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 cursor-pointer">
                <option value="" <%= selectedState.isEmpty() ? "selected" : "" %>>Todos</option>
                <option value="Enviada" <%= "Enviada".equals(selectedState) ? "selected" : "" %>>Enviada</option>
                <option value="Pendiente" <%= "Pendiente".equals(selectedState) ? "selected" : "" %>>Pendiente</option>
                <option value="Aprobada" <%= "Aprobada".equals(selectedState) ? "selected" : "" %>>Aprobada</option>
                <option value="Rechazada" <%= "Rechazada".equals(selectedState) ? "selected" : "" %>>Rechazada</option>
                <option value="Anulada" <%= "Anulada".equals(selectedState) ? "selected" : "" %>>Anulada</option>
            </select>

            <button type="submit"
                    class="px-4 py-2 bg-[#c8102e] text-white rounded-lg font-semibold hover:bg-red-700 transition-colors flex items-center gap-2">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>

            <span class="ml-auto text-sm text-gray-400">
                Total: <strong class="text-gray-700"><%= totalRecords %></strong>
            </span>
        </form>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead>
                    <tr class="bg-gray-50 border-b border-gray-100">
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">ID</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Tipo</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Fecha</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Fecha límite</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Indicador</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Estado</th>
                        <th class="py-4 px-6 text-right text-[11px] font-bold uppercase tracking-wider text-gray-400">Acción</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (list.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="py-10 text-center text-sm text-gray-400">
                                No hay solicitudes para mostrar.
                            </td>
                        </tr>
                    <% } %>

                    <% for (Solicitud sol : list) { %>
                        <%
                            String estado = sol.getEstado();

                                boolean cerrada = "Aprobada".equals(estado)
                                    || "Rechazada".equals(estado)
                                    || "Anulada".equals(estado);

                            boolean editable = "Enviada".equals(estado) || "Pendiente".equals(estado);

                            String indicadorClass = "bg-green-50 text-green-600 border-green-100";
                            String indicadorIcon = "fa-circle-check";
                            String indicadorText = "En tiempo";

                            if ("Anulada".equals(estado)) {
                                indicadorClass = "bg-gray-100 text-gray-500 border-gray-200";
                                indicadorIcon = "fa-ban";
                                indicadorText = "Anulada";
                            } else if ("Aprobada".equals(estado) || "Rechazada".equals(estado)) {
                                indicadorClass = "bg-gray-100 text-gray-500 border-gray-200";
                                indicadorIcon = "fa-lock";
                                indicadorText = "Cerrada";
                            } else if (sol.getFechaLimite() != null) {
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
                            }
                        %>

                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 px-6 text-sm font-bold text-gray-500">#<%= sol.getId() %></td>

                            <td class="py-4 px-6 text-sm font-semibold text-gray-800">
                                <%= sol.getTipo().getNombre() %>
                            </td>

                            <td class="py-4 px-6 text-sm text-gray-500">
                                <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "Sin fecha" %>
                            </td>

                            <td class="py-4 px-6 text-sm text-gray-500">
                                <%= sol.getFechaLimite() != null ? sol.getFechaLimite().toLocalDate().toString() : "Sin límite" %>
                            </td>

                            <td class="py-4 px-6 text-sm">
                                <span class="inline-flex items-center rounded-lg px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider border <%= indicadorClass %>">
                                    <i class="fa-solid <%= indicadorIcon %> mr-1"></i>
                                    <%= indicadorText %>
                                </span>
                            </td>

                            <td class="py-4 px-6 text-sm">
                                <% if ("Pendiente".equals(estado)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-amber-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-amber-600 border border-amber-100">
                                        <i class="fa-solid fa-clock mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Aprobada".equals(estado)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-green-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-green-600 border border-green-100">
                                        <i class="fa-solid fa-check mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Rechazada".equals(estado)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-red-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-red-600 border border-red-100">
                                        <i class="fa-solid fa-xmark mr-1"></i> <%= estado %>
                                    </span>
                                <% } else if ("Anulada".equals(estado)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-gray-100 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-gray-600 border border-gray-200">
                                        <i class="fa-solid fa-ban mr-1"></i> <%= estado %>
                                    </span>
                                <% } else { %>
                                    <span class="inline-flex items-center rounded-lg bg-blue-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-blue-600 border border-blue-100">
                                        <i class="fa-solid fa-paper-plane mr-1"></i> <%= estado %>
                                    </span>
                                <% } %>
                            </td>

                            <td class="py-4 px-6 text-right">
                                <div class="inline-flex items-center gap-1">
                                    <a href="<%=request.getContextPath()%>/student/request-detail?id=<%= sol.getId() %>"
                                       class="inline-flex h-8 w-8 items-center justify-center rounded-full text-[#c8102e] hover:bg-red-50 transition-colors"
                                       title="Ver detalle">
                                        <i class="fa-regular fa-eye"></i>
                                    </a>

                                    <% if (editable) { %>
                                        <a href="<%=request.getContextPath()%>/student/edit-request?id=<%= sol.getId() %>"
                                           class="inline-flex h-8 w-8 items-center justify-center rounded-full text-amber-600 hover:bg-amber-50 transition-colors"
                                           title="Editar solicitud">
                                            <i class="fa-regular fa-pen-to-square"></i>
                                        </a>

                                        <form action="<%=request.getContextPath()%>/student/cancel-request"
                                              method="post"
                                              class="inline"
                                              onsubmit="return confirm('¿Seguro que deseas anular esta solicitud? Esta acción no se puede deshacer.');">

                                            <input type="hidden" name="id" value="<%= sol.getId() %>">

                                            <button type="submit"
                                                    class="inline-flex h-8 w-8 items-center justify-center rounded-full text-red-600 hover:bg-red-50 transition-colors"
                                                    title="Anular solicitud">
                                                <i class="fa-solid fa-ban"></i>
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <% if (totalPages > 1) { %>
                <div class="flex items-center justify-between px-6 py-4 border-t border-gray-100 bg-white">
                    <p class="text-sm text-gray-400">
                        Página <strong class="text-gray-700"><%= currentPage %></strong>
                        de <strong class="text-gray-700"><%= totalPages %></strong>
                    </p>

                    <div class="flex items-center gap-2">
                        <% if (currentPage > 1) { %>
                            <a href="<%=request.getContextPath()%>/student/requests?state=<%= selectedState %>&page=<%= currentPage - 1 %>"
                               class="px-3 py-2 rounded-lg border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                                Anterior
                            </a>
                        <% } %>

                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <a href="<%=request.getContextPath()%>/student/requests?state=<%= selectedState %>&page=<%= i %>"
                               class="px-3 py-2 rounded-lg text-sm font-bold <%= i == currentPage ? "bg-[#c8102e] text-white" : "border border-gray-200 text-gray-600 hover:bg-gray-50" %>">
                                <%= i %>
                            </a>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                            <a href="<%=request.getContextPath()%>/student/requests?state=<%= selectedState %>&page=<%= currentPage + 1 %>"
                               class="px-3 py-2 rounded-lg border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                                Siguiente
                            </a>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</main>

</body>
</html>