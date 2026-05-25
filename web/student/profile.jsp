<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - FESC</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .nav-link.active { background: #c8102e; color: white !important; border-radius: 10px; }
        .nav-link.active i { color: white !important; }
        .nav-link:hover:not(.active) { background: #f4f5f7; border-radius: 10px; }
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    Student student = (Student) request.getAttribute("student");
%>

<aside class="w-[220px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        <div class="px-2 mb-8">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png"
                 class="h-10 object-contain"
                 alt="FESC Logo">
        </div>

        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-graduate text-[#c8102e] text-xs"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">Estudiante</p>
                <p class="text-[10px] text-gray-400 mt-0.5">Mi perfil</p>
            </div>
        </div>

        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/student/dashboard"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center text-gray-400"></i>
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
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center"></i>
                Mi Perfil
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

<main class="flex-1 ml-[220px] min-h-screen p-8">

    <div class="max-w-4xl mx-auto">
        <div class="flex items-center justify-between mb-6">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-900">Mi Perfil</h1>
                <p class="text-sm text-gray-400 mt-1">Información registrada en el sistema.</p>
            </div>

            <a href="<%=request.getContextPath()%>/student/new-request"
               class="inline-flex items-center gap-2 rounded-xl bg-[#c8102e] px-5 py-3 text-sm font-bold text-white hover:bg-red-700 transition-colors">
                <i class="fa-solid fa-plus"></i>
                Nueva solicitud
            </a>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="bg-[#c8102e] px-6 py-8 text-white">
                <div class="flex items-center gap-4">
                    <div class="w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
                        <i class="fa-solid fa-user-graduate text-2xl"></i>
                    </div>

                    <div>
                        <h2 class="text-2xl font-extrabold">
                            <%= student.getNombre() %> <%= student.getApellido() %>
                        </h2>
                        <p class="text-sm text-white/80 mt-1">
                            <%= student.getEmail() %>
                        </p>
                    </div>
                </div>
            </div>

            <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-5">
                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Nombre</p>
                    <p class="text-sm font-bold text-gray-800"><%= student.getNombre() %></p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Apellido</p>
                    <p class="text-sm font-bold text-gray-800"><%= student.getApellido() %></p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Correo institucional</p>
                    <p class="text-sm font-bold text-gray-800"><%= student.getEmail() %></p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Rol</p>
                    <p class="text-sm font-bold text-gray-800">Estudiante</p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Programa académico</p>
                    <p class="text-sm font-bold text-gray-800">
                        <%= student.getProgramaNombre() != null ? student.getProgramaNombre() : "No registrado" %>
                    </p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Sede</p>
                    <p class="text-sm font-bold text-gray-800">
                        <%= student.getSedeNombre() != null ? student.getSedeNombre() : "No registrada" %>
                    </p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Jornada</p>
                    <p class="text-sm font-bold text-gray-800">
                        <%= student.getJornadaNombre() != null ? student.getJornadaNombre() : "No registrada" %>
                    </p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-gray-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">Términos aceptados</p>
                    <p class="text-sm font-bold text-green-600">
                        <i class="fa-solid fa-circle-check mr-1"></i>
                        Sí
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>