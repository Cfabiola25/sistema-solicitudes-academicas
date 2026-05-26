<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ProgramaAcademico" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Programas Académicos - FESC Admin</title>
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
    List<ProgramaAcademico> programas = (List<ProgramaAcademico>) request.getAttribute("programas");

    if (programas == null) {
        programas = new ArrayList<ProgramaAcademico>();
    }

    String error = (String) request.getAttribute("error");
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="programs" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen p-8">
    <div class="flex items-start justify-between mb-6">
        <div>
            <h1 class="text-2xl font-extrabold text-gray-900">
                Programas Académicos
            </h1>

            <p class="text-sm text-gray-400 mt-1">
                Estos programas aparecen en el formulario de registro de estudiantes.
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
                Nuevo programa
            </h2>

            <form action="<%=request.getContextPath()%>/admin/programs"
                  method="post"
                  class="space-y-4">

                <input type="hidden" name="action" value="create">

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Código
                    </label>
                    <input type="text"
                           name="codigo"
                           required
                           placeholder="Ej: 107861"
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Nombre del programa
                    </label>
                    <input type="text"
                           name="nombre"
                           required
                           placeholder="Ej: Ingeniería de Software"
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <button type="submit"
                        class="w-full rounded-xl bg-[#c8102e] py-3 text-sm font-bold text-white hover:bg-red-700 transition-colors">
                    Crear programa
                </button>
            </form>
        </div>

        <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="flex items-start justify-between mb-5">
                <div>
                    <h2 class="text-lg font-bold text-gray-800">
                        Programas registrados
                    </h2>
                    <p class="text-xs text-gray-400 mt-1">
                        Puedes editar o eliminar programas que no estén asociados a estudiantes.
                    </p>
                </div>

                <span class="rounded-full bg-gray-100 px-3 py-1 text-xs font-bold text-gray-500">
                    Total: <%= programas.size() %>
                </span>
            </div>

            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead>
                    <tr class="border-b border-gray-100">
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Código
                        </th>
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Nombre
                        </th>
                        <th class="pb-3 text-right text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Acción
                        </th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (programas.isEmpty()) { %>
                        <tr>
                            <td colspan="3" class="py-10 text-center text-sm text-gray-400">
                                No hay programas registrados.
                            </td>
                        </tr>
                    <% } %>

                    <% for (ProgramaAcademico programa : programas) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 px-2 text-sm font-bold text-gray-500">
                                <%= programa.getCodigo() %>
                            </td>

                            <td class="py-4 px-2 text-sm font-semibold text-gray-700">
                                <%= programa.getNombre() %>
                            </td>

                            <td class="py-4 px-2 text-right">
                                <div class="inline-flex items-center gap-1">
                                    <button type="button"
                                            onclick="openEditModal('<%= programa.getId() %>', '<%= programa.getCodigo().replace("'", "\\'") %>', '<%= programa.getNombre().replace("'", "\\'") %>')"
                                            class="w-8 h-8 inline-flex items-center justify-center rounded-full text-amber-600 hover:bg-amber-50 transition-colors"
                                            title="Editar">
                                        <i class="fa-regular fa-pen-to-square"></i>
                                    </button>

                                    <form action="<%=request.getContextPath()%>/admin/programs"
                                          method="post"
                                          class="inline"
                                          onsubmit="return confirm('¿Eliminar este programa académico? Si está asociado a estudiantes, la base de datos puede impedirlo.');">

                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= programa.getId() %>">

                                        <button type="submit"
                                                class="w-8 h-8 inline-flex items-center justify-center rounded-full text-red-600 hover:bg-red-50 transition-colors"
                                                title="Eliminar">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<div id="editModal"
     class="fixed inset-0 z-50 hidden items-center justify-center bg-black/50 p-4">

    <div class="w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl border border-gray-100">
        <div class="flex items-start justify-between mb-5">
            <div>
                <h3 class="text-lg font-extrabold text-gray-900">
                    Editar programa
                </h3>
                <p class="text-xs text-gray-400 mt-1">
                    Modifica el código o nombre del programa académico.
                </p>
            </div>

            <button type="button"
                    onclick="closeEditModal()"
                    class="h-8 w-8 rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form action="<%=request.getContextPath()%>/admin/programs"
              method="post"
              class="space-y-4">

            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editId" name="id">

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Código
                </label>

                <input type="text"
                       id="editCodigo"
                       name="codigo"
                       required
                       class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Nombre del programa
                </label>

                <input type="text"
                       id="editNombre"
                       name="nombre"
                       required
                       class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
            </div>

            <div class="flex items-center justify-end gap-2 pt-2">
                <button type="button"
                        onclick="closeEditModal()"
                        class="rounded-xl border border-gray-200 px-4 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-50">
                    Cancelar
                </button>

                <button type="submit"
                        class="rounded-xl bg-[#c8102e] px-4 py-2.5 text-sm font-bold text-white hover:bg-red-700">
                    Guardar cambios
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, codigo, nombre) {
        document.getElementById('editId').value = id;
        document.getElementById('editCodigo').value = codigo;
        document.getElementById('editNombre').value = nombre;

        const modal = document.getElementById('editModal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }

    function closeEditModal() {
        const modal = document.getElementById('editModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }
</script>

</body>
</html>