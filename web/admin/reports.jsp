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
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
    List<Solicitud> recent = (List<Solicitud>) request.getAttribute("recent");

    if (counts == null) counts = new HashMap<String, Integer>();
    if (monthly == null) monthly = new HashMap<Integer, Integer>();
    if (recent == null) recent = new ArrayList<Solicitud>();

    Integer total = (Integer) request.getAttribute("total");
    Integer sent = (Integer) request.getAttribute("sent");
    Integer pending = (Integer) request.getAttribute("pending");
    Integer approved = (Integer) request.getAttribute("approved");
    Integer rejected = (Integer) request.getAttribute("rejected");
    Double approvalRate = (Double) request.getAttribute("approvalRate");

    int totalValue = total != null ? total : 0;
    int sentValue = sent != null ? sent : counts.getOrDefault("Enviada", 0);
    int pendingValue = pending != null ? pending : counts.getOrDefault("Pendiente", 0);
    int approvedValue = approved != null ? approved : counts.getOrDefault("Aprobada", 0);
    int rejectedValue = rejected != null ? rejected : counts.getOrDefault("Rechazada", 0);
    double approvalRateValue = approvalRate != null ? approvalRate : 0.0;
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

        <div class="grid grid-cols-2 xl:grid-cols-6 gap-4">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="w-10 h-10 rounded-xl bg-[#c8102e]/10 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-chart-simple text-[#c8102e] text-sm"></i>
                </div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Total</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= totalValue %></p>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-paper-plane text-blue-500 text-sm"></i>
                </div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Enviadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= sentValue %></p>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="w-10 h-10 rounded-xl bg-amber-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-clock text-amber-500 text-sm"></i>
                </div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Pendientes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= pendingValue %></p>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-circle-check text-green-500 text-sm"></i>
                </div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Aprobadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= approvedValue %></p>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-circle-xmark text-[#c8102e] text-sm"></i>
                </div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Rechazadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= rejectedValue %></p>
            </div>

            <div class="bg-[#c8102e] rounded-2xl shadow-sm p-5 text-white">
                <div class="w-10 h-10 rounded-xl bg-white/15 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-percent text-white text-sm"></i>
                </div>
                <p class="text-xs font-bold uppercase tracking-wider mb-2 text-white/70">Tasa aprobación</p>
                <p class="text-3xl font-extrabold"><%= String.format(java.util.Locale.US, "%.1f", approvalRateValue) %>%</p>
            </div>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h2 class="text-xl font-extrabold text-gray-900">Solicitudes aprobadas por mes</h2>
                        <p class="text-sm text-gray-400 mt-1">Volumen de aprobaciones durante el año actual.</p>
                    </div>
                </div>
                <canvas id="reportsChart" height="130"></canvas>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-xl font-extrabold text-gray-900 mb-4">Distribución por estado</h2>

                <div class="space-y-4">
                    <div>
                        <div class="flex items-center justify-between text-sm mb-2">
                            <span class="font-semibold text-gray-600">Enviadas</span>
                            <span><%= sentValue %></span>
                        </div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                            <div class="h-full bg-blue-500" style="width: <%= totalValue > 0 ? (sentValue * 100.0 / totalValue) : 0 %>%"></div>
                        </div>
                    </div>

                    <div>
                        <div class="flex items-center justify-between text-sm mb-2">
                            <span class="font-semibold text-gray-600">Pendientes</span>
                            <span><%= pendingValue %></span>
                        </div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                            <div class="h-full bg-amber-400" style="width: <%= totalValue > 0 ? (pendingValue * 100.0 / totalValue) : 0 %>%"></div>
                        </div>
                    </div>

                    <div>
                        <div class="flex items-center justify-between text-sm mb-2">
                            <span class="font-semibold text-gray-600">Aprobadas</span>
                            <span><%= approvedValue %></span>
                        </div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                            <div class="h-full bg-green-500" style="width: <%= totalValue > 0 ? (approvedValue * 100.0 / totalValue) : 0 %>%"></div>
                        </div>
                    </div>

                    <div>
                        <div class="flex items-center justify-between text-sm mb-2">
                            <span class="font-semibold text-gray-600">Rechazadas</span>
                            <span><%= rejectedValue %></span>
                        </div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                            <div class="h-full bg-[#c8102e]" style="width: <%= totalValue > 0 ? (rejectedValue * 100.0 / totalValue) : 0 %>%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="flex items-start justify-between mb-4">
                <div>
                    <h2 class="text-xl font-extrabold text-gray-900">Actividad reciente</h2>
                    <p class="text-sm text-gray-400 mt-1">Últimas solicitudes registradas en el sistema.</p>
                </div>
                <a href="<%=request.getContextPath()%>/admin/requests" class="text-sm font-bold text-[#c8102e] hover:underline">
                    Ir al listado
                </a>
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
                        <tr>
                            <td colspan="5" class="py-10 text-center text-sm text-gray-400">
                                No hay actividad reciente para mostrar.
                            </td>
                        </tr>
                    <% } %>

                    <% for (Solicitud sol : recent) { %>
                        <%
                            String estado = sol.getEstado();
                            String estadoClass = "bg-gray-100 text-gray-600 border-gray-200";
                            String estadoIcon = "fa-circle";

                            if ("Enviada".equals(estado)) {
                                estadoClass = "bg-blue-50 text-blue-600 border-blue-100";
                                estadoIcon = "fa-paper-plane";
                            } else if ("Pendiente".equals(estado)) {
                                estadoClass = "bg-amber-50 text-amber-600 border-amber-100";
                                estadoIcon = "fa-clock";
                            } else if ("Aprobada".equals(estado)) {
                                estadoClass = "bg-green-50 text-green-600 border-green-100";
                                estadoIcon = "fa-check";
                            } else if ("Rechazada".equals(estado)) {
                                estadoClass = "bg-red-50 text-red-600 border-red-100";
                                estadoIcon = "fa-xmark";
                            }
                        %>

                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 pr-4 text-sm font-bold text-gray-500">#<%= sol.getId() %></td>
                            <td class="py-4 pr-4 text-sm font-semibold text-gray-800">
                                <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %>
                            </td>
                            <td class="py-4 pr-4 text-sm text-gray-600">
                                <%= sol.getTipo().getNombre() %>
                            </td>
                            <td class="py-4 pr-4 text-sm">
                                <span class="inline-flex items-center rounded-lg px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider border <%= estadoClass %>">
                                    <i class="fa-solid <%= estadoIcon %> mr-1"></i>
                                    <%= estado %>
                                </span>
                            </td>
                            <td class="py-4 text-right text-sm text-gray-500">
                                <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<script>
    const chart = document.getElementById('reportsChart');
    const monthlyData = [
        <%= monthly.getOrDefault(1,0) %>, <%= monthly.getOrDefault(2,0) %>, <%= monthly.getOrDefault(3,0) %>,
        <%= monthly.getOrDefault(4,0) %>, <%= monthly.getOrDefault(5,0) %>, <%= monthly.getOrDefault(6,0) %>,
        <%= monthly.getOrDefault(7,0) %>, <%= monthly.getOrDefault(8,0) %>, <%= monthly.getOrDefault(9,0) %>,
        <%= monthly.getOrDefault(10,0) %>, <%= monthly.getOrDefault(11,0) %>, <%= monthly.getOrDefault(12,0) %>
    ];

    new Chart(chart, {
        type: 'bar',
        data: {
            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
            datasets: [{
                label: 'Aprobadas',
                data: monthlyData,
                backgroundColor: '#c8102e',
                borderRadius: 10,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, grid: { color: '#f3f4f6' }, ticks: { precision: 0 } }
            }
        }
    });
</script>

</body>
</html>