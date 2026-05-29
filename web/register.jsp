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
                    <input type="email" name="email" required placeholder="juan.perez@fesc.edu.co" 
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
                <p>En cumplimiento con lo establecido en la Ley 1581 de 2012 sobre Protección de Datos Personales y su decreto reglamentario 1377 de 2013 la FESC informa que, garantiza la protección plena del derecho de Habeas Data a estudiantes, empleados, proveedores, usuarios y grupos de interés. Todos los datos suministrados voluntaria y libremente se encuentran incorporados en nuestras bases de datos y tienen por finalidad ser recolectados, almacenados, usados y tratados por la FESC para el correcto y natural ejercicio de sus actividades de formación, administrativas, financieras, comercial, así como el envío de boletines informativos físicos y electrónicos e información publicitaria, permitiendo a las dependencias (académicas y administrativas) recolectar, recaudar, almacenar, usar, circular, suprimir, procesar, compilar, intercambiar, dar tratamiento, actualizar, y disponer de los datos que han sido suministrados y que se han incorporado en distintas bases o bancos de datos, o en repositorios electrónicos de todo tipo con que cuenta la Institución.</p>

                <p>Se recuerda a los usuarios que podrán ejercer los derechos en conocer, actualizar, rectificar y suprimir sus datos personales que se encuentran en nuestros archivos, en cualquier momento y sin ningún costo, previa acreditación de su identidad. Para lo anterior pueden contactarse por escrito a la dirección Av. 4 #15-14 barrio La Playa en Cúcuta, o en la sede Ocaña en la dirección KDX 194-785 barrio Llano de los Alcaldes, vía universitaria; a través de correo electrónico <a href="mailto:habeasdata@fesc.edu.co" class="text-[#c8102e] hover:underline">habeasdata@fesc.edu.co</a>, o al teléfono (037) 582 9292 Ext: 118.</p>

                <p>Para conocer más sobre nuestra Política de Tratamiento y Protección de Datos puede consultar el documento oficial en: <a href="http://www.fesc.edu.co/portal/archivos/reglamentos/politica_proteccion_datos.pdf" target="_blank" class="text-[#c8102e] hover:underline">http://www.fesc.edu.co/portal/archivos/reglamentos/politica_proteccion_datos.pdf</a></p>

                <p><strong>Por lo tanto, de forma LIBRE, PREVIA, EXPRESA, VOLUNTARIA e INFORMADA Usted acepta y reconoce que:</strong></p>
                <ol class="list-decimal pl-5 space-y-1">
                    <li>Entregará información personal a la FESC.</li>
                    <li>Esta información es y será utilizada en el desarrollo de las funciones propias de la Institución en su condición de institución de educación superior, de forma directa o a través de terceros.</li>
                    <li>La FESC en los términos dispuestos por el Decreto 1377 (Art. 10) queda autorizada de manera expresa e inequívoca para mantener y manejar toda su información, a no ser que usted manifieste lo contrario de manera directa, expresa, inequívoca.</li>
                </ol>

                <p class="mt-2"><strong>En señal de aceptación consiento y autorizo que mis datos personales sean tratados conforme a lo previsto en la presente autorización.</strong></p>
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
