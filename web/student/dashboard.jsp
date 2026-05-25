<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%@ page import="model.Solicitud" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Estudiante - Sistema de Solicitudes</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous"
          referrerpolicy="no-referrer" />

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

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
    HttpSession sess = request.getSession(false);
    Student student = sess != null ? (Student) sess.getAttribute("user") : null;

    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");
    List<Solicitud> recent = (List<Solicitud>) request.getAttribute("recent");

    if (counts == null) {
        counts = new HashMap<String, Integer>();
    }

    if (recent == null) {
        recent = new ArrayList<Solicitud>();
    }

    int total = 0;

    for (Integer value : counts.values()) {
        total += value != null ? value : 0;
    }
%>

<aside class="w-[220px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png"
                 alt="FESC Logo"
                 class="h-10 object-contain"
                 onerror="this.outerHTML='<div class=\'flex items-center gap-2\'><div class=\'w-8 h-8 rounded-lg bg-[#c8102e] flex items-center justify-center\'><i class=\'fa-solid fa-graduation-cap text-white text-sm\'></i></div><span class=\'font-extrabold text-[#c8102e] text-lg tracking-tight\'>FESC Gestión</span></div>'">
        </div>

        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-graduate text-[#c8102e] text-xs"></i>
            </div>

            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">
                    <%= student.getNombreCompleto() %>
                </p>
                <p class="text-[10px] text-gray-400 mt-0.5">
                    Portal de Estudiante
                </p>
            </div>
        </div>

        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/student/dashboard"
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center"></i>
                Tablero
            </a>

            <a href="<%=request.getContextPath()%>/student/new-request"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-plus text-sm w-4 text-center text-gray-400"></i>
                Nueva Solicitud
            </a>

            <a href="<%=request.getContextPath()%>/student/requests"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i>
                Mis Solicitudes
            </a>

            <a href="<%=request.getContextPath()%>/student/profile"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center text-gray-400"></i>
                Mi Perfil
            </a>
        </nav>
    </div>

    <a href="<%=request.getContextPath()%>/logout"
       class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i>
        Cerrar sesión
    </a>
</aside>

<main class="flex-1 ml-[220px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">
                Panel estudiantil
            </p>
            <h1 class="text-lg font-extrabold text-gray-900">
                Bienvenido, <%= student.getNombre() %>
            </h1>
        </div>

        <div class="flex items-center gap-3">
            <a href="<%=request.getContextPath()%>/student/new-request"
               class="inline-flex items-center gap-2 rounded-xl bg-[#c8102e] px-5 py-3 text-sm font-bold text-white hover:bg-red-700 transition-colors">
                <i class="fa-solid fa-plus"></i>
                Nueva solicitud
            </a>

            <a href="<%=request.getContextPath()%>/student/profile"
               class="w-11 h-11 rounded-full bg-red-50 text-[#c8102e] flex items-center justify-center hover:bg-red-100 transition-colors"
               title="Mi perfil">
                <i class="fa-solid fa-user-graduate"></i>
            </a>
        </div>
    </header>

    <div class="p-8 flex-1">
        <div class="grid grid-cols-2 xl:grid-cols-4 gap-4 mb-6">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">
                    Total solicitudes
                </p>
                <div class="flex items-end justify-between gap-3">
                    <p class="text-3xl font-extrabold text-gray-900"><%= total %></p>
                    <i class="fa-solid fa-file-lines text-[#c8102e] text-xl"></i>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">
                    Enviadas
                </p>
                <div class="flex items-end justify-between gap-3">
                    <p class="text-3xl font-extrabold text-gray-900"><%= counts.getOrDefault("Enviada", 0) %></p>
                    <i class="fa-solid fa-paper-plane text-blue-500 text-xl"></i>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">
                    Pendientes
                </p>
                <div class="flex items-end justify-between gap-3">
                    <p class="text-3xl font-extrabold text-gray-900"><%= counts.getOrDefault("Pendiente", 0) %></p>
                    <i class="fa-solid fa-hourglass-half text-amber-500 text-xl"></i>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">
                    Aprobadas
                </p>
                <div class="flex items-end justify-between gap-3">
                    <p class="text-3xl font-extrabold text-gray-900"><%= counts.getOrDefault("Aprobada", 0) %></p>
                    <i class="fa-solid fa-circle-check text-green-500 text-xl"></i>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div class="xl:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <div class="flex items-start justify-between mb-5">
                    <div>
                        <h2 class="text-xl font-extrabold text-gray-900">
                            Solicitudes recientes
                        </h2>
                        <p class="text-sm text-gray-400 mt-1">
                            Seguimiento rápido de tus últimos movimientos.
                        </p>
                    </div>

                    <a href="<%=request.getContextPath()%>/student/requests"
                       class="text-sm font-bold text-[#c8102e] hover:underline">
                        Ver todas
                    </a>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead>
                        <tr class="border-b border-gray-100 text-left text-[11px] uppercase tracking-wider text-gray-400">
                            <th class="pb-3 pr-4">ID</th>
                            <th class="pb-3 pr-4">Tipo</th>
                            <th class="pb-3 pr-4">Fecha</th>
                            <th class="pb-3 pr-4">Estado</th>
                            <th class="pb-3 text-right">Acción</th>
                        </tr>
                        </thead>

                        <tbody>
                        <% if (recent.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="py-10 text-center text-sm text-gray-400">
                                    Aún no tienes solicitudes registradas.
                                </td>
                            </tr>
                        <% } %>

                        <% for (Solicitud sol : recent) { %>
                            <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                                <td class="py-4 pr-4 text-sm font-bold text-gray-500">
                                    #<%= sol.getId() %>
                                </td>

                                <td class="py-4 pr-4 text-sm font-semibold text-gray-800">
                                    <%= sol.getTipo().getNombre() %>
                                </td>

                                <td class="py-4 pr-4 text-sm text-gray-500">
                                    <%= sol.getFechaSolicitud() != null ? sol.getFechaSolicitud().toLocalDate().toString() : "" %>
                                </td>

                                <td class="py-4 pr-4 text-sm">
                                    <% String est = sol.getEstado(); %>

                                    <% if ("Pendiente".equals(est)) { %>
                                        <span class="inline-flex items-center rounded-lg bg-amber-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-amber-600 border border-amber-100">
                                            <i class="fa-solid fa-clock mr-1"></i> <%= est %>
                                        </span>
                                    <% } else if ("Aprobada".equals(est)) { %>
                                        <span class="inline-flex items-center rounded-lg bg-green-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-green-600 border border-green-100">
                                            <i class="fa-solid fa-check mr-1"></i> <%= est %>
                                        </span>
                                    <% } else if ("Rechazada".equals(est)) { %>
                                        <span class="inline-flex items-center rounded-lg bg-red-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-red-600 border border-red-100">
                                            <i class="fa-solid fa-xmark mr-1"></i> <%= est %>
                                        </span>
                                    <% } else if ("Enviada".equals(est)) { %>
                                        <span class="inline-flex items-center rounded-lg bg-blue-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-blue-600 border border-blue-100">
                                            <i class="fa-solid fa-paper-plane mr-1"></i> <%= est %>
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center rounded-lg bg-gray-100 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-gray-600">
                                            <%= est %>
                                        </span>
                                    <% } %>
                                </td>

                                <td class="py-4 text-right">
                                    <a href="<%=request.getContextPath()%>/student/request-detail?id=<%= sol.getId() %>"
                                       class="inline-flex h-8 w-8 items-center justify-center rounded-full text-[#c8102e] hover:bg-red-50 transition-colors">
                                        <i class="fa-regular fa-eye"></i>
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="space-y-6">
                <div class="bg-[#c8102e] rounded-2xl p-6 text-white shadow-lg shadow-red-500/10 relative overflow-hidden">
                    <div class="absolute inset-y-0 right-0 w-40 bg-white/10 -skew-x-12 translate-x-10"></div>

                    <p class="text-xs font-bold uppercase tracking-[0.24em] text-white/70">
                        Atención
                    </p>

                    <h3 class="mt-2 text-2xl font-extrabold leading-tight">
                        Usa el chat para resolver dudas antes del dictamen final.
                    </h3>

                    <p class="mt-3 text-sm text-white/75">
                        Cada solicitud puede tener mensajes y archivos entre estudiante y administración.
                    </p>

                    <a href="<%=request.getContextPath()%>/student/new-request"
                       class="mt-5 inline-flex items-center gap-2 rounded-xl bg-white px-4 py-2 text-sm font-bold text-[#c8102e] hover:bg-red-50 transition-colors">
                        <i class="fa-solid fa-plus"></i>
                        Crear solicitud
                    </a>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                    <div class="flex items-start justify-between mb-4">
                        <h3 class="text-lg font-extrabold text-gray-900">
                            Información personal
                        </h3>

                        <a href="<%=request.getContextPath()%>/student/profile"
                           class="text-xs font-bold text-[#c8102e] hover:underline">
                            Ver perfil
                        </a>
                    </div>

                    <div class="space-y-3 text-sm">
                        <p>
                            <span class="font-semibold text-gray-500">Nombre:</span>
                            <%= student.getNombreCompleto() %>
                        </p>

                        <p>
                            <span class="font-semibold text-gray-500">Correo:</span>
                            <%= student.getEmail() %>
                        </p>

                        <p>
                            <span class="font-semibold text-gray-500">Programa:</span>
                            <%= student.getProgramaNombre() != null ? student.getProgramaNombre() : "No registrado" %>
                        </p>

                        <p>
                            <span class="font-semibold text-gray-500">Sede:</span>
                            <%= student.getSedeNombre() != null ? student.getSedeNombre() : "No registrada" %>
                        </p>

                        <p>
                            <span class="font-semibold text-gray-500">Jornada:</span>
                            <%= student.getJornadaNombre() != null ? student.getJornadaNombre() : "No registrada" %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>