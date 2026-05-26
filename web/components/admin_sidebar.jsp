<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Admin" %>
<%
    HttpSession sess = request.getSession(false);
    Admin admin = sess != null ? (Admin) sess.getAttribute("user") : null;
    String adminName = admin != null ? admin.getNombre() : "Administración";
    String adminRole = admin != null && admin.getRol() != null ? admin.getRol() : "Panel Central";

    String activePage = request.getParameter("activePage");
    if (activePage == null) {
        activePage = "";
    }
%>
<style>
    @media (max-width: 767px) {
        main[class*="ml-[210px]"] { margin-left: 0 !important; }
        .sidebar-drawer { transform: translateX(-100%); }
        .sidebar-drawer.is-open { transform: translateX(0); }
        .sidebar-backdrop { display: none; }
        .sidebar-backdrop.is-open { display: block; }
    }
</style>

<button type="button" id="adminSidebarToggle" aria-label="Abrir menú" class="md:hidden fixed top-4 left-4 z-[60] w-11 h-11 rounded-xl bg-white border border-gray-200 shadow-sm flex items-center justify-center text-gray-700">
    <i class="fa-solid fa-bars"></i>
</button>

<div id="adminSidebarBackdrop" class="sidebar-backdrop fixed inset-0 bg-black/40 z-40 md:hidden"></div>

<aside id="adminSidebar" class="sidebar-drawer w-[210px] bg-white border-r border-gray-100 flex flex-col justify-between py-6 px-4 fixed inset-y-0 left-0 z-50 h-full transition-transform duration-300 ease-out md:translate-x-0">
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
                    <%= adminName %>
                </p>
                <p class="text-[10px] text-gray-400 mt-0.5">
                    <%= adminRole %>
                </p>
            </div>
        </div>

        <nav class="flex flex-col gap-1">
            <a href="<%=request.getContextPath()%>/admin/dashboard"
               class="nav-link <%= "dashboard".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-table-columns text-sm w-4 text-center <%= "dashboard".equals(activePage) ? "" : "text-gray-400" %>"></i> Dashboard
            </a>

            <a href="<%=request.getContextPath()%>/admin/requests"
               class="nav-link <%= "requests".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-regular fa-folder-open text-sm w-4 text-center <%= "requests".equals(activePage) ? "" : "text-gray-400" %>"></i> Solicitudes
            </a>

            <a href="<%=request.getContextPath()%>/admin/students"
               class="nav-link <%= "students".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-user-graduate text-sm w-4 text-center <%= "students".equals(activePage) ? "" : "text-gray-400" %>"></i> Estudiantes
            </a>

            <a href="<%=request.getContextPath()%>/admin/admin-users"
               class="nav-link <%= "admin-users".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-users-gear text-sm w-4 text-center <%= "admin-users".equals(activePage) ? "" : "text-gray-400" %>"></i> Administradores
            </a>

            <a href="<%=request.getContextPath()%>/admin/programs"
               class="nav-link <%= "programs".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-graduation-cap text-sm w-4 text-center <%= "programs".equals(activePage) ? "" : "text-gray-400" %>"></i> Programas
            </a>

            <a href="<%=request.getContextPath()%>/admin/request-types"
               class="nav-link <%= "request-types".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-sliders text-sm w-4 text-center <%= "request-types".equals(activePage) ? "" : "text-gray-400" %>"></i> Tipos Solicitud
            </a>

            <a href="<%=request.getContextPath()%>/admin/reports"
               class="nav-link <%= "reports".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-regular fa-chart-bar text-sm w-4 text-center <%= "reports".equals(activePage) ? "" : "text-gray-400" %>"></i> Reportes
            </a>

            <a href="<%=request.getContextPath()%>/admin/profile"
               class="nav-link <%= "profile".equals(activePage) ? "active flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-white transition-all" : "flex items-center gap-3 px-3 py-2.5 text-sm font-medium text-gray-500 transition-all" %>">
                <i class="fa-solid fa-user text-sm w-4 text-center <%= "profile".equals(activePage) ? "" : "text-gray-400" %>"></i> Mi Perfil
            </a>
        </nav>
    </div>

    <a href="<%=request.getContextPath()%>/logout"
       class="flex items-center gap-2 px-3 py-2.5 text-sm font-medium text-gray-400 hover:text-[#c8102e] transition-colors rounded-xl hover:bg-red-50">
        <i class="fa-solid fa-arrow-right-from-bracket text-sm w-4 text-center"></i> Cerrar sesión
    </a>
</aside>

<script>
    (function () {
        const toggle = document.getElementById('adminSidebarToggle');
        const sidebar = document.getElementById('adminSidebar');
        const backdrop = document.getElementById('adminSidebarBackdrop');

        if (!toggle || !sidebar || !backdrop) return;

        const open = () => {
            sidebar.classList.add('is-open');
            backdrop.classList.add('is-open');
            document.body.style.overflow = 'hidden';
        };

        const close = () => {
            sidebar.classList.remove('is-open');
            backdrop.classList.remove('is-open');
            document.body.style.overflow = '';
        };

        toggle.addEventListener('click', () => {
            if (sidebar.classList.contains('is-open')) {
                close();
            } else {
                open();
            }
        });

        backdrop.addEventListener('click', close);

        sidebar.querySelectorAll('a').forEach((link) => {
            link.addEventListener('click', () => {
                if (window.innerWidth < 768) close();
            });
        });

        window.addEventListener('resize', () => {
            if (window.innerWidth >= 768) {
                close();
            }
        });
    })();
</script>
