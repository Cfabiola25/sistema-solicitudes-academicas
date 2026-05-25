<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Admin" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - FESC Admin</title>
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
    Admin admin = (Admin) request.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
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
                <p class="text-xs font-bold text-gray-800 leading-none">
                    Administración
                </p>
                <p class="text-[10px] text-gray-400 mt-0.5">
                    Mi perfil
                </p>
            </div>
        </div>

        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center text-gray-400"></i>
                Tablero
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i>
                Solicitudes
            </a>

            <a href="<%=request.getContextPath()%>/admin/students"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-user-graduate text-sm w-4 text-center text-gray-400"></i>
                Estudiantes
            </a>

            <a href="<%=request.getContextPath()%>/admin/admin-users"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-users-gear text-sm w-4 text-center text-gray-400"></i>
                Administradores
            </a>

            <a href="<%=request.getContextPath()%>/admin/programs"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-graduation-cap text-sm w-4 text-center text-gray-400"></i>
                Programas
            </a>

            <a href="<%=request.getContextPath()%>/admin/request-types"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-sliders text-sm w-4 text-center text-gray-400"></i>
                Tipos Solicitud
            </a>

            <a href="<%=request.getContextPath()%>/admin/reports"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center text-gray-400"></i>
                Reportes
            </a>

            <a href="<%=request.getContextPath()%>/admin/profile"
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center"></i>
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

<main class="flex-1 ml-[210px] min-h-screen p-8">

    <div class="max-w-4xl mx-auto">
        <div class="flex items-center justify-between mb-6">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">
                    Mi Perfil
                </h1>
                <p class="text-sm text-gray-400 mt-1">
                    Información del administrador autenticado.
                </p>
            </div>

            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="inline-flex items-center gap-2 rounded-xl bg-[#c8102e] px-5 py-3 text-sm font-bold text-white hover:bg-red-700 transition-colors">
                <i class="fa-solid fa-table-columns"></i>
                Ir al tablero
            </a>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="bg-[#c8102e] px-6 py-8 text-white">
                <div class="flex items-center gap-4">
                    <div class="w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
                        <i class="fa-solid fa-user-tie text-2xl"></i>
                    </div>

                    <div>
                        <h2 class="text-2xl font-extrabold">
                            <%= admin.getNombre() %>
                        </h2>
                        <p class="text-sm text-white/80 mt-1">
                            <%= admin.getEmail() %>
                        </p>
                    </div>
                </div>
            </div>

            <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-5">
                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">
                        Nombre
                    </p>
                    <p class="text-sm font-bold text-gray-800">
                        <%= admin.getNombre() %>
                    </p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">
                        Correo
                    </p>
                    <p class="text-sm font-bold text-gray-800">
                        <%= admin.getEmail() %>
                    </p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">
                        Rol
                    </p>
                    <p class="text-sm font-bold text-gray-800">
                        admin
                    </p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">
                        Estado
                    </p>
                    <p class="text-sm font-bold text-green-600">
                        <i class="fa-solid fa-circle-check mr-1"></i>
                        Activo
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>