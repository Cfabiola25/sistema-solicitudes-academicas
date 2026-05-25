<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Admin" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administradores - FESC Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    List<Admin> admins = (List<Admin>) request.getAttribute("admins");

    if (admins == null) {
        admins = new ArrayList<Admin>();
    }

    String error = (String) request.getAttribute("error");
%>

<aside class="w-[210px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        
        <!-- Logo -->
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png"
                 alt="FESC Logo"
                 class="h-10 object-contain"
                 onerror="this.outerHTML='<div class=\'flex items-center gap-2\'><div class=\'w-8 h-8 rounded-lg bg-[#c8102e] flex items-center justify-center\'><i class=\'fa-solid fa-graduation-cap text-white text-sm\'></i></div><span class=\'font-extrabold text-[#c8102e] text-lg tracking-tight\'>FESC Gestión</span></div>'">
        </div>

        <!-- User Info -->
        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-xs"></i>
            </div>

            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">
                    Administración
                </p>

                <p class="text-[10px] text-gray-400 mt-0.5">
                    Panel Central
                </p>
            </div>
        </div>

        <!-- Navigation -->
        <nav class="flex flex-col gap-1">

            <!-- Dashboard -->
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center"></i>
                Tablero
            </a>

            <!-- Requests -->
            <a href="<%=request.getContextPath()%>/admin/requests"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i>
                Solicitudes
            </a>

            <!-- Students -->
            <a href="<%=request.getContextPath()%>/admin/students"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user-graduate text-sm w-4 text-center text-gray-400"></i>
                Estudiantes
            </a>

            <!-- Admin Users -->
            <a href="<%=request.getContextPath()%>/admin/admin-users"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-users-gear text-sm w-4 text-center text-gray-400"></i>
                Administradores
            </a>

            <!-- Academic Programs -->
            <a href="<%=request.getContextPath()%>/admin/programs"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-graduation-cap text-sm w-4 text-center text-gray-400"></i>
                Programas
            </a>

            <!-- Request Types -->
            <a href="<%=request.getContextPath()%>/admin/request-types"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-sliders text-sm w-4 text-center text-gray-400"></i>
                Tipos Solicitud
            </a>

            <!-- Reports -->
            <a href="<%=request.getContextPath()%>/admin/reports"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center text-gray-400"></i>
                Reportes
            </a>
            <a href="<%=request.getContextPath()%>/admin/profile"
                class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                 <i class="fa-solid fa-user text-sm w-4 text-center text-gray-400"></i>
                 Mi Perfil
             </a>               
        </nav>
    </div>

    <!-- Logout -->
    <a href="<%=request.getContextPath()%>/logout"
       class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i>
        Cerrar sesión
    </a>
</aside>

<main class="flex-1 ml-[210px] min-h-screen p-8">
    <div class="flex items-start justify-between mb-6">
        <div>
            <h1 class="text-2xl font-extrabold text-gray-900">
                Administradores
            </h1>

            <p class="text-sm text-gray-400 mt-1">
                Creación y gestión de usuarios administradores del sistema.
            </p>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="mb-5 rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 font-semibold">
            <i class="fa-solid fa-triangle-exclamation mr-2"></i>
            <%= error %>
        </div>
    <% } %>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <h2 class="text-lg font-bold text-gray-800 mb-5">
                Nuevo administrador
            </h2>

            <form action="<%=request.getContextPath()%>/admin/admin-users"
                  method="post"
                  class="space-y-4">

                <input type="hidden" name="action" value="create">

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Nombre
                    </label>
                    <input type="text"
                           name="nombre"
                           required
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Correo
                    </label>
                    <input type="email"
                           name="email"
                           required
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Contraseña
                    </label>
                    <input type="password"
                           name="password"
                           required
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Rol
                    </label>
                    <input type="text"
                           value="admin"
                           readonly
                           class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-500">
                </div>

                <button type="submit"
                        class="w-full rounded-xl bg-[#c8102e] py-3 text-sm font-bold text-white hover:bg-red-700 transition-colors">
                    Crear administrador
                </button>
            </form>
        </div>

        <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="flex items-start justify-between mb-5">
                <div>
                    <h2 class="text-lg font-bold text-gray-800">
                        Administradores registrados
                    </h2>
                    <p class="text-xs text-gray-400 mt-1">
                        Todos los usuarios tienen rol único: admin.
                    </p>
                </div>

                <span class="rounded-full bg-gray-100 px-3 py-1 text-xs font-bold text-gray-500">
                    Total: <%= admins.size() %>
                </span>
            </div>

            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead>
                    <tr class="border-b border-gray-100">
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">ID</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Nombre</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Correo</th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Rol</th>
                        <th class="pb-3 text-right text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Acción</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (admins.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="py-10 text-center text-sm text-gray-400">
                                No hay administradores registrados.
                            </td>
                        </tr>
                    <% } %>

                    <% for (Admin admin : admins) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 px-2 text-sm font-bold text-gray-400">#<%= admin.getId() %></td>

                            <td class="py-4 px-2 text-sm font-semibold text-gray-700">
                                <%= admin.getNombre() %>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= admin.getEmail() %>
                            </td>

                            <td class="py-4 px-2 text-sm">
                                <span class="inline-flex items-center rounded-lg bg-blue-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-blue-600 border border-blue-100">
                                    admin
                                </span>
                            </td>

                            <td class="py-4 px-2 text-right">
                                <form action="<%=request.getContextPath()%>/admin/admin-users"
                                      method="post"
                                      class="inline"
                                      onsubmit="return confirm('¿Eliminar este administrador? Si está asignado a solicitudes, la base de datos puede impedirlo.');">

                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= admin.getId() %>">

                                    <button type="submit"
                                            class="w-8 h-8 inline-flex items-center justify-center rounded-full text-red-600 hover:bg-red-50 transition-colors"
                                            title="Eliminar">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

</body>
</html>