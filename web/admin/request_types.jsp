<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Admin" %>
<%@ page import="model.TipoSolicitud" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tipos de Solicitud - FESC Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous"
          referrerpolicy="no-referrer" />

    <link rel="preconnect" href="https://fonts.googleapis.com">

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
        ::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 9999px; }
    </style>
</head>

<body class="bg-[#f4f5f7] min-h-screen flex">

<%
    List<TipoSolicitud> list = (List<TipoSolicitud>) request.getAttribute("list");
    List<Admin> admins = (List<Admin>) request.getAttribute("admins");
    Map<Integer, List<Admin>> responsablesPorTipo = (Map<Integer, List<Admin>>) request.getAttribute("responsablesPorTipo");

    if (list == null) {
        list = new ArrayList<TipoSolicitud>();
    }

    if (admins == null) {
        admins = new ArrayList<Admin>();
    }

    if (responsablesPorTipo == null) {
        responsablesPorTipo = new HashMap<Integer, List<Admin>>();
    }

    String error = (String) request.getAttribute("error");
%>

<jsp:include page="/components/admin_sidebar.jsp">
    <jsp:param name="activePage" value="request-types" />
</jsp:include>

<main class="flex-1 ml-[210px] min-h-screen p-8">

    <div class="flex items-start justify-between mb-6">
        <div>
            <h1 class="text-2xl font-extrabold text-gray-900">
                Tipos de Solicitud
            </h1>

            <p class="text-sm text-gray-400 mt-1">
                Configuración de tiempos SLA y tipos de solicitudes.
            </p>
        </div>

        <% Admin current = (Admin) session.getAttribute("user"); boolean isSuper = current != null && "SuperAdmin".equals(current.getRol()); %>
        <% if (isSuper) { %>
        <button type="button"
                onclick="openCreateModal()"
                class="rounded-xl bg-[#c8102e] px-4 py-3 text-sm font-bold text-white hover:bg-red-700 transition-colors shadow-sm">
            <i class="fa-solid fa-plus mr-2"></i>
            Nuevo tipo
        </button>
        <% } %>
    </div>

    <% if (error != null) { %>
        <div class="mb-5 rounded-xl bg-red-50 border border-red-100 px-4 py-3 text-sm text-red-600 font-semibold">
            <i class="fa-solid fa-triangle-exclamation mr-2"></i>
            <%= error %>
        </div>
    <% } %>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <h2 class="text-lg font-bold text-gray-800 mb-3">
                Asignación de responsables
            </h2>

            <p class="text-sm text-gray-500 leading-relaxed mb-5">
                La asignación se maneja desde la modal de creación o edición, y un tipo puede tener varios administradores.
            </p>

            <div class="rounded-2xl bg-gray-50 border border-gray-100 p-4">
                <div class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-2">
                    Administradores disponibles
                </div>

                <div class="flex flex-wrap gap-2">
                    <% if (admins.isEmpty()) { %>
                        <span class="rounded-full bg-white px-3 py-1.5 text-xs font-semibold text-gray-500 border border-gray-200">
                            No hay administradores registrados.
                        </span>
                    <% } else { %>
                        <% for (Admin admin : admins) { %>
                            <span class="rounded-full bg-white px-3 py-1.5 text-xs font-semibold text-gray-700 border border-gray-200">
                                <%= admin.getNombre() %>
                            </span>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <div class="flex items-start justify-between mb-5">
                <div>
                    <h2 class="text-lg font-bold text-gray-800">
                        Tipos registrados
                    </h2>
                    <p class="text-xs text-gray-400 mt-1">
                        Puedes modificar el nombre, tiempo de respuesta y tipo de conteo.
                    </p>
                </div>

                <span class="rounded-full bg-gray-100 px-3 py-1 text-xs font-bold text-gray-500">
                    Total: <%= list.size() %>
                </span>
            </div>

            <div class="overflow-x-auto">
                <table class="min-w-full">
                    <thead>
                    <tr class="border-b border-gray-100">
                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Nombre
                        </th>

                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            SLA
                        </th>

                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Tipo
                        </th>

                        <th class="pb-3 text-left text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Responsables
                        </th>

                        <th class="pb-3 text-right text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                            Acción
                        </th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (list.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="py-10 text-center text-sm text-gray-400">
                                No hay tipos registrados.
                            </td>
                        </tr>
                    <% } %>

                    <% for (TipoSolicitud tipo : list) { %>
                        <tr class="border-b border-gray-50 hover:bg-gray-50/60 transition-colors">
                            <td class="py-4 px-2 text-sm font-semibold text-gray-700">
                                <%= tipo.getNombre() %>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%= tipo.getTiempoRespuestaDias() %> días
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <% if ("habiles".equals(tipo.getTipoTiempo())) { %>
                                    <span class="inline-flex items-center rounded-lg bg-blue-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-blue-600 border border-blue-100">
                                        Hábiles
                                    </span>
                                <% } else { %>
                                    <span class="inline-flex items-center rounded-lg bg-purple-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-purple-600 border border-purple-100">
                                        Calendario
                                    </span>
                                <% } %>
                            </td>

                            <td class="py-4 px-2 text-sm text-gray-500">
                                <%
                                    List<Admin> responsables = responsablesPorTipo.get(tipo.getId());
                                %>

                                <% if (responsables != null && !responsables.isEmpty()) { %>
                                    <div class="flex flex-wrap gap-2">
                                        <% for (Admin responsable : responsables) { %>
                                            <span class="inline-flex items-center rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-bold text-emerald-700 border border-emerald-100">
                                                <%= responsable.getNombre() %>
                                            </span>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <span class="text-gray-400">Sin asignar</span>
                                <% } %>
                            </td>

                            <td class="py-4 px-2 text-right">
                                <% if (isSuper) { %>
                                <div class="inline-flex items-center gap-1">
                                    <button type="button"
                                            onclick="openEditModal(<%= tipo.getId() %>, '<%= tipo.getNombre().replace("\\", "\\\\").replace("'", "\\'") %>', <%= tipo.getTiempoRespuestaDias() %>, '<%= tipo.getTipoTiempo() %>')"
                                            class="w-8 h-8 inline-flex items-center justify-center rounded-full text-amber-600 hover:bg-amber-50 transition-colors"
                                            title="Editar">
                                        <i class="fa-regular fa-pen-to-square"></i>
                                    </button>

                                    <form action="<%=request.getContextPath()%>/admin/request-types"
                                          method="post"
                                          class="inline"
                                          onsubmit="return confirm('¿Eliminar este tipo de solicitud?');">

                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= tipo.getId() %>">

                                        <button type="submit"
                                                class="w-8 h-8 inline-flex items-center justify-center rounded-full text-red-600 hover:bg-red-50 transition-colors"
                                                title="Eliminar">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<div id="createModal"
     class="fixed inset-0 z-50 hidden items-center justify-center bg-black/50 p-4">

    <div class="w-full max-w-2xl rounded-2xl bg-white p-6 shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
        <div class="flex items-start justify-between mb-5">
            <div>
                <h3 class="text-lg font-extrabold text-gray-900">
                    Crear tipo de solicitud
                </h3>
                <p class="text-xs text-gray-400 mt-1">
                    Define el tipo, su SLA y los responsables por defecto.
                </p>
            </div>

            <button type="button"
                    onclick="closeCreateModal()"
                    class="h-8 w-8 rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form id="createForm"
              action="<%=request.getContextPath()%>/admin/request-types"
              method="post"
              class="space-y-5">

            <input type="hidden" name="action" value="create">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Nombre
                    </label>

                    <input type="text"
                           name="nombre"
                           required
                           placeholder="Ej: Certificado académico"
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Tiempo respuesta
                    </label>

                    <input type="number"
                           name="tiempoRespuestaDias"
                           min="1"
                           required
                           placeholder="Ej: 5"
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Tipo tiempo
                </label>

                <select name="tipoTiempo"
                        required
                        class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">

                    <option value="habiles">Días hábiles</option>
                    <option value="calendario">Días calendario</option>
                </select>
            </div>

            <div>
                <div class="flex items-center justify-between mb-3">
                    <label class="block text-sm font-semibold text-gray-700">
                        Responsables por defecto
                    </label>
                    <span class="text-xs text-gray-400">Selecciona uno o varios</span>
                </div>

                <div class="rounded-2xl border border-gray-200 bg-gray-50 p-4">
                    <% if (!isSuper) { %>
                        <div class="text-sm text-gray-500">Sólo SuperAdmin puede asignar responsables.</div>
                    <% } else { %>
                        <% if (admins.isEmpty()) { %>
                            <div class="text-sm text-gray-400">
                                No hay administradores disponibles.
                            </div>
                        <% } else { %>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                                <% for (int i = 0; i < admins.size(); i++) {
                                       Admin admin = admins.get(i);
                                %>
                                    <label class="flex items-center gap-3 rounded-xl bg-white border border-gray-200 px-4 py-3 text-sm text-gray-700 shadow-sm">
                                        <input type="checkbox"
                                               name="responsableIds"
                                               value="<%= admin.getId() %>"
                                               <%= i == 0 ? "checked" : "" %>
                                               class="h-4 w-4 rounded border-gray-300 text-[#c8102e] focus:ring-[#c8102e]">
                                        <span>
                                            <span class="block font-semibold"><%= admin.getNombre() %></span>
                                            <span class="block text-xs text-gray-400"><%= admin.getEmail() %></span>
                                        </span>
                                    </label>
                                <% } %>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2 pt-2">
                <button type="button"
                        onclick="closeCreateModal()"
                        class="rounded-xl border border-gray-200 px-4 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-50">
                    Cancelar
                </button>

                <button type="submit"
                        class="rounded-xl bg-[#c8102e] px-4 py-2.5 text-sm font-bold text-white hover:bg-red-700">
                    Crear tipo
                </button>
            </div>
        </form>
    </div>
</div>

<div id="editModal"
     class="fixed inset-0 z-50 hidden items-center justify-center bg-black/50 p-4">

    <div class="w-full max-w-2xl rounded-2xl bg-white p-6 shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
        <div class="flex items-start justify-between mb-5">
            <div>
                <h3 class="text-lg font-extrabold text-gray-900">
                    Editar tipo de solicitud
                </h3>
                <p class="text-xs text-gray-400 mt-1">
                    Ajusta el SLA y la configuración del tipo.
                </p>
            </div>

            <button type="button"
                    onclick="closeEditModal()"
                    class="h-8 w-8 rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form id="editForm"
              action="<%=request.getContextPath()%>/admin/request-types"
              method="post"
              class="space-y-5">

            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editId" name="id">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Nombre
                    </label>

                    <input type="text"
                           id="editNombre"
                           name="nombre"
                           required
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        Tiempo respuesta
                    </label>

                    <input type="number"
                           id="editTiempo"
                           name="tiempoRespuestaDias"
                           min="1"
                           required
                           class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Tipo tiempo
                </label>

                <select id="editTipoTiempo"
                        name="tipoTiempo"
                        required
                        class="w-full rounded-xl border border-gray-200 px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30">
                    <option value="habiles">Días hábiles</option>
                    <option value="calendario">Días calendario</option>
                </select>
            </div>

            <div>
                <div class="flex items-center justify-between mb-3">
                    <label class="block text-sm font-semibold text-gray-700">
                        Responsables
                    </label>
                    <span class="text-xs text-gray-400">Puedes asignar varios admins</span>
                </div>

                <div class="rounded-2xl border border-gray-200 bg-gray-50 p-4">
                    <% if (admins.isEmpty()) { %>
                        <div class="text-sm text-gray-400">
                            No hay administradores disponibles.
                        </div>
                    <% } else { %>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                            <% for (Admin admin : admins) { %>
                                <label class="flex items-center gap-3 rounded-xl bg-white border border-gray-200 px-4 py-3 text-sm text-gray-700 shadow-sm">
                                    <input type="checkbox"
                                           name="responsableIds"
                                           value="<%= admin.getId() %>"
                                           class="edit-responsable-checkbox h-4 w-4 rounded border-gray-300 text-[#c8102e] focus:ring-[#c8102e]">
                                    <span>
                                        <span class="block font-semibold"><%= admin.getNombre() %></span>
                                        <span class="block text-xs text-gray-400"><%= admin.getEmail() %></span>
                                    </span>
                                </label>
                            <% } %>
                        </div>
                    <% } %>
                </div>
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
    const tipoResponsablesMap = {};

    <% for (Map.Entry<Integer, List<Admin>> entry : responsablesPorTipo.entrySet()) { %>
    tipoResponsablesMap[<%= entry.getKey() %>] = [<%
        List<Admin> responsables = entry.getValue();
        for (int i = 0; i < responsables.size(); i++) {
            if (i > 0) {
    %>,<%
            }
            out.print(responsables.get(i).getId());
        }
    %>];
    <% } %>

    function openCreateModal() {
        const form = document.getElementById('createForm');
        const modal = document.getElementById('createModal');

        if (form) {
            form.reset();
        }

        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }

    function closeCreateModal() {
        const modal = document.getElementById('createModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }

    function openEditModal(id, nombre, tiempo, tipoTiempo) {
        const form = document.getElementById('editForm');

        if (form) {
            form.reset();
        }

        document.getElementById('editId').value = id;
        document.getElementById('editNombre').value = nombre;
        document.getElementById('editTiempo').value = tiempo;
        document.getElementById('editTipoTiempo').value = tipoTiempo;

        const selectedIds = tipoResponsablesMap[id] || [];
        const checkboxes = document.querySelectorAll('#editModal .edit-responsable-checkbox');

        checkboxes.forEach((checkbox) => {
            checkbox.checked = selectedIds.includes(parseInt(checkbox.value, 10));
        });

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