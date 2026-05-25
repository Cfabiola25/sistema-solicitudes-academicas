<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Sede, model.Jornada, model.ProgramaAcademico" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Estudiante - Sistema de Solicitudes</title>
    <!-- Tailwind CSS via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="min-h-screen bg-[#f4f5f7] flex flex-col items-center justify-center p-4">

    <div class="w-full max-w-[500px] bg-white shadow-2xl rounded-2xl p-6 sm:p-8 my-8 border border-gray-100">
        
        <!-- Header -->
        <div class="flex flex-col items-center mb-6">
            <div class="w-12 h-12 rounded-xl bg-[#c8102e]/10 flex items-center justify-center mb-3">
                <i class="fa-solid fa-user-plus text-[#c8102e] text-xl"></i>
            </div>
            <h1 class="text-xl font-extrabold text-gray-900 text-center leading-tight">
                Crear Cuenta de Estudiante
            </h1>
            <p class="text-xs text-gray-400 mt-1 text-center">Regístrate para gestionar tus solicitudes académicas.</p>
        </div>

        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
            <div class="mb-4 p-3 bg-red-50 border-l-4 border-[#c8102e] text-[#c8102e] text-xs font-semibold rounded-r">
                <i class="fa-solid fa-triangle-exclamation mr-2"></i> <%= error %>
            </div>
        <% } %>

        <form action="<%=request.getContextPath()%>/register" method="post" class="space-y-4">
            
            <!-- Nombre y Apellido -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Nombre *</label>
                    <input type="text" name="nombre" required placeholder="Juan" 
                           class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 focus:bg-white transition-colors" />
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Apellido *</label>
                    <input type="text" name="apellido" required placeholder="Pérez" 
                           class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 focus:bg-white transition-colors" />
                </div>
            </div>

            <!-- Email -->
            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Correo Institucional *</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400"><i class="fa-regular fa-envelope"></i></span>
                    <input type="email" name="email" required placeholder="juan.perez@example.com" 
                           class="w-full pl-9 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 focus:bg-white transition-colors" />
                </div>
            </div>

            <!-- Contraseña -->
            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Contraseña *</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" id="password" name="password" required placeholder="••••••••" 
                           class="w-full pl-9 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 focus:bg-white transition-colors" />
                </div>
            </div>

            <!-- Programa Académico -->
            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Programa Académico *</label>
                <select name="programaId" required 
                        class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 cursor-pointer">
                    <option value="">Selecciona tu programa</option>
                    <% List<ProgramaAcademico> programas = (List<ProgramaAcademico>) request.getAttribute("programas");
                       if (programas != null) {
                           for (ProgramaAcademico p : programas) { %>
                               <option value="<%= p.getId() %>"><%= p.getNombre() %></option>
                       <% } } %>
                </select>
            </div>

            <!-- Sede y Jornada -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Sede *</label>
                    <select name="sedeId" required 
                            class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 cursor-pointer">
                        <option value="">Selecciona sede</option>
                        <% List<Sede> sedes = (List<Sede>) request.getAttribute("sedes");
                           if (sedes != null) {
                               for (Sede s : sedes) { %>
                                   <option value="<%= s.getId() %>"><%= s.getNombre() %></option>
                           <% } } %>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">Jornada *</label>
                    <select name="jornadaId" required 
                            class="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#c8102e]/30 cursor-pointer">
                        <option value="">Selecciona jornada</option>
                        <% List<Jornada> jornadas = (List<Jornada>) request.getAttribute("jornadas");
                           if (jornadas != null) {
                               for (Jornada j : jornadas) { %>
                                   <option value="<%= j.getId() %>"><%= j.getNombre() %></option>
                           <% } } %>
                    </select>
                </div>
            </div>

            <!-- Políticas de privacidad Checkbox -->
            <div class="flex items-start gap-2 pt-2">
                <input type="checkbox" id="terminos" name="terminosAceptados" required 
                       class="mt-1 h-4 w-4 rounded border-gray-300 text-[#c8102e] focus:ring-[#c8102e]/30 cursor-pointer" />
                <label for="terminos" class="text-xs text-gray-500 cursor-pointer">
                    Acepto los <a href="#" onclick="toggleModal(true)" class="text-[#c8102e] font-semibold hover:underline">términos legales y la política de privacidad</a> de tratamiento de datos personales de la institución.
                </label>
            </div>

            <!-- Submit Button -->
            <button type="submit" 
                    class="w-full bg-[#c8102e] text-white font-bold py-2.5 rounded-lg hover:bg-red-800 transition-colors flex justify-center items-center gap-2 mt-4 shadow-md shadow-red-600/10">
                Registrarse <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>

        <!-- Back to Login -->
        <div class="mt-6 text-center text-xs text-gray-400">
            ¿Ya tienes una cuenta? <a href="<%=request.getContextPath()%>/login" class="text-[#c8102e] font-bold hover:underline">Inicia Sesión</a>
        </div>
    </div>

    <!-- Modal Políticas de Privacidad -->
    <div id="privacyModal" class="fixed inset-0 bg-black/50 items-center justify-center p-4 z-50 hidden flex">
        <div class="bg-white rounded-2xl max-w-[450px] w-full p-6 shadow-2xl relative border border-gray-100 max-h-[80vh] overflow-y-auto">
            <h3 class="text-lg font-bold text-gray-900 mb-3 border-b border-gray-100 pb-2 text-[#c8102e]">
                <i class="fa-solid fa-shield-halved mr-2"></i> Política de Privacidad
            </h3>
            <div class="text-xs text-gray-500 space-y-3 leading-relaxed">
                <p>En cumplimiento con las normas de protección de datos personales, le informamos que al registrarse en esta plataforma, usted autoriza el tratamiento de sus datos de identificación y académicos.</p>
                <p><strong>Uso de la Información:</strong> Los datos personales recopilados se utilizarán exclusivamente para tramitar y responder a las solicitudes académicas realizadas ante la FESC.</p>
                <p><strong>Seguridad de Credenciales:</strong> Sus contraseñas de acceso son resguardadas utilizando tecnologías criptográficas modernas (SHA-256 combinada con sal dinámica) para evitar accesos no autorizados.</p>
                <p><strong>Derechos del Titular:</strong> Como titular de los datos, tiene derecho a conocer, actualizar y rectificar su información personal en cualquier momento a través de los canales institucionales oficiales.</p>
            </div>
            <div class="mt-6 flex justify-end">
                <button onclick="toggleModal(false)" 
                        class="bg-gray-100 hover:bg-gray-200 text-gray-800 font-bold px-4 py-2 rounded-lg text-xs transition-colors">
                    Entendido
                </button>
            </div>
        </div>
    </div>

    <script>
        function toggleModal(show) {
            const modal = document.getElementById('privacyModal');
            if (show) {
                modal.classList.remove('hidden');
            } else {
                modal.classList.add('hidden');
            }
        }
    </script>
</body>
</html>
