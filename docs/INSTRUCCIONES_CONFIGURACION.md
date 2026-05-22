## Configuración local

## 1. Credenciales de base de datos

1. Abre `src/java/`.
2. Copia `database.properties.example` y renombra la copia como `database.properties`.
3. Edita el archivo con tu contraseña de MySQL:
```properties
    db.user=root
    db.password=TU_CONTRASEÑA
```

> `database.properties` está en `.gitignore` — nunca se sube a GitHub.

---

## 2. Reconstruir el proyecto

1. Clic derecho sobre el proyecto en NetBeans.
2. Selecciona **Clean and Build**.

> Esto actualiza la ruta del `.jar` de MySQL y copia las credenciales al output.

---

## 3. Ejecutar

1. Clic derecho → Properties → Run → confirma que el servidor sea **Apache Tomcat**.
2. Presiona **Run**.

> Cualquier error de conexión aparece en la pestaña Output de NetBeans.

---

## 4. Configuración en VS Code

Si prefieres editar y ejecutar el proyecto desde Visual Studio Code, sigue estos pasos.

### Requisitos previos

- Tener instalado Java JDK (versión 8+). Asegúrate de que `JAVA_HOME` esté configurado en tu sistema.
- Tener Apache Tomcat instalado localmente para desplegar la aplicación (o usar la extensión de Tomcat en VS Code).
- Tener instalado VS Code.

### Extensiones recomendadas

- `Extension Pack for Java` (incluye Language Support for Java y Debugger for Java).
- `Tomcat for Java` (para administrar servidores Tomcat y desplegar aplicaciones desde VS Code).

Instala estas extensiones desde el Marketplace de VS Code (pestaña Extensiones).

### Pasos de configuración rápida

1. Abre la carpeta del proyecto en VS Code: `File -> Open Folder...` y selecciona la raíz del proyecto.
2. Copia las credenciales de la base de datos igual que en NetBeans: en `src/java/` duplica `database.properties.example` como `database.properties` y edítalo con tus datos.

### Compilar con Ant desde VS Code

Puedes ejecutar las tareas de Ant desde la terminal integrada o crear una tarea en `.vscode/tasks.json`.

Ejemplo mínimo para ejecutar Ant desde la terminal:

```bash
cd /ruta/al/proyecto
ant clean
ant
```

Ejemplo de `.vscode/tasks.json` (crea la carpeta `.vscode/` en la raíz si no existe):

```json
{
   "version": "2.0.0",
   "tasks": [
      {
         "label": "Ant: clean & build",
         "type": "shell",
         "command": "ant clean && ant",
         "group": "build",
         "presentation": { "reveal": "always" }
      }
   ]
}
```

Ejecuta la tarea con `Terminal -> Run Task... -> Ant: clean & build`.

### Desplegar y depurar en Tomcat

Opción 1 — usar la extensión `Tomcat for Java`:

- Instala y abre la vista de Tomcat en el lateral de VS Code.
- Añade una instancia de Tomcat (apunta a la carpeta de instalación de Tomcat).
- Desde la vista de Tomcat, haz clic derecho sobre el servidor y selecciona `Add Webapp...`, elige la carpeta `build/web` o el WAR generado.
- Inicia el servidor desde la extensión y abre la URL en el navegador.

Opción 2 — desplegar manualmente:

- Copia el WAR o la carpeta web generada a `TOMCAT_HOME/webapps/` y arranca Tomcat.

Para depurar con el depurador Java de VS Code, configura Tomcat para arrancar con JDWP (por ejemplo, en catalina.sh añadir `-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005`) y luego usa `launch.json` para adjuntarte:

Ejemplo de `.vscode/launch.json` para adjuntar al puerto 5005:

```json
{
   "version": "0.2.0",
   "configurations": [
      {
         "type": "java",
         "name": "Attach to Tomcat",
         "request": "attach",
         "hostName": "localhost",
         "port": 5005
      }
   ]
}
```

### Notas finales

- Asegúrate de que `database.properties` (local) no se suba a Git. El archivo de ejemplo `database.properties.example` sirve como plantilla.
- Si usas la extensión de Tomcat, la extensión puede desplegar automáticamente el contenido compilado; revisa la configuración de la extensión para rutas de despliegue.
- Si encuentras errores, revisa la `Output` y la consola de `Problems` en VS Code.

---
