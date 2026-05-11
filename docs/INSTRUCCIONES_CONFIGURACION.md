# Configuración local

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