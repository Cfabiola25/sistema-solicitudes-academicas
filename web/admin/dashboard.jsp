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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }

        /* Sidebar active state */
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

        /* Stat card trend badges */
        .trend-up   { color: #16a34a; background: #dcfce7; }
        .trend-flat { color: #d97706; background: #fef9c3; }
        .trend-down { color: #c8102e; background: #fee2e2; }

        /* System status card */
        .status-card {
            background: linear-gradient(135deg, #c8102e 0%, #9b0c23 100%);
            position: relative;
            overflow: hidden;
        }
        .status-card::before {
            content: '';
            position: absolute;
            right: -30px; top: -30px;
            width: 160px; height: 160px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }
        .status-card::after {
            content: '';
            position: absolute;
            right: 30px; bottom: -50px;
            width: 120px; height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }

        /* Scrollbar thin */
        ::-webkit-scrollbar { width: 5px; height: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 9999px; }
    </style>
</head>
<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Map<String, Integer> counts  = (Map<String, Integer>) request.getAttribute("counts");
    Map<Integer, Integer> monthly = (Map<Integer, Integer>) request.getAttribute("monthly");
    List<Solicitud> pending       = (List<Solicitud>) request.getAttribute("pending");
    int total = 0;
    for (Integer v : counts.values()) total += v;
    int pendingCount  = counts.getOrDefault("Pendiente", 0);
    int approvedCount = counts.getOrDefault("Aprobada",  0);
    int rejectedCount = counts.getOrDefault("Rechazada", 0);
%>

<!-- ───────── SIDEBAR ───────── -->
<aside class="w-[210px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <!-- Logo -->
    <div>
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png" alt="FESC Logo"
                class="h-10 object-contain"
                onerror="this.outerHTML='<div class=\'flex items-center gap-2\'><div class=\'w-8 h-8 rounded-lg bg-[#c8102e] flex items-center justify-center\'><i class=\'fa-solid fa-graduation-cap text-white text-sm\'></i></div><span class=\'font-extrabold text-[#c8102e] text-lg tracking-tight\'>FESC Gestión</span></div>'">
        </div>

        <!-- User chip -->
        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-xs"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">Administración</p>
                <p class="text-[10px] text-gray-400 mt-0.5">Panel Central</p>
            </div>
        </div>

        <!-- Nav -->
        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i> Solicitudes
            </a>
            <a href="#"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center text-gray-400"></i> Estudiantes
            </a>
            <a href="#"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center text-gray-400"></i> Reportes
            </a>
            <a href="#"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-gear text-sm w-4 text-center text-gray-400"></i> Configuración
            </a>
        </nav>
    </div>

    <!-- Logout -->
    <a href="<%=request.getContextPath()%>/logout"
       class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i> Cerrar sesión
    </a>
</aside>

<!-- ───────── MAIN CONTENT ───────── -->
<main class="flex-1 ml-[210px] min-h-screen flex flex-col">

    <!-- Top bar -->
    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div></div><!-- spacer -->
        <div class="flex items-center gap-4">
            <button class="relative w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors">
                <i class="fa-regular fa-bell text-base"></i>
                <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-[#c8102e] rounded-full border-2 border-white"></span>
            </button>
            <button class="w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors">
                <i class="fa-regular fa-circle-question text-base"></i>
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

        <!-- Page title + date -->
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

        <!-- ─ STAT CARDS ─ -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <!-- Total -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="flex items-start justify-between mb-3">
                    <div class="w-10 h-10 rounded-xl bg-[#c8102e]/10 flex items-center justify-center">
                        <i class="fa-solid fa-chart-simple text-[#c8102e] text-sm"></i>
                    </div>
                    <span class="trend-up text-xs font-bold px-2 py-0.5 rounded-full">↗ 12%</span>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Total Solicitudes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= total %></p>
            </div>

            <!-- Pendientes -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="flex items-start justify-between mb-3">
                    <div class="w-10 h-10 rounded-xl bg-amber-50 flex items-center justify-center">
                        <i class="fa-solid fa-clock text-amber-500 text-sm"></i>
                    </div>
                    <span class="trend-flat text-xs font-bold px-2 py-0.5 rounded-full">→ 0%</span>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Pendientes</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= pendingCount %></p>
            </div>

            <!-- Aprobadas -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="flex items-start justify-between mb-3">
                    <div class="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center">
                        <i class="fa-solid fa-circle-check text-green-500 text-sm"></i>
                    </div>
                    <span class="trend-up text-xs font-bold px-2 py-0.5 rounded-full">↗ 8%</span>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Aprobadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= approvedCount %></p>
            </div>

            <!-- Rechazadas -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <div class="flex items-start justify-between mb-3">
                    <div class="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center">
                        <i class="fa-solid fa-circle-xmark text-[#c8102e] text-sm"></i>
                    </div>
                    <span class="trend-down text-xs font-bold px-2 py-0.5 rounded-full">↘ 3%</span>
                </div>
                <p class="text-xs text-gray-400 font-medium mb-1">Rechazadas</p>
                <p class="text-3xl font-extrabold text-gray-900"><%= rejectedCount %></p>
            </div>
        </div>

        <!-- ─ CHARTS ROW ─ -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 mb-6">
            <!-- Bar chart -->
            <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="mb-4">
                    <h3 class="font-bold text-gray-800">Rendimiento Mensual</h3>
                    <p class="text-xs text-gray-400 mt-0.5">Volumen de solicitudes últimos 6 meses</p>
                </div>
                <!-- Legend -->
                <div class="flex gap-4 mb-4">
                    <span class="flex items-center gap-1.5 text-xs text-gray-500">
                        <span class="w-2.5 h-2.5 rounded-sm bg-green-500 inline-block"></span> Aprobado
                    </span>
                    <span class="flex items-center gap-1.5 text-xs text-gray-500">
                        <span class="w-2.5 h-2.5 rounded-sm bg-amber-400 inline-block"></span> Pendiente
                    </span>
                    <span class="flex items-center gap-1.5 text-xs text-gray-500">
                        <span class="w-2.5 h-2.5 rounded-sm bg-[#c8102e] inline-block"></span> Rechazado
                    </span>
                </div>
                <canvas id="monthlyChart" height="160"></canvas>
            </div>

            <!-- System status + quick actions -->
            <div class="flex flex-col gap-4">
                <!-- Status card -->
                <div class="status-card rounded-2xl p-6 text-white flex-1">
                    <div class="flex items-center gap-2 mb-3">
                        <span class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span>
                        <span class="text-xs font-bold uppercase tracking-widest opacity-80">Estado del Sistema</span>
                    </div>
                    <p class="text-3xl font-extrabold mb-1">Operativo</p>
                    <p class="text-sm opacity-70 mb-5">Sincronización en tiempo real activa.</p>
                    <button class="w-full bg-white/15 hover:bg-white/25 transition-colors text-white text-sm font-semibold py-2.5 rounded-xl">
                        Ver Logs Técnicos
                    </button>
                </div>

                <!-- Quick actions -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3">Acciones Rápidas</p>
                    <div class="grid grid-cols-2 gap-3">
                        <button class="flex flex-col items-center gap-2 p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors text-gray-600 text-xs font-semibold">
                            <i class="fa-solid fa-download text-base text-gray-500"></i> Exportar
                        </button>
                        <button class="flex flex-col items-center gap-2 p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors text-gray-600 text-xs font-semibold">
                            <i class="fa-regular fa-envelope text-base text-gray-500"></i> Correo
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ─ PENDING TABLE ─ -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="flex items-center justify-between mb-5">
                <div>
                    <h3 class="font-bold text-gray-800">Solicitudes Pendientes</h3>
                    <p class="text-xs text-gray-400 mt-0.5">Revisiones requeridas para esta semana</p>
                </div>
                <a href="<%=request.getContextPath()%>/admin/requests"
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
                    <% for (Solicitud sol : pending) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-3.5 px-2 text-sm font-bold text-gray-400">
                                #<%= sol.getId() %>
                            </td>
                            <td class="py-3.5 px-2">
                                <div class="flex items-center gap-2.5">
                                    <div class="w-7 h-7 rounded-full bg-[#c8102e]/10 flex items-center justify-center flex-shrink-0">
                                        <i class="fa-solid fa-user text-[#c8102e] text-[10px]"></i>
                                    </div>
                                    <span class="text-sm font-semibold text-gray-800">
                                        <%= sol.getEstudiante().getNombre() %> <%= sol.getEstudiante().getApellido() %>
                                    </span>
                                </div>
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

    </div><!-- /page body -->

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

<script>
    // ── Date ──
    const d = new Date();
    const opts = { day: '2-digit', month: 'long', year: 'numeric' };
    document.getElementById('todayDate').textContent = d.toLocaleDateString('es-CO', opts);

    // ── Chart ──
    const ctx = document.getElementById('monthlyChart').getContext('2d');
    const labels = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];

    // Approved data from JSP
    const approved = [
        <%= monthly.getOrDefault(1,0) %>, <%= monthly.getOrDefault(2,0) %>,
        <%= monthly.getOrDefault(3,0) %>, <%= monthly.getOrDefault(4,0) %>,
        <%= monthly.getOrDefault(5,0) %>, <%= monthly.getOrDefault(6,0) %>,
        <%= monthly.getOrDefault(7,0) %>, <%= monthly.getOrDefault(8,0) %>,
        <%= monthly.getOrDefault(9,0) %>, <%= monthly.getOrDefault(10,0) %>,
        <%= monthly.getOrDefault(11,0) %>, <%= monthly.getOrDefault(12,0) %>
    ];

    // Simulated pending / rejected as fractions of approved for visual fidelity
    const pendingData  = approved.map(v => Math.round(v * 0.08));
    const rejectedData = approved.map(v => Math.round(v * 0.05));

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                { label: 'Rechazado', data: rejectedData, backgroundColor: '#c8102e',   borderRadius: 0, stack: 's' },
                { label: 'Pendiente', data: pendingData,  backgroundColor: '#f59e0b',   borderRadius: 0, stack: 's' },
                { label: 'Aprobado',  data: approved,     backgroundColor: '#22c55e',   borderRadius: { topLeft:6, topRight:6 }, stack: 's' }
            ]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false }, tooltip: { mode: 'index', intersect: false } },
            scales: {
                x: { stacked: true, grid: { display: false }, ticks: { font: { size: 11, family: 'Plus Jakarta Sans' }, color: '#9ca3af' } },
                y: { stacked: true, beginAtZero: true, grid: { color: '#f3f4f6' }, ticks: { font: { size: 11, family: 'Plus Jakarta Sans' }, color: '#9ca3af' }, border: { display: false } }
            }
        }
    });
</script>
</body>
</html>
