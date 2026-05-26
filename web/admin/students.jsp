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
    List<Student> students = (List<Student>) request.getAttribute("students");

    if (students == null) {
        students = new ArrayList<Student>();
    }

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="students" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen flex flex-col">

    <header class="bg-white border-b border-gray-100 px-8 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-gray-400">
                Panel administrativo
            </p>
            <h1 class="text-lg font-extrabold text-gray-900">
                Listado de Estudiantes
            </h1>
        </div>

        <div class="flex items-center gap-4">
            <span class="text-sm font-semibold text-gray-600">Ajustes</span>

            <a href="<%=request.getContextPath()%>/admin/profile"
               class="w-9 h-9 rounded-full bg-[#c8102e]/10 flex items-center justify-center hover:bg-red-100 transition-colors"
               title="Mi perfil">
                <i class="fa-solid fa-user-tie text-[#c8102e] text-sm"></i>
            </a>
        </div>
    </header>

    <div class="p-8 flex-1">

        <% if (error != null) { %>
            <div class="mb-5 rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 font-semibold">
                <i class="fa-solid fa-triangle-exclamation mr-2"></i>
                <%= error %>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="mb-5 rounded-xl bg-green-50 border border-green-100 px-4 py-3 text-sm text-green-700 font-semibold">
                <i class="fa-solid fa-circle-check mr-2"></i>
                <%= success %>
            </div>
        <% } %>

        <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6 gap-4">
            <div>
                <p class="text-sm text-gray-400">
                    Administra y supervisa las cuentas de los estudiantes en la plataforma.
                </p>

                <p class="text-xs font-bold text-gray-500 mt-1">
                    Total registrados: <%= students.size() %>
                </p>
            </div>

            <div class="flex items-center gap-3 bg-white p-2 rounded-xl shadow-sm border border-gray-100 w-full md:w-auto">
                <span class="text-xs font-bold text-gray-400 uppercase tracking-wider pl-2">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </span>

                <input type="text"
                       id="searchInput"
                       onkeyup="filterStudents()"
                       placeholder="Buscar estudiante por nombre o correo..."
                       class="text-sm font-medium text-gray-700 bg-gray-50 border-none rounded-lg py-1.5 px-3 focus:outline-none w-full md:w-64" />
            </div>
        </div>

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
                        <th class="pb-3 text-right text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">Acción</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (students.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="py-10 text-center text-sm text-gray-400">
                                No hay estudiantes registrados en el sistema.
                            </td>
                        </tr>
                    <% } %>

                    <% for (Student st : students) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors student-row">
                            <td class="py-4 px-2 text-sm font-bold text-gray-400">
                                #<%= st.getId() %>
                            </td>

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

                            <td class="py-4 px-2 text-sm text-gray-600 email-cell">
                                <%= st.getEmail() %>
                            </td>

                            <td class="py-4 px-2">
                                <span class="inline-block text-xs font-semibold text-gray-700 bg-gray-100 px-2.5 py-1 rounded-lg max-w-[250px] truncate"
                                      title="<%= st.getProgramaNombre() != null ? st.getProgramaNombre() : "No asignado" %>">
                                    <%= st.getProgramaNombre() != null ? st.getProgramaNombre() : "No asignado" %>
                                </span>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= st.getSedeNombre() != null ? st.getSedeNombre() : "No asignada" %>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= st.getJornadaNombre() != null ? st.getJornadaNombre() : "No asignada" %>
                            </td>

                            <td class="py-4 px-2 text-right">
                                <button type="button"
                                        onclick="openPasswordModal('<%= st.getId() %>', '<%= st.getNombreCompleto().replace("'", "\\'") %>', '<%= st.getEmail().replace("'", "\\'") %>')"
                                        class="inline-flex items-center justify-center gap-2 rounded-lg bg-red-50 px-3 py-2 text-xs font-bold text-[#c8102e] hover:bg-red-100 transition-colors"
                                        title="Restablecer contraseña">
                                    <i class="fa-solid fa-key"></i>
                                    Restablecer
                                </button>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

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

<div id="passwordModal"
     class="fixed inset-0 z-50 hidden items-center justify-center bg-black/50 p-4">

    <div class="w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl border border-gray-100">
        <div class="flex items-start justify-between mb-5">
            <div>
                <h3 class="text-lg font-extrabold text-gray-900">
                    Restablecer contraseña
                </h3>

                <p class="text-xs text-gray-400 mt-1">
                    La contraseña anterior no se muestra. Se reemplazará por una nueva contraseña hasheada.
                </p>
            </div>

            <button type="button"
                    onclick="closePasswordModal()"
                    class="h-8 w-8 rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="rounded-xl bg-gray-50 border border-gray-100 p-4 mb-5">
            <p class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-1">
                Estudiante
            </p>

            <p id="modalStudentName" class="text-sm font-bold text-gray-800"></p>
            <p id="modalStudentEmail" class="text-xs text-gray-500 mt-1"></p>
        </div>

        <form action="<%=request.getContextPath()%>/admin/students"
              method="post"
              class="space-y-4">

            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" id="modalStudentId" name="studentId">

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Nueva contraseña
                </label>

                <input type="password"
                       id="newPassword"
                       name="newPassword"
                       required
                       minlength="4"
                       placeholder="Escribe la nueva contraseña"
                       class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Confirmar contraseña
                </label>

                <input type="password"
                       id="confirmPassword"
                       required
                       minlength="4"
                       placeholder="Repite la nueva contraseña"
                       class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
            </div>

            <p id="passwordError" class="hidden text-xs font-bold text-red-600">
                Las contraseñas no coinciden.
            </p>

            <div class="flex items-center justify-end gap-2 pt-2">
                <button type="button"
                        onclick="closePasswordModal()"
                        class="rounded-xl border border-gray-200 px-4 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-50">
                    Cancelar
                </button>

                <button type="submit"
                        onclick="return validatePasswordReset()"
                        class="rounded-xl bg-[#c8102e] px-4 py-2.5 text-sm font-bold text-white hover:bg-red-700">
                    Guardar contraseña
                </button>
            </div>
        </form>
    </div>
</div>

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

    function openPasswordModal(studentId, studentName, studentEmail) {
        document.getElementById("modalStudentId").value = studentId;
        document.getElementById("modalStudentName").textContent = studentName;
        document.getElementById("modalStudentEmail").textContent = studentEmail;
        document.getElementById("newPassword").value = "";
        document.getElementById("confirmPassword").value = "";
        document.getElementById("passwordError").classList.add("hidden");

        const modal = document.getElementById("passwordModal");
        modal.classList.remove("hidden");
        modal.classList.add("flex");
    }

    function closePasswordModal() {
        const modal = document.getElementById("passwordModal");
        modal.classList.add("hidden");
        modal.classList.remove("flex");
    }

    function validatePasswordReset() {
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;
        const passwordError = document.getElementById("passwordError");

        if (newPassword !== confirmPassword) {
            passwordError.classList.remove("hidden");
            return false;
        }

        passwordError.classList.add("hidden");
        return confirm("¿Seguro que deseas restablecer la contraseña de este estudiante?");
    }
</script>

</body>
</html>