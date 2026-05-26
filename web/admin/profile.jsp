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

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="profile" />
</jsp:include>

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