<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Sistema de Solicitudes Académicas</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous"
          referrerpolicy="no-referrer" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * {
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
    </style>
</head>

<body class="min-h-screen flex flex-col items-center justify-center bg-[#f4f5f7] p-4">

<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>

<div class="w-11/12 max-w-[430px] bg-white shadow-2xl rounded-2xl p-6 sm:p-8 border border-gray-100">

    <div class="flex flex-col items-center mb-6">
        <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png"
             alt="FESC Logo"
             class="h-16 mb-4 object-contain"
             onerror="this.outerHTML='<div class=\'text-center leading-none mb-4\'><span class=\'text-4xl font-black italic text-gray-800 tracking-tighter\'>FESC<span class=\'text-[#c8102e]\'>.</span></span><p class=\'text-[9px] font-bold text-gray-500 mt-1\'>La Universidad de Comfanorte</p></div>'">

        <h1 class="text-xl font-extrabold text-[#c8102e] text-center leading-tight">
            Gestión de Solicitudes Académicas
        </h1>

        <p class="text-sm font-semibold text-gray-500 mt-2">
            Acceso Institucional
        </p>
    </div>

    <% if (error != null) { %>
        <div class="mb-5 p-3 bg-red-50 border-l-4 border-[#c8102e] text-[#c8102e] text-sm rounded-r font-semibold">
            <i class="fa-solid fa-triangle-exclamation mr-2"></i>
            <%= error %>
        </div>
    <% } %>

    <% if (success != null) { %>
        <div class="mb-5 p-3 bg-green-50 border-l-4 border-green-500 text-green-700 text-sm rounded-r font-semibold">
            <i class="fa-solid fa-circle-check mr-2"></i>
            <%= success %>
        </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/login" method="post" class="space-y-5">

        <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">
                Correo electrónico
            </label>

            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <i class="fa-regular fa-envelope text-gray-400"></i>
                </div>

                <input type="email"
                       name="email"
                       placeholder="ejemplo@fesc.edu.co"
                       required
                       autocomplete="email"
                       class="w-full pl-10 pr-4 py-3 bg-gray-50 border border-gray-100 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 focus:bg-white transition-colors" />
            </div>
        </div>

        <div>
            <div class="flex justify-between items-center mb-1">
                <label class="block text-sm font-semibold text-gray-700">
                    Contraseña
                </label>

                <a href="<%=request.getContextPath()%>/forgot-password"
                   class="text-xs font-bold text-[#c8102e] hover:underline">
                    ¿Olvidaste tu contraseña?
                </a>
            </div>

            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <i class="fa-solid fa-lock text-gray-400"></i>
                </div>

                <input type="password"
                       id="passwordInput"
                       name="password"
                       placeholder="••••••••"
                       required
                       autocomplete="current-password"
                       class="w-full pl-10 pr-10 py-3 bg-gray-50 border border-gray-100 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 focus:bg-white transition-colors" />

                <button type="button"
                        id="togglePassword"
                        class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none">
                    <i id="eyeIcon" class="fa-regular fa-eye"></i>
                </button>
            </div>
        </div>

        <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">
                Tipo de perfil
            </label>

            <div class="relative">
                <select name="role"
                        required
                        class="w-full px-4 py-3 bg-gray-50 border border-gray-100 rounded-xl text-sm text-gray-600 appearance-none focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 focus:bg-white transition-colors cursor-pointer">
                    <option value="student">Estudiante</option>
                    <option value="admin">Administrador</option>
                </select>

                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                    <i class="fa-solid fa-chevron-down text-gray-400 text-xs"></i>
                </div>
            </div>
        </div>

        <button type="submit"
                class="w-full bg-[#c8102e] text-white font-bold py-3 px-4 rounded-xl hover:bg-red-800 transition-colors flex justify-center items-center gap-2 mt-2 shadow-md shadow-red-600/20">
            Iniciar Sesión
            <i class="fa-solid fa-arrow-right-to-bracket"></i>
        </button>
    </form>

    <div class="mt-8 text-center text-sm text-gray-500">
        ¿Eres nuevo en la plataforma?
        <a href="<%=request.getContextPath()%>/register"
           class="text-[#c8102e] font-bold hover:underline">
            Solicitar acceso
        </a>
    </div>
</div>

<script>
    const togglePassword = document.querySelector('#togglePassword');
    const passwordInput = document.querySelector('#passwordInput');
    const eyeIcon = document.querySelector('#eyeIcon');

    if (togglePassword && passwordInput && eyeIcon) {
        togglePassword.addEventListener('click', function () {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            if (type === 'text') {
                eyeIcon.classList.remove('fa-eye');
                eyeIcon.classList.add('fa-eye-slash');
            } else {
                eyeIcon.classList.remove('fa-eye-slash');
                eyeIcon.classList.add('fa-eye');
            }
        });
    }
</script>

</body>
</html>