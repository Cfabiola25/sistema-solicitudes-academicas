<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>
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
%>
<aside class="w-[220px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png" alt="FESC Logo"
                class="h-10 object-contain"
                onerror="this.outerHTML='<div class=\'flex items-center gap-2\'><div class=\'w-8 h-8 rounded-lg bg-[#c8102e] flex items-center justify-center\'><i class=\'fa-solid fa-graduation-cap text-white text-sm\'></i></div><span class=\'font-extrabold text-[#c8102e] text-lg tracking-tight\'>FESC Gestión</span></div>'">
        </div>
        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-graduate text-[#c8102e] text-xs"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">Estudiante</p>
                <p class="text-[10px] text-gray-400 mt-0.5">Mis Solicitudes</p>
            </div>
        </div>
        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/student/dashboard" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center text-gray-400"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/student/new-request" class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-plus text-sm w-4 text-center text-gray-400"></i> Nueva Solicitud
            </a>
            <a href="<%=request.getContextPath()%>/student/requests" class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center"></i> Mis Solicitudes
            </a>
        </nav>
    </div>
    <a href="<%=request.getContextPath()%>/logout" class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i> Cerrar sesión
    </a>
</aside>

<main class="flex-1 ml-[220px] min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">Mis solicitudes</p>
            <h1 class="text-lg font-extrabold text-gray-900">Historial completo</h1>
        </div>
        <a href="<%=request.getContextPath()%>/student/new-request" class="flex items-center gap-2 rounded-xl bg-[#c8102e] px-4 py-2 text-sm font-bold text-white shadow-sm shadow-red-600/20 hover:bg-red-700 transition-colors">
            <i class="fa-solid fa-plus"></i> Crear solicitud
        </a>
    </header>

    <div class="p-8 flex-1">
        <form action="" method="get" class="flex gap-3 mb-6">
            <label class="text-sm font-semibold text-gray-600">Filtro:</label>
            <select name="state" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 cursor-pointer">
                <option value="" <%= "".equals(request.getParameter("state") != null ? request.getParameter("state") : "") ? "selected" : "" %>>Todos</option>
                <option value="Enviada" <%= "Enviada".equals(request.getParameter("state")) ? "selected" : "" %>>Enviada</option>
                <option value="Pendiente" <%= "Pendiente".equals(request.getParameter("state")) ? "selected" : "" %>>Pendiente</option>
                <option value="Aprobada" <%= "Aprobada".equals(request.getParameter("state")) ? "selected" : "" %>>Aprobada</option>
                <option value="Rechazada" <%= "Rechazada".equals(request.getParameter("state")) ? "selected" : "" %>>Rechazada</option>
            </select>
            <button type="submit" class="px-4 py-2 bg-[#c8102e] text-white rounded-lg font-semibold hover:bg-red-700 transition-colors flex items-center gap-2">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
        </form>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="min-w-full">
                <thead>
                    <tr class="bg-gray-50 border-b border-gray-100">
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">ID</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Tipo</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Fecha</th>
                        <th class="py-4 px-6 text-left text-[11px] font-bold uppercase tracking-wider text-gray-400">Estado</th>
                        <th class="py-4 px-6 text-right text-[11px] font-bold uppercase tracking-wider text-gray-400">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (list.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="py-10 text-center text-sm text-gray-400">No hay solicitudes para mostrar.</td>
                        </tr>
                    <% } %>
                    <% for (Solicitud sol : list) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 px-6 text-sm font-bold text-gray-500">#<%= sol.getId() %></td>
                            <td class="py-4 px-6 text-sm font-semibold text-gray-800"><%= sol.getTipo().getNombre() %></td>
                            <td class="py-4 px-6 text-sm text-gray-500"><%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %></td>
                            <td class="py-4 px-6 text-sm">
                                <% String est = sol.getEstado(); %>
                                <% if ("Pendiente".equals(est)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-amber-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-amber-600 border border-amber-100"><i class="fa-solid fa-clock mr-1"></i> <%= est %></span>
                                <% } else if ("Aprobada".equals(est)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-green-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-green-600 border border-green-100"><i class="fa-solid fa-check mr-1"></i> <%= est %></span>
                                <% } else if ("Rechazada".equals(est)) { %>
                                    <span class="inline-flex items-center rounded-lg bg-red-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-red-600 border border-red-100"><i class="fa-solid fa-xmark mr-1"></i> <%= est %></span>
                                <% } else { %>
                                    <span class="inline-flex items-center rounded-lg bg-blue-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-blue-600 border border-blue-100"><i class="fa-solid fa-paper-plane mr-1"></i> <%= est %></span>
                                <% } %>
                            </td>
                            <td class="py-4 px-6 text-right">
                                <a href="<%=request.getContextPath()%>/student/request-detail?id=<%= sol.getId() %>" class="inline-flex h-8 w-8 items-center justify-center rounded-full text-[#c8102e] hover:bg-red-50 transition-colors">
                                    <i class="fa-regular fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>