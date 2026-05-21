<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estudiantes - FESC Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
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

<!-- ───────── SIDEBAR ───────── -->
<aside class="w-[210px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed h-full z-10">
    <div>
        <!-- Logo -->
        <div class="px-2 mb-8 flex justify-start">
            <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png" alt="FESC Logo"
                class="h-10 object-contain"
                onerror="this.outerHTML='<div class=\'flex items-center gap-2\'><div class=\'w-8 h-8 rounded-lg bg-[#c8102e] flex items-center justify-center\'><i class=\'fa-solid fa-graduation-cap text-white text-sm\'></i></div><span class=\'font-extrabold text-[#c8102e] text-lg tracking-tight\'>FESC Gestión</span></div>'">
        </div>

        <!-- User Info -->
        <div class="flex items-center gap-3 bg-gray-50 rounded-xl p-3 mb-6">
            <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-xs"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-800 leading-none">Administración</p>
                <p class="text-[10px] text-gray-400 mt-0.5">Panel Central</p>
            </div>
        </div>

        <!-- Nav Links -->
        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-400 transition-all">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center text-gray-400"></i> Tablero
            </a>
            <a href="<%=request.getContextPath()%>/admin/requests"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-400 transition-all">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center text-gray-400"></i> Solicitudes
            </a>
            <a href="<%=request.getContextPath()%>/admin/students"
               class="nav-link active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all">
                <i class="fa-solid fa-user text-sm w-4 text-center"></i> Estudiantes
            </a>
            <a href="<%=request.getContextPath()%>/admin/reports"
               class="nav-link flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-400 transition-all">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center text-gray-400"></i> Reportes
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

    <!-- Top Bar -->
    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">Panel administrativo</p>
            <h1 class="text-lg font-extrabold text-gray-900">Listado de Estudiantes</h1>
        </div>
        <div class="flex items-center gap-4">
            <button class="relative w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors">
                <i class="fa-regular fa-bell text-base"></i>
                <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-[#c8102e] rounded-full border-2 border-white"></span>
            </button>
            <div class="w-px h-6 bg-gray-200"></div>
            <span class="text-sm font-semibold text-gray-600">Ajustes</span>
            <div class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-sm"></i>
            </div>
        </div>
    </header>

    <!-- Page Body -->
    <div class="p-8 flex-1">

        <!-- Search Bar and Count -->
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6 gap-4">
            <%
                List<Student> students = (List<Student>) request.getAttribute("students");
                if (students == null) {
                    students = new ArrayList<Student>();
                }
            %>
            <div>
                <p class="text-sm text-gray-400">Administra y supervisa las cuentas de los estudiantes en la plataforma.</p>
                <p class="text-xs font-bold text-gray-500 mt-1">Total registrados: <%= students.size() %></p>
            </div>
            
            <div class="flex items-center gap-3 bg-white p-2 rounded-xl shadow-sm border border-gray-100 w-full md:w-auto">
                <span class="text-xs font-bold text-gray-400 uppercase tracking-wider pl-2"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" id="searchInput" onkeyup="filterStudents()" placeholder="Buscar estudiante por nombre o correo..." 
                       class="text-sm font-medium text-gray-700 bg-gray-50 border-none rounded-lg py-1.5 px-3 focus:outline-none w-full md:w-64" />
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="overflow-x-auto">
                <table class="min-w-full" id="studentsTable">
                    <thead>
                        <tr class="border-b border-gray-100 text-left">
                            <th class="pb-3 text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">ID</th>
                            <th class="pb-3 text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Estudiante</th>
                            <th class="pb-3 text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Correo Institucional</th>
                            <th class="pb-3 text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Programa Académico</th>
                            <th class="pb-3 text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Sede</th>
                            <th class="pb-3 text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Jornada</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (students.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="py-10 text-center text-sm text-gray-400">No hay estudiantes registrados en el sistema.</td>
                        </tr>
                    <% } %>
                    <% for (Student st : students) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors student-row">
                            <td class="py-4 px-2 text-sm font-bold text-gray-400">#<%= st.getId() %></td>
                            <td class="py-4 px-2">
                                <div class="flex items-center gap-2.5">
                                    <div class="w-8 h-8 rounded-full bg-[#c8102e]/10 flex items-center justify-center flex-shrink-0">
                                        <i class="fa-solid fa-user text-[#c8102e] text-xs"></i>
                                    </div>
                                    <span class="text-sm font-semibold text-gray-800 name-cell">
                                        <%= st.getNombreCompleto() %>
                                    </span>
                                </div>
                            </td>
                            <td class="py-4 px-2 text-sm text-gray-600 email-cell"><%= st.getEmail() %></td>
                            <td class="py-4 px-2">
                                <span class="inline-block text-xs font-semibold text-gray-700 bg-gray-100 px-2.5 py-1 rounded-lg max-w-[250px] truncate" title="<%= st.getProgramaNombre() != null ? st.getProgramaNombre() : "No asignado" %>">
                                    <%= st.getProgramaNombre() != null ? st.getProgramaNombre() : "No asignado" %>
                                </span>
                            </td>
                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= st.getSedeNombre() != null ? st.getSedeNombre() : "Cúcuta" %>
                            </td>
                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= st.getJornadaNombre() != null ? st.getJornadaNombre() : "Diurna" %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div><!-- /page body -->

    <!-- Footer -->
    <footer class="px-8 py-4 border-t border-gray-100 bg-white flex items-center justify-between text-[11px] text-gray-400 mt-auto">
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
    function filterStudents() {
        const input = document.getElementById("searchInput");
        const filter = input.value.toLowerCase();
        const rows = document.getElementsByClassName("student-row");

        for (let i = 0; i < rows.length; i++) {
            const nameCell = rows[i].getElementsByClassName("name-cell")[0];
            const emailCell = rows[i].getElementsByClassName("email-cell")[0];
            if (nameCell || emailCell) {
                const nameText = nameCell.textContent || nameCell.innerText;
                const emailText = emailCell.textContent || emailCell.innerText;
                if (nameText.toLowerCase().indexOf(filter) > -1 || emailText.toLowerCase().indexOf(filter) > -1) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    }
</script>
</body>
</html>
