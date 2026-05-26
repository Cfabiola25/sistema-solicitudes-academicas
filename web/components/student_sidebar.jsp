<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%
    HttpSession sess = request.getSession(false);
    Student student = sess != null ? (Student) sess.getAttribute("user") : null;

    String activePage = request.getParameter("activePage");
    if (activePage == null) {
        activePage = "";
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

        <% if (student != null) { %>
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
        <% } %>

        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/student/dashboard"
               class="nav-link <%= "dashboard".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center <%= "dashboard".equals(activePage) ? "" : "text-gray-400" %>"></i>
                Tablero
            </a>

            <a href="<%=request.getContextPath()%>/student/new-request"
               class="nav-link <%= "new-request".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-plus text-sm w-4 text-center <%= "new-request".equals(activePage) ? "" : "text-gray-400" %>"></i>
                Nueva Solicitud
            </a>

            <a href="<%=request.getContextPath()%>/student/requests"
               class="nav-link <%= "requests".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center <%= "requests".equals(activePage) ? "" : "text-gray-400" %>"></i>
                Mis Solicitudes
            </a>

            <a href="<%=request.getContextPath()%>/student/profile"
               class="nav-link <%= "profile".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-user text-sm w-4 text-center <%= "profile".equals(activePage) ? "" : "text-gray-400" %>"></i>
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
