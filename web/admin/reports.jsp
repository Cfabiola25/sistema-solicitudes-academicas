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
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
    List<Solicitud> recent = (List<Solicitud>) request.getAttribute("recent");
    Integer total = (Integer) request.getAttribute("total");
    Integer approved = (Integer) request.getAttribute("approved");
    Integer pending = (Integer) request.getAttribute("pending");
    Integer rejected = (Integer) request.getAttribute("rejected");
    Double approvalRate = (Double) request.getAttribute("approvalRate");
    if (recent == null) {
        recent = new ArrayList<Solicitud>();
    }
%>
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
            <a href="<%=request.getContextPath()%>/admin/dashboard" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center text-gray-400"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i> Solicitudes
            </a>
            <a href="<%=request.getContextPath()%>/admin/students" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center text-gray-400"></i> Estudiantes
            </a>
            <a href="<%=request.getContextPath()%>/admin/reports" class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center"></i> Reportes
            </a>
        </nav>
    </div>
    <a href="<%=request.getContextPath()%>/logout" class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i> Cerrar sesión
    </a>
</aside>
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
        <div class="grid grid-cols-2 xl:grid-cols-5 gap-4">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Total</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= total != null ? total : 0 %></p>
            </div>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Pendientes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= pending != null ? pending : 0 %></p>
            </div>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Aprobadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= approved != null ? approved : 0 %></p>
            </div>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Rechazadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= rejected != null ? rejected : 0 %></p>
            </div>
            <div class="bg-[#c8102e] rounded-2xl shadow-sm p-5 text-white">
                <p class="text-xs font-bold uppercase tracking-wider mb-2 text-white/70">Tasa de aprobación</p>
                <p class="text-3xl font-extrabold"><%= String.format(java.util.Locale.US, "%.1f", approvalRate != null ? approvalRate : 0.0) %>%</p>
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
                <h2 class="text-xl font-extrabold text-gray-900 mb-4">Distribución</h2>
                <div class="space-y-4">
                    <div>
                        <div class="flex items-center justify-between text-sm mb-2"><span class="font-semibold text-gray-600">Pendientes</span><span><%= pending != null ? pending : 0 %></span></div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden"><div class="h-full bg-amber-400" style="width: <%= total != null && total > 0 ? (pending * 100.0 / total) : 0 %>%"></div></div>
                    </div>
                    <div>
                        <div class="flex items-center justify-between text-sm mb-2"><span class="font-semibold text-gray-600">Aprobadas</span><span><%= approved != null ? approved : 0 %></span></div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden"><div class="h-full bg-green-500" style="width: <%= total != null && total > 0 ? (approved * 100.0 / total) : 0 %>%"></div></div>
                    </div>
                    <div>
                        <div class="flex items-center justify-between text-sm mb-2"><span class="font-semibold text-gray-600">Rechazadas</span><span><%= rejected != null ? rejected : 0 %></span></div>
                        <div class="h-2 rounded-full bg-gray-100 overflow-hidden"><div class="h-full bg-[#c8102e]" style="width: <%= total != null && total > 0 ? (rejected * 100.0 / total) : 0 %>%"></div></div>
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
                <a href="<%=request.getContextPath()%>/admin/requests" class="text-sm font-bold text-[#c8102e] hover:underline">Ir al listado</a>
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
                                <td colspan="5" class="py-10 text-center text-sm text-gray-400">No hay actividad reciente para mostrar.</td>
                            </tr>
                        <% } %>
                        <% for (Solicitud sol : recent) { %>
                            <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                                <td class="py-4 pr-4 text-sm font-bold text-gray-500">#<%= sol.getId() %></td>
                                <td class="py-4 pr-4 text-sm font-semibold text-gray-800"><%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %></td>
                                <td class="py-4 pr-4 text-sm text-gray-600"><%= sol.getTipo().getNombre() %></td>
                                <td class="py-4 pr-4 text-sm text-gray-600"><%= sol.getEstado() %></td>
                                <td class="py-4 text-right text-sm text-gray-500"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
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
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, grid: { color: '#f3f4f6' }, ticks: { precision: 0 } }
            }
        }
    });
</script>
</body>
</html>
