<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Iniciar Sesión - Sistema de Solicitudes Académicas</title>
        <!-- Tailwind CSS via CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Font Awesome para icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

            body {
                font-family: 'Inter', sans-serif;
            }
        </style>
    </head>

    <body class="min-h-screen flex flex-col items-center justify-center bg-[#f4f5f7] p-4">

        <div class="w-11/12 max-w-[420px] bg-white shadow-2xl rounded-xl p-6 sm:p-8">

            <!-- Logo Header -->
            <div class="flex flex-col items-center mb-6">
                <!-- Logo -->
                <img src="<%=request.getContextPath()%>/assets/images/logo-fesc.png" alt="FESC Logo"
                    class="h-16 mb-4 object-contain"
                    onerror="this.outerHTML='<div class=\'text-center leading-none mb-4\'><span class=\'text-4xl font-black italic text-gray-800 tracking-tighter\'>FESC<span class=\'text-[#c8102e]\'>.</span></span><p class=\'text-[9px] font-bold text-gray-500 mt-1\'>La Universidad de Comfanorte</p></div>'">

                <h1 class="text-xl font-bold text-[#c8102e] text-center leading-tight">
                    Gestión de Solicitudes Académicas
                </h1>
                <p class="text-sm font-semibold text-gray-500 mt-2">Acceso Institucional</p>
            </div>

            <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                <div class="mb-6 p-3 bg-red-50 border-l-4 border-[#c8102e] text-[#c8102e] text-sm rounded-r">
                    <%= error %>
                </div>
                <% } %>

                    <form action="<%=request.getContextPath()%>/login" method="post" class="space-y-5">
                        <!-- Correo electrónico -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">Correo electrónico</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fa-regular fa-envelope text-gray-400"></i>
                                </div>
                                <input type="email" name="email" placeholder="ejemplo@fesc.edu.co" required
                                    class="w-full pl-10 pr-4 py-3 bg-gray-50 border border-gray-100 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 focus:bg-white transition-colors" />
                            </div>
                        </div>

                        <!-- Contraseña -->
                        <div>
                            <div class="flex justify-between items-center mb-1">
                                <label class="block text-sm font-semibold text-gray-700">Contraseña</label>
                                <a href="#" class="text-xs font-bold text-[#c8102e] hover:underline">¿Olvidaste tu
                                    contraseña?</a>
                            </div>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fa-solid fa-lock text-gray-400"></i>
                                </div>
                                <input type="password" id="passwordInput" name="password" placeholder="••••••••" required
                                    class="w-full pl-10 pr-10 py-3 bg-gray-50 border border-gray-100 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 focus:bg-white transition-colors" />
                                <button type="button" id="togglePassword"
                                    class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600 focus:outline-none">
                                    <i id="eyeIcon" class="fa-regular fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Rol -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">Rol</label>
                            <div class="relative">
                                <select name="role" required
                                    class="w-full px-4 py-3 bg-gray-50 border border-gray-100 rounded-lg text-sm text-gray-500 appearance-none focus:outline-none focus:ring-2 focus:ring-[#c8102e]/50 focus:bg-white transition-colors cursor-pointer">
                                    <option value="student">Estudiante</option>
                                    <option value="admin">Administrador</option>
                                </select>
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                    <i class="fa-solid fa-chevron-down text-gray-400 text-xs"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Boton de enviar -->
                        <button type="submit"
                            class="w-full bg-[#c8102e] text-white font-bold py-3 px-4 rounded-lg hover:bg-red-800 transition-colors flex justify-center items-center gap-2 mt-2 shadow-md shadow-red-600/20">
                            Iniciar Sesión <i class="fa-solid fa-arrow-right-to-bracket"></i>
                        </button>
                    </form>

                    <!-- Footer link dentro de la card -->
                    <div class="mt-8 text-center text-sm text-gray-500">
                        ¿Eres nuevo en la plataforma? <a href="#"
                            class="text-[#c8102e] font-bold hover:underline">Solicitar acceso</a>
                    </div>
        </div>

        <script>
            // Mostrar u ocultar contraseña
            const togglePassword = document.querySelector('#togglePassword');
            const passwordInput = document.querySelector('#passwordInput');
            const eyeIcon = document.querySelector('#eyeIcon');

            togglePassword.addEventListener('click', function (e) {
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
        </script>
    </body>

    </html>