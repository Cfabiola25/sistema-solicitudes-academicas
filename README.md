# Solicitudes Académicas

> Aplicación web para gestionar solicitudes académicas de estudiantes y administradores.

## ¿Qué es esto?

Este proyecto es una aplicación Java EE basada en servlets y JSP para gestionar solicitudes académicas, con paneles separados para estudiantes y administradores.

## Tecnologías

- Java Servlet / JSP
- Apache Tomcat (despliegue)
- MySQL
- Apache Ant / NetBeans
- JSP para vistas y servlets para controladores

## Requisitos previos

- Java JDK 8 o superior
- Apache Tomcat instalado localmente
- MySQL o MariaDB
- Apache Ant (o NetBeans para compilar y ejecutar)

## Instalación

```bash
git clone <repo-url>  # <!-- TODO: completar -->
cd solicitudes-academicas
```

## Configuración

1. Copia `src/java/database.properties.example` como `src/java/database.properties`.
2. Ajusta los valores de conexión MySQL:

```properties
db.url=jdbc:mysql://localhost:3306/fesc_solicitudes?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Bogota
db.user=root
db.password=TU_CONTRASEÑA
```

3. Asegúrate de que `src/java/database.properties` no se suba a Git.
4. Revisa `docs/INSTRUCCIONES_CONFIGURACION.md` para pasos adicionales de NetBeans y VS Code.

## Uso / Desarrollo local

### Con NetBeans

- Abre el proyecto en NetBeans.
- Ejecuta **Clean and Build**.
- Inicia el proyecto en Apache Tomcat desde NetBeans.

### Con Ant

```bash
ant clean
ant
```

### Desplegar en Tomcat

- Copia el WAR generado o la carpeta compilada a `TOMCAT_HOME/webapps/`.
- Inicia Tomcat.

## Scripts disponibles

- `ant clean` — limpia los artefactos de compilación.
- `ant` — compila y empaqueta la aplicación.

## Estructura del proyecto

```text
src/java/           # Código fuente Java y configuración
web/                # Vistas JSP y recursos web
build/              # Artefactos generados y salida de compilación
docs/               # Documentación adicional
nbproject/          # Archivos de proyecto NetBeans
```

## Documentación adicional

- `docs/INSTRUCCIONES_CONFIGURACION.md` — instrucciones de configuración local y despliegue.

## Cómo contribuir

1. Crea una rama nueva para tu cambio.
2. Sigue el estilo de código existente en Java y JSP.
3. Si agregas configuración, incluye un ejemplo en `database.properties.example`.

## Licencia

<!-- TODO: completar -->
