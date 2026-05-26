<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Gestión - FESC Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .nav-link.active { background: #c8102e; color: white !important; border-radius: 10px; }
        .nav-link.active i { color: white !important; }
        .nav-link:hover:not(.active) { background: #f4f5f7; border-radius: 10px; }
        .status-card { background: linear-gradient(135deg, #c8102e 0%, #9b0c23 100%); position: relative; overflow: hidden; }
        .status-card::before { content: ''; position: absolute; right: -30px; top: -30px; width: 160px; height: 160px; border-radius: 50%; background: rgba(255,255,255,0.06); }
        .status-card::after { content: ''; position: absolute; right: 30px; bottom: -50px; width: 120px; height: 120px; border-radius: 50%; background: rgba(255,255,255,0.04); }
        .metric-card { box-shadow: 0 10px 25px rgba(15, 23, 42, 0.04); }
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    Map<Integer, Integer> monthlyCreated = (Map<Integer, Integer>) request.getAttribute("monthlyCreated");
    Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
    List<Solicitud> pending = (List<Solicitud>) request.getAttribute("pending");
    List<Object[]> topTypes = (List<Object[]>) request.getAttribute("topTypes");
    List<Object[]> topPrograms = (List<Object[]>) request.getAttribute("topPrograms");

    if (counts == null) counts = new HashMap<String, Integer>();
    if (monthlyCreated == null) monthlyCreated = new HashMap<Integer, Integer>();
    if (monthly == null) monthly = new HashMap<Integer, Integer>();
    if (pending == null) pending = new ArrayList<Solicitud>();
    if (topTypes == null) topTypes = new ArrayList<Object[]>();
    if (topPrograms == null) topPrograms = new ArrayList<Object[]>();

    Integer totalAttr = (Integer) request.getAttribute("total");
    Integer openAttr = (Integer) request.getAttribute("openCount");
    Integer closedAttr = (Integer) request.getAttribute("closedCount");
    Integer createdThisMonthAttr = (Integer) request.getAttribute("createdThisMonth");
    Double averageResolutionDaysAttr = (Double) request.getAttribute("averageResolutionDays");

    int total = totalAttr != null ? totalAttr : 0;
    int openCount = openAttr != null ? openAttr : counts.getOrDefault("Enviada", 0) + counts.getOrDefault("Pendiente", 0);
    int closedCount = closedAttr != null ? closedAttr : counts.getOrDefault("Aprobada", 0) + counts.getOrDefault("Rechazada", 0) + counts.getOrDefault("Anulada", 0);
    int createdThisMonth = createdThisMonthAttr != null ? createdThisMonthAttr : 0;
    double averageResolutionDays = averageResolutionDaysAttr != null ? averageResolutionDaysAttr : 0.0;

    int sentCount = counts.getOrDefault("Enviada", 0);
    int pendingCount = counts.getOrDefault("Pendiente", 0);
    int approvedCount = counts.getOrDefault("Aprobada", 0);
    int rejectedCount = counts.getOrDefault("Rechazada", 0);
    int annulledCount = counts.getOrDefault("Anulada", 0);

    int expiredCount = request.getAttribute("expiredCount") != null ? (Integer) request.getAttribute("expiredCount") : 0;
    int aboutToExpireCount = request.getAttribute("aboutToExpireCount") != null ? (Integer) request.getAttribute("aboutToExpireCount") : 0;
    int approvalRate = total > 0 ? (int) Math.round(approvedCount * 100.0 / total) : 0;
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="dashboard" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div></div>
        <div class="flex items-center gap-4">
            <a href="<%=request.getContextPath()%>/admin/requests?state=Vencidas"
               class="relative w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors">
                <i class="fa-regular fa-bell text-base"></i>
                <% if (expiredCount > 0 || aboutToExpireCount > 0) { %>
                    <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-[#c8102e] rounded-full border-2 border-white"></span>
                <% } %>
            </a>
            <div class="w-px h-6 bg-gray-200"></div>
            <span class="text-sm font-semibold text-gray-600">Ajustes</span>
            <a href="<%=request.getContextPath()%>/admin/profile"
               class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center hover:bg-red-100 transition-colors"
               title="Mi perfil">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-sm"></i>
            </a>
        </div>
    </header>

    <div class="p-8 flex-1 space-y-6">
        <div class="flex items-start justify-between gap-4">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.3em] text-gray-400">Administración</p>
                <h1 class="text-3xl font-extrabold text-gray-900 mt-2">Dashboard de Gestión</h1>
                <p class="text-sm text-gray-500 mt-2 max-w-2xl">Resumen operacional de solicitudes, vencimientos y distribución por tipo para tomar decisiones más rápido.</p>
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-500 bg-white border border-gray-100 rounded-xl px-4 py-2 shadow-sm">
                <i class="fa-regular fa-calendar text-[#c8102e]"></i>
                <span id="todayDate"></span>
            </div>
        </div>

        <div class="grid grid-cols-2 xl:grid-cols-6 gap-4">
            <a href="<%=request.getContextPath()%>/admin/requests"
               class="metric-card bg-white rounded-2xl border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-[#c8102e]/10 flex items-center justify-center mb-3"><i class="fa-solid fa-chart-simple text-[#c8102e]"></i></div>
                <p class="text-xs text-gray-400 font-semibold uppercase tracking-wider mb-1">Total</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= total %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Enviada"
               class="metric-card bg-white rounded-2xl border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center mb-3"><i class="fa-solid fa-paper-plane text-blue-500"></i></div>
                <p class="text-xs text-gray-400 font-semibold uppercase tracking-wider mb-1">Enviadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= sentCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Pendiente"
               class="metric-card bg-white rounded-2xl border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-amber-50 flex items-center justify-center mb-3"><i class="fa-solid fa-clock text-amber-500"></i></div>
                <p class="text-xs text-gray-400 font-semibold uppercase tracking-wider mb-1">Pendientes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= pendingCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Aprobada"
               class="metric-card bg-white rounded-2xl border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center mb-3"><i class="fa-solid fa-circle-check text-green-500"></i></div>
                <p class="text-xs text-gray-400 font-semibold uppercase tracking-wider mb-1">Aprobadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= approvedCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Vencidas"
               class="metric-card bg-white rounded-2xl border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center mb-3"><i class="fa-solid fa-triangle-exclamation text-[#c8102e]"></i></div>
                <p class="text-xs text-gray-400 font-semibold uppercase tracking-wider mb-1">Vencidas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= expiredCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/reports"
               class="metric-card bg-[#c8102e] rounded-2xl border border-[#c8102e] p-5 text-white hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-white/15 flex items-center justify-center mb-3"><i class="fa-solid fa-percent text-white"></i></div>
                <p class="text-xs text-white/70 font-semibold uppercase tracking-wider mb-1">Tasa aprobación</p>
                <p class="text-3xl font-extrabold"><%= approvalRate %>%</p>
            </a>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h3 class="font-extrabold text-gray-900 text-lg">Tendencia mensual</h3>
                        <p class="text-xs text-gray-400 mt-1">Solicitudes creadas versus aprobadas durante el año actual.</p>
                    </div>
                </div>
                <canvas id="trendChart" height="150"></canvas>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h3 class="font-extrabold text-gray-900 text-lg mb-4">Distribución por estado</h3>
                <canvas id="statusChart" height="220"></canvas>
                <div class="grid grid-cols-2 gap-3 mt-4 text-xs">
                    <div class="rounded-xl bg-blue-50 p-3"><p class="text-gray-500 font-semibold">En progreso</p><p class="text-lg font-extrabold text-blue-600"><%= openCount %></p></div>
                    <div class="rounded-xl bg-green-50 p-3"><p class="text-gray-500 font-semibold">Cerradas</p><p class="text-lg font-extrabold text-green-600"><%= closedCount %></p></div>
                    <div class="rounded-xl bg-red-50 p-3"><p class="text-gray-500 font-semibold">Vencidas</p><p class="text-lg font-extrabold text-[#c8102e]"><%= expiredCount %></p></div>
                    <div class="rounded-xl bg-yellow-50 p-3"><p class="text-gray-500 font-semibold">Por vencer</p><p class="text-lg font-extrabold text-yellow-600"><%= aboutToExpireCount %></p></div>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h3 class="font-extrabold text-gray-900 text-lg">Tipos más solicitados</h3>
                        <p class="text-xs text-gray-400 mt-1">Ranking de solicitudes con mayor volumen.</p>
                    </div>
                    <span class="text-xs font-bold text-[#c8102e] bg-red-50 px-3 py-1 rounded-full"><%= createdThisMonth %> este mes</span>
                </div>

                <div class="space-y-4">
                    <% if (topTypes.isEmpty()) { %>
                        <p class="text-sm text-gray-400">Todavía no hay datos suficientes.</p>
                    <% } %>
                    <% for (Object[] item : topTypes) {
                        String label = item[0] != null ? item[0].toString() : "";
                        int value = item[1] != null ? ((Number) item[1]).intValue() : 0;
                    %>
                        <div>
                            <div class="flex items-center justify-between text-sm mb-2">
                                <span class="font-semibold text-gray-700"><%= label %></span>
                                <span class="text-gray-500"><%= value %></span>
                            </div>
                            <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                                <div class="h-full bg-[#c8102e] rounded-full" style="width: <%= total > 0 ? (value * 100.0 / total) : 0 %>%"></div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h3 class="font-extrabold text-gray-900 text-lg">Programas con más solicitudes</h3>
                        <p class="text-xs text-gray-400 mt-1">Distribución por programa académico.</p>
                    </div>
                </div>

                <div class="space-y-4">
                    <% if (topPrograms.isEmpty()) { %>
                        <p class="text-sm text-gray-400">Todavía no hay datos suficientes.</p>
                    <% } %>
                    <% for (Object[] item : topPrograms) {
                        String label = item[0] != null ? item[0].toString() : "";
                        int value = item[1] != null ? ((Number) item[1]).intValue() : 0;
                    %>
                        <div>
                            <div class="flex items-center justify-between text-sm mb-2">
                                <span class="font-semibold text-gray-700"><%= label %></span>
                                <span class="text-gray-500"><%= value %></span>
                            </div>
                            <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                                <div class="h-full bg-blue-500 rounded-full" style="width: <%= total > 0 ? (value * 100.0 / total) : 0 %>%"></div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-center justify-between mb-5">
                    <div>
                        <h3 class="font-extrabold text-gray-900 text-lg">Solicitudes pendientes</h3>
                        <p class="text-xs text-gray-400 mt-1">Primeras solicitudes pendientes para revisión.</p>
                    </div>
                    <a href="<%=request.getContextPath()%>/admin/requests?state=Pendiente" class="text-xs font-bold text-[#c8102e] hover:underline">Ver todo</a>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead>
                        <tr class="border-b border-gray-100">
                            <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">ID</th>
                            <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Estudiante</th>
                            <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Tipo</th>
                            <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Fecha</th>
                            <th class="pb-3 text-right text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (pending.isEmpty()) { %>
                            <tr><td colspan="5" class="py-10 text-center text-sm text-gray-400">No hay solicitudes pendientes.</td></tr>
                        <% } %>
                        <% for (Solicitud sol : pending) { %>
                            <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                                <td class="py-3.5 px-2 text-sm font-bold text-gray-400">#<%= sol.getId() %></td>
                                <td class="py-3.5 px-2 text-sm font-semibold text-gray-800"><%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></td>
                                <td class="py-3.5 px-2"><span class="inline-block text-xs font-semibold text-gray-600 bg-gray-100 px-2.5 py-1 rounded-lg"><%= sol.getTipo().getNombre() %></span></td>
                                <td class="py-3.5 px-2 text-sm text-gray-500"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
                                <td class="py-3.5 px-2 text-right"><a href="<%=request.getContextPath()%>/admin/request-detail?id=<%= sol.getId() %>" class="w-8 h-8 inline-flex items-center justify-center rounded-full text-[#c8102e] hover:bg-red-50 transition-colors"><i class="fa-regular fa-eye text-base"></i></a></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="space-y-6">
                <div class="status-card rounded-2xl p-6 text-white shadow-lg">
                    <div class="flex items-center gap-2 mb-3"><span class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span><span class="text-xs font-bold uppercase tracking-widest opacity-80">Estado del Sistema</span></div>
                    <p class="text-3xl font-extrabold mb-1">Operativo</p>
                    <p class="text-sm opacity-70 mb-5">Promedio de resolución: <%= String.format(java.util.Locale.US, "%.1f", averageResolutionDays) %> días.</p>
                    <a href="<%=request.getContextPath()%>/admin/reports" class="block text-center w-full bg-white/15 hover:bg-white/25 transition-colors text-white text-sm font-semibold py-2.5 rounded-xl">Ver reportes</a>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3">Acciones rápidas</p>
                    <div class="grid grid-cols-2 gap-3">
                        <a href="<%=request.getContextPath()%>/admin/requests?state=Pendiente" class="flex flex-col items-center gap-2 p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors text-gray-600 text-xs font-semibold"><i class="fa-solid fa-clock text-base text-gray-500"></i> Pendientes</a>
                        <a href="<%=request.getContextPath()%>/admin/reports" class="flex flex-col items-center gap-2 p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors text-gray-600 text-xs font-semibold"><i class="fa-regular fa-chart-bar text-base text-gray-500"></i> Reportes</a>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<script>
    const d = new Date();
    document.getElementById('todayDate').textContent = d.toLocaleDateString('es-CO', { day: '2-digit', month: 'long', year: 'numeric' });

    const months = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
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

    new Chart(document.getElementById('trendChart'), {
        type: 'line',
        data: {
            labels: months,
            datasets: [
                { label: 'Creadas', data: createdData, borderColor: '#0ea5e9', backgroundColor: 'rgba(14,165,233,0.12)', tension: 0.35, fill: true, pointRadius: 3, pointBackgroundColor: '#0ea5e9' },
                { label: 'Aprobadas', data: approvedData, borderColor: '#22c55e', backgroundColor: 'rgba(34,197,94,0.08)', tension: 0.35, fill: true, pointRadius: 3, pointBackgroundColor: '#22c55e' }
            ]
        },
        options: { responsive: true, plugins: { legend: { position: 'bottom' } }, scales: { x: { grid: { display: false } }, y: { beginAtZero: true, ticks: { precision: 0 } } } }
    });

    new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
            labels: ['Enviadas', 'Pendientes', 'Aprobadas', 'Rechazadas', 'Anuladas'],
            datasets: [{
                data: [<%= sentCount %>, <%= pendingCount %>, <%= approvedCount %>, <%= rejectedCount %>, <%= annulledCount %>],
                backgroundColor: ['#3b82f6', '#f59e0b', '#22c55e', '#ef4444', '#64748b'],
                borderWidth: 0
            }]
        },
        options: { responsive: true, plugins: { legend: { position: 'bottom' } }, cutout: '68%' }
    });
</script>

</body>
</html>