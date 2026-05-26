# Etapa 1: Construcción (Build) — usar JDK 21 para compilar con javac 21
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

# Instalar Apache Ant y curl
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ant curl \
    && rm -rf /var/lib/apt/lists/*

# Descargar Tomcat temporalmente (para resolver j2ee.server.home)
RUN curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz -o /tmp/tomcat.tar.gz \
    && mkdir -p /opt/tomcat-build \
    && tar -xzf /tmp/tomcat.tar.gz -C /opt/tomcat-build --strip-components=1

# Descargar la librería CopyLibs de NetBeans (para resolver libs.CopyLibs.classpath)
RUN curl -fsSL https://repo1.maven.org/maven2/org/netbeans/api/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE120/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE120.jar -o /opt/copylibs.jar

# Copiar el código fuente
COPY . .

# Compilar indicándole a Ant dónde están las dependencias de servidor y de empaquetado
RUN ant -Dj2ee.server.home=/opt/tomcat-build -Dlibs.CopyLibs.classpath=/opt/copylibs.jar

# Etapa 2: Producción — JRE 21 + Tomcat instalado manualmente para asegurar compatibilidad con Java 21
FROM eclipse-temurin:21-jre AS runtime
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Instalar utilidades necesarias para descargar Tomcat
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Tomcat 9 (fijar versión con ARG para reproducibilidad)
ARG TOMCAT_VERSION=9.0.80
RUN curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o /tmp/tomcat.tar.gz \
    && mkdir -p $CATALINA_HOME \
    && tar -xzf /tmp/tomcat.tar.gz -C /opt \
    && mv /opt/apache-tomcat-${TOMCAT_VERSION}/* $CATALINA_HOME/ \
    && rm -rf /opt/apache-tomcat-${TOMCAT_VERSION} /tmp/tomcat.tar.gz

# Limpiar las aplicaciones por defecto de Tomcat
RUN rm -rf $CATALINA_HOME/webapps/*

# Copiar el WAR generado (Asegúrate de que el nombre del war coincida con el que genera tu proyecto)
COPY --from=builder /app/dist/*.war $CATALINA_HOME/webapps/ROOT.war

# Crear un usuario `tomcat` y directorio para adjuntos; asignar propiedad a tomcat
RUN useradd -r -s /bin/false tomcat || true \
    && mkdir -p /var/solicitudes_adjuntos \
    && chown -R tomcat:tomcat /var/solicitudes_adjuntos $CATALINA_HOME

EXPOSE 8080
USER tomcat
CMD ["catalina.sh", "run"]