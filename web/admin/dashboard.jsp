<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tablero de Gestión - FESC Admin</title>
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
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
    List<Solicitud> pending = (List<Solicitud>) request.getAttribute("pending");

    if (counts == null) counts = new HashMap<String, Integer>();
    if (monthly == null) monthly = new HashMap<Integer, Integer>();
    if (pending == null) pending = new ArrayList<Solicitud>();

    int total = 0;
    for (Integer v : counts.values()) {
        if (v != null) total += v;
    }

    int sentCount = counts.getOrDefault("Enviada", 0);
    int pendingCount = counts.getOrDefault("Pendiente", 0);
    int approvedCount = counts.getOrDefault("Aprobada", 0);

    int expiredCount = request.getAttribute("expiredCount") != null ? (Integer) request.getAttribute("expiredCount") : 0;
    int aboutToExpireCount = request.getAttribute("aboutToExpireCount") != null ? (Integer) request.getAttribute("aboutToExpireCount") : 0;
%>

<aside class="w-[210px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png"
                 alt="FESC Logo"
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
            <a href="<%=request.getContextPath()%>/admin/dashboard" class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i> Solicitudes
            </a>
            <a href="<%=request.getContextPath()%>/admin/students" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user-graduate text-sm w-4 text-center text-gray-400"></i> Estudiantes
            </a>
            <a href="<%=request.getContextPath()%>/admin/admin-users" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-users-gear text-sm w-4 text-center text-gray-400"></i> Administradores
            </a>
            <a href="<%=request.getContextPath()%>/admin/programs" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-graduation-cap text-sm w-4 text-center text-gray-400"></i> Programas
            </a>
            <a href="<%=request.getContextPath()%>/admin/request-types" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-sliders text-sm w-4 text-center text-gray-400"></i> Tipos Solicitud
            </a>
            <a href="<%=request.getContextPath()%>/admin/reports" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center text-gray-400"></i> Reportes
            </a>
            <a href="<%=request.getContextPath()%>/admin/profile" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center text-gray-400"></i> Mi Perfil
            </a>           
        </nav>
    </div>

    <a href="<%=request.getContextPath()%>/logout" class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i> Cerrar sesión
    </a>
</aside>

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

    <div class="p-8 flex-1">

        <div class="flex items-start justify-between mb-6">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">Tablero de Gestión</h1>
                <p class="text-sm text-gray-400 mt-1">Resumen general del estado de solicitudes académicas hoy.</p>
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-500 bg-white border border-gray-100 rounded-xl px-4 py-2 shadow-sm">
                <i class="fa-regular fa-calendar text-[#c8102e]"></i>
                <span id="todayDate"></span>
            </div>
        </div>

        <div class="grid grid-cols-2 lg:grid-cols-6 gap-4 mb-6">

            <a href="<%=request.getContextPath()%>/admin/requests"
               class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-[#c8102e]/10 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-chart-simple text-[#c8102e] text-sm"></i>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Total Solicitudes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= total %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Enviada"
               class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-paper-plane text-blue-500 text-sm"></i>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Enviadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= sentCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Pendiente"
               class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-amber-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-clock text-amber-500 text-sm"></i>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Pendientes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= pendingCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Aprobada"
               class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-circle-check text-green-500 text-sm"></i>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Aprobadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= approvedCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=Vencidas"
               class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-triangle-exclamation text-[#c8102e] text-sm"></i>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Vencidas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= expiredCount %></p>
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests?state=PorVencer"
               class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:-translate-y-1 hover:shadow-md transition-all">
                <div class="w-10 h-10 rounded-xl bg-yellow-50 flex items-center justify-center mb-3">
                    <i class="fa-solid fa-hourglass-half text-yellow-500 text-sm"></i>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Por vencer</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= aboutToExpireCount %></p>
            </a>

        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 mb-6">
            <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="mb-4">
                    <h3 class="font-bold text-gray-800">Solicitudes aprobadas por mes</h3>
                    <p class="text-xs text-gray-400 mt-0.5">Datos reales según las solicitudes aprobadas del año actual.</p>
                </div>

                <canvas id="monthlyChart" height="160"></canvas>
            </div>

            <div class="flex flex-col gap-4">
                <div class="status-card rounded-2xl p-6 text-white flex-1">
                    <div class="flex items-center gap-2 mb-3">
                        <span class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span>
                        <span class="text-xs font-bold uppercase tracking-widest opacity-80">Estado del Sistema</span>
                    </div>
                    <p class="text-3xl font-extrabold mb-1">Operativo</p>
                    <p class="text-sm opacity-70 mb-5">Gestión de solicitudes activa.</p>
                    <a href="<%=request.getContextPath()%>/admin/requests"
                       class="block text-center w-full bg-white/15 hover:bg-white/25 transition-colors text-white text-sm font-semibold py-2.5 rounded-xl">
                        Revisar solicitudes
                    </a>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3">Acciones Rápidas</p>
                    <div class="grid grid-cols-2 gap-3">
                        <a href="<%=request.getContextPath()%>/admin/requests?state=Pendiente"
                           class="flex flex-col items-center gap-2 p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors text-gray-600 text-xs font-semibold">
                            <i class="fa-solid fa-clock text-base text-gray-500"></i> Pendientes
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/reports"
                           class="flex flex-col items-center gap-2 p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors text-gray-600 text-xs font-semibold">
                            <i class="fa-regular fa-chart-bar text-base text-gray-500"></i> Reportes
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="flex items-center justify-between mb-5">
                <div>
                    <h3 class="font-bold text-gray-800">Solicitudes Pendientes</h3>
                    <p class="text-xs text-gray-400 mt-0.5">Primeras solicitudes pendientes para revisión.</p>
                </div>
                <a href="<%=request.getContextPath()%>/admin/requests?state=Pendiente"
                   class="text-xs font-bold text-[#c8102e] hover:underline">Ver todo</a>
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
                        <tr>
                            <td colspan="5" class="py-10 text-center text-sm text-gray-400">
                                No hay solicitudes pendientes.
                            </td>
                        </tr>
                    <% } %>

                    <% for (Solicitud sol : pending) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-3.5 px-2 text-sm font-bold text-gray-400">#<%= sol.getId() %></td>
                            <td class="py-3.5 px-2 text-sm font-semibold text-gray-800">
                                <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %>
                            </td>
                            <td class="py-3.5 px-2">
                                <span class="inline-block text-xs font-semibold text-gray-600 bg-gray-100 px-2.5 py-1 rounded-lg">
                                    <%= sol.getTipo().getNombre() %>
                                </span>
                            </td>
                            <td class="py-3.5 px-2 text-sm text-gray-500">
                                <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %>
                            </td>
                            <td class="py-3.5 px-2 text-right">
                                <a href="<%=request.getContextPath()%>/admin/request-detail?id=<%= sol.getId() %>"
                                   class="w-8 h-8 inline-flex items-center justify-center rounded-full text-[#c8102e] hover:bg-red-50 transition-colors">
                                    <i class="fa-regular fa-eye text-base"></i>
                                </a>
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
    const d = new Date();
    document.getElementById('todayDate').textContent = d.toLocaleDateString('es-CO', {
        day: '2-digit',
        month: 'long',
        year: 'numeric'
    });

    const ctx = document.getElementById('monthlyChart').getContext('2d');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'],
            datasets: [{
                label: 'Aprobadas',
                data: [
                    <%= monthly.getOrDefault(1,0) %>, <%= monthly.getOrDefault(2,0) %>,
                    <%= monthly.getOrDefault(3,0) %>, <%= monthly.getOrDefault(4,0) %>,
                    <%= monthly.getOrDefault(5,0) %>, <%= monthly.getOrDefault(6,0) %>,
                    <%= monthly.getOrDefault(7,0) %>, <%= monthly.getOrDefault(8,0) %>,
                    <%= monthly.getOrDefault(9,0) %>, <%= monthly.getOrDefault(10,0) %>,
                    <%= monthly.getOrDefault(11,0) %>, <%= monthly.getOrDefault(12,0) %>
                ],
                backgroundColor: '#22c55e',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, ticks: { stepSize: 1 } }
            }
        }
    });
</script>

</body>
</html>