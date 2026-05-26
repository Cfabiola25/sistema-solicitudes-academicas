<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - FESC Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .report-card { box-shadow: 0 10px 25px rgba(15, 23, 42, 0.04); }
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    Map<Integer, Integer> monthlyCreated = (Map<Integer, Integer>) request.getAttribute("monthlyCreated");
    Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
    List<Solicitud> recent = (List<Solicitud>) request.getAttribute("recent");
    List<Solicitud> closedRecent = (List<Solicitud>) request.getAttribute("closedRecent");
    List<Solicitud> urgent = (List<Solicitud>) request.getAttribute("urgent");
    List<Object[]> topTypes = (List<Object[]>) request.getAttribute("topTypes");
    List<Object[]> topPrograms = (List<Object[]>) request.getAttribute("topPrograms");

    if (counts == null) counts = new HashMap<String, Integer>();
    if (monthlyCreated == null) monthlyCreated = new HashMap<Integer, Integer>();
    if (monthly == null) monthly = new HashMap<Integer, Integer>();
    if (recent == null) recent = new ArrayList<Solicitud>();
    if (closedRecent == null) closedRecent = new ArrayList<Solicitud>();
    if (urgent == null) urgent = new ArrayList<Solicitud>();
    if (topTypes == null) topTypes = new ArrayList<Object[]>();
    if (topPrograms == null) topPrograms = new ArrayList<Object[]>();

    Integer total = (Integer) request.getAttribute("total");
    Integer open = (Integer) request.getAttribute("open");
    Integer closed = (Integer) request.getAttribute("closed");
    Integer createdThisMonth = (Integer) request.getAttribute("createdThisMonth");
    Integer sent = (Integer) request.getAttribute("sent");
    Integer pending = (Integer) request.getAttribute("pending");
    Integer approved = (Integer) request.getAttribute("approved");
    Integer rejected = (Integer) request.getAttribute("rejected");
    Integer expired = (Integer) request.getAttribute("expired");
    Integer aboutToExpire = (Integer) request.getAttribute("aboutToExpire");
    Double approvalRate = (Double) request.getAttribute("approvalRate");
    Double averageResolutionDays = (Double) request.getAttribute("averageResolutionDays");

    int totalValue = total != null ? total : 0;
    int openValue = open != null ? open : counts.getOrDefault("Enviada", 0) + counts.getOrDefault("Pendiente", 0);
    int closedValue = closed != null ? closed : counts.getOrDefault("Aprobada", 0) + counts.getOrDefault("Rechazada", 0) + counts.getOrDefault("Anulada", 0);
    int createdThisMonthValue = createdThisMonth != null ? createdThisMonth : 0;
    int sentValue = sent != null ? sent : counts.getOrDefault("Enviada", 0);
    int pendingValue = pending != null ? pending : counts.getOrDefault("Pendiente", 0);
    int approvedValue = approved != null ? approved : counts.getOrDefault("Aprobada", 0);
    int rejectedValue = rejected != null ? rejected : counts.getOrDefault("Rechazada", 0);
    int expiredValue = expired != null ? expired : 0;
    int aboutToExpireValue = aboutToExpire != null ? aboutToExpire : 0;
    double approvalRateValue = approvalRate != null ? approvalRate : 0.0;
    double averageResolutionDaysValue = averageResolutionDays != null ? averageResolutionDays : 0.0;
    int annulledValue = counts.getOrDefault("Anulada", 0);
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="reports" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">Panel administrativo</p>
            <h1 class="text-lg font-extrabold text-gray-900">Reportes y métricas</h1>
        </div>
        <div class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
            <i class="fa-regular fa-chart-bar text-[#c8102e] text-sm"></i>
        </div>
    </header>

    <div class="p-8 flex-1 space-y-6">
        <div class="flex items-start justify-between gap-4">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.3em] text-gray-400">Panel administrativo</p>
                <h1 class="text-3xl font-extrabold text-gray-900 mt-2">Reportes y métricas</h1>
                <p class="text-sm text-gray-500 mt-2 max-w-2xl">Un tablero de análisis con tendencia, distribución por estado, tipos más usados y seguimiento de casos críticos.</p>
            </div>
            <a href="<%=request.getContextPath()%>/admin/requests" class="text-sm font-bold text-[#c8102e] hover:underline self-start mt-2">Ir al listado</a>
        </div>

        <div class="grid grid-cols-2 xl:grid-cols-8 gap-4">
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Total</p><p class="text-3xl font-extrabold text-gray-900"><%= totalValue %></p></div>
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">En progreso</p><p class="text-3xl font-extrabold text-blue-600"><%= openValue %></p></div>
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Cerradas</p><p class="text-3xl font-extrabold text-green-600"><%= closedValue %></p></div>
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Aprobación</p><p class="text-3xl font-extrabold text-[#c8102e]"><%= String.format(java.util.Locale.US, "%.1f", approvalRateValue) %>%</p></div>
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Vencidas</p><p class="text-3xl font-extrabold text-[#c8102e]"><%= expiredValue %></p></div>
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Por vencer</p><p class="text-3xl font-extrabold text-yellow-600"><%= aboutToExpireValue %></p></div>
            <div class="report-card bg-white rounded-2xl border border-gray-100 p-5"><p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Este mes</p><p class="text-3xl font-extrabold text-gray-900"><%= createdThisMonthValue %></p></div>
            <div class="report-card bg-[#c8102e] rounded-2xl border border-[#c8102e] p-5 text-white"><p class="text-xs font-bold text-white/70 uppercase tracking-wider mb-2">Promedio resolución</p><p class="text-3xl font-extrabold"><%= String.format(java.util.Locale.US, "%.1f", averageResolutionDaysValue) %> d</p></div>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-xl font-extrabold text-gray-900 mb-1">Tendencia mensual</h2>
                <p class="text-sm text-gray-400 mb-4">Solicitudes creadas versus aprobadas en el año actual.</p>
                <canvas id="trendChart" height="130"></canvas>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-xl font-extrabold text-gray-900 mb-4">Estados</h2>
                <canvas id="statusChart" height="220"></canvas>
            </div>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-xl font-extrabold text-gray-900 mb-1">Tipos más solicitados</h2>
                <p class="text-sm text-gray-400 mb-4">Top de solicitudes por tipo.</p>
                <canvas id="typesChart" height="240"></canvas>
            </div>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-xl font-extrabold text-gray-900 mb-1">Programas con más solicitudes</h2>
                <p class="text-sm text-gray-400 mb-4">Top de solicitudes por programa académico.</p>
                <canvas id="programsChart" height="240"></canvas>
            </div>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h2 class="text-xl font-extrabold text-gray-900">Actividad reciente</h2>
                        <p class="text-sm text-gray-400 mt-1">Últimas solicitudes registradas en el sistema.</p>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead>
                        <tr class="border-b border-gray-100 text-left text-[11px] uppercase tracking-wider text-gray-400">
                            <th class="pb-3 pr-4">ID</th>
                            <th class="pb-3 pr-4">Estudiante</th>
                            <th class="pb-3 pr-4">Tipo</th>
                            <th class="pb-3 pr-4">Estado</th>
                            <th class="pb-3 text-right">Fecha</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (recent.isEmpty()) { %>
                            <tr><td colspan="5" class="py-10 text-center text-sm text-gray-400">No hay actividad reciente para mostrar.</td></tr>
                        <% } %>
                        <% for (Solicitud sol : recent) { %>
                            <%
                                String estado = sol.getEstado();
                                String estadoClass = "bg-gray-100 text-gray-600 border-gray-200";
                                String estadoIcon = "fa-circle";
                                if ("Enviada".equals(estado)) { estadoClass = "bg-blue-50 text-blue-600 border-blue-100"; estadoIcon = "fa-paper-plane"; }
                                else if ("Pendiente".equals(estado)) { estadoClass = "bg-amber-50 text-amber-600 border-amber-100"; estadoIcon = "fa-clock"; }
                                else if ("Aprobada".equals(estado)) { estadoClass = "bg-green-50 text-green-600 border-green-100"; estadoIcon = "fa-check"; }
                                else if ("Rechazada".equals(estado)) { estadoClass = "bg-red-50 text-red-600 border-red-100"; estadoIcon = "fa-xmark"; }
                            %>
                            <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                                <td class="py-4 pr-4 text-sm font-bold text-gray-500">#<%= sol.getId() %></td>
                                <td class="py-4 pr-4 text-sm font-semibold text-gray-800"><%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></td>
                                <td class="py-4 pr-4 text-sm text-gray-600"><%= sol.getTipo().getNombre() %></td>
                                <td class="py-4 pr-4 text-sm"><span class="inline-flex items-center rounded-lg px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider border <%= estadoClass %>"><i class="fa-solid <%= estadoIcon %> mr-1"></i><%= estado %></span></td>
                                <td class="py-4 text-right text-sm text-gray-500"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="space-y-6">
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h2 class="text-xl font-extrabold text-gray-900 mb-4">Casos urgentes</h2>
                    <div class="space-y-3 max-h-[420px] overflow-y-auto pr-1">
                        <% if (urgent.isEmpty()) { %>
                            <p class="text-sm text-gray-400">No hay casos vencidos en este momento.</p>
                        <% } %>
                        <% for (Solicitud sol : urgent) { %>
                            <a href="<%=request.getContextPath()%>/admin/request-detail?id=<%= sol.getId() %>" class="block rounded-xl border border-red-100 bg-red-50/60 p-3 hover:bg-red-50 transition-colors">
                                <div class="flex items-center justify-between gap-3">
                                    <div>
                                        <p class="text-sm font-bold text-gray-900">#<%= sol.getId() %> - <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></p>
                                        <p class="text-xs text-gray-500"><%= sol.getTipo().getNombre() %></p>
                                    </div>
                                    <span class="text-[11px] font-bold uppercase tracking-wider text-[#c8102e] bg-white px-2.5 py-1 rounded-lg border border-red-100"><%= sol.getEstado() %></span>
                                </div>
                            </a>
                        <% } %>
                    </div>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <h2 class="text-xl font-extrabold text-gray-900 mb-4">Cerradas recientes</h2>
                    <div class="space-y-3 max-h-[420px] overflow-y-auto pr-1">
                        <% if (closedRecent.isEmpty()) { %>
                            <p class="text-sm text-gray-400">Todavía no hay solicitudes cerradas recientes.</p>
                        <% } %>
                        <% for (Solicitud sol : closedRecent) { %>
                            <div class="rounded-xl border border-gray-100 bg-gray-50 p-3">
                                <p class="text-sm font-bold text-gray-900">#<%= sol.getId() %> - <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></p>
                                <p class="text-xs text-gray-500"><%= sol.getTipo().getNombre() %> · <%= sol.getEstado() %></p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    const chart = document.getElementById('trendChart');
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const createdData = [
        <%= monthlyCreated.getOrDefault(1,0) %>, <%= monthlyCreated.getOrDefault(2,0) %>, <%= monthlyCreated.getOrDefault(3,0) %>,
        <%= monthlyCreated.getOrDefault(4,0) %>, <%= monthlyCreated.getOrDefault(5,0) %>, <%= monthlyCreated.getOrDefault(6,0) %>,
        <%= monthlyCreated.getOrDefault(7,0) %>, <%= monthlyCreated.getOrDefault(8,0) %>, <%= monthlyCreated.getOrDefault(9,0) %>,
        <%= monthlyCreated.getOrDefault(10,0) %>, <%= monthlyCreated.getOrDefault(11,0) %>, <%= monthlyCreated.getOrDefault(12,0) %>
    ];
    const approvedData = [
        <%= monthly.getOrDefault(1,0) %>, <%= monthly.getOrDefault(2,0) %>, <%= monthly.getOrDefault(3,0) %>,
        <%= monthly.getOrDefault(4,0) %>, <%= monthly.getOrDefault(5,0) %>, <%= monthly.getOrDefault(6,0) %>,
        <%= monthly.getOrDefault(7,0) %>, <%= monthly.getOrDefault(8,0) %>, <%= monthly.getOrDefault(9,0) %>,
        <%= monthly.getOrDefault(10,0) %>, <%= monthly.getOrDefault(11,0) %>, <%= monthly.getOrDefault(12,0) %>
    ];

    new Chart(chart, {
        type: 'line',
        data: { labels: months, datasets: [
            { label: 'Creadas', data: createdData, borderColor: '#0ea5e9', backgroundColor: 'rgba(14,165,233,0.12)', tension: 0.35, fill: true, pointRadius: 3 },
            { label: 'Aprobadas', data: approvedData, borderColor: '#22c55e', backgroundColor: 'rgba(34,197,94,0.08)', tension: 0.35, fill: true, pointRadius: 3 }
        ] },
        options: { responsive: true, plugins: { legend: { position: 'bottom' } }, scales: { x: { grid: { display: false } }, y: { beginAtZero: true, ticks: { precision: 0 } } } }
    });

    new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
            labels: ['Enviadas', 'Pendientes', 'Aprobadas', 'Rechazadas', 'Anuladas'],
            datasets: [{ data: [<%= sentValue %>, <%= pendingValue %>, <%= approvedValue %>, <%= rejectedValue %>, <%= annulledValue %>], backgroundColor: ['#3b82f6', '#f59e0b', '#22c55e', '#ef4444', '#64748b'], borderWidth: 0 }]
        },
        options: { responsive: true, plugins: { legend: { position: 'bottom' } }, cutout: '68%' }
    });

    const typeLabels = [<% for (Object[] item : topTypes) { String label = item[0] != null ? item[0].toString().replace("'", "\\'") : ""; %>'<%= label %>',<% } %>];
    const typeValues = [<% for (Object[] item : topTypes) { int value = item[1] != null ? ((Number) item[1]).intValue() : 0; %><%= value %>,<% } %>];

    new Chart(document.getElementById('typesChart'), {
        type: 'bar',
        data: { labels: typeLabels, datasets: [{ data: typeValues, backgroundColor: '#c8102e', borderRadius: 8, borderSkipped: false }] },
        options: { responsive: true, indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, ticks: { precision: 0 } }, y: { grid: { display: false } } } }
    });

    const programLabels = [<% for (Object[] item : topPrograms) { String label = item[0] != null ? item[0].toString().replace("'", "\\'") : ""; %>'<%= label %>',<% } %>];
    const programValues = [<% for (Object[] item : topPrograms) { int value = item[1] != null ? ((Number) item[1]).intValue() : 0; %><%= value %>,<% } %>];

    new Chart(document.getElementById('programsChart'), {
        type: 'bar',
        data: { labels: programLabels, datasets: [{ data: programValues, backgroundColor: '#0ea5e9', borderRadius: 8, borderSkipped: false }] },
        options: { responsive: true, indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, ticks: { precision: 0 } }, y: { grid: { display: false } } } }
    });
</script>

</body>
</html>