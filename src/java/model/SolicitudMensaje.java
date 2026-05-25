package model;

import java.time.LocalDateTime;

public class SolicitudMensaje {
    private int id;
    private int solicitudId;
    private String autorRol;
    private String autorNombre;
    private String mensaje;
    private String archivo;
    private LocalDateTime fechaEnvio;

    public SolicitudMensaje() {}

    public SolicitudMensaje(int id, int solicitudId, String autorRol, String autorNombre, String mensaje, String archivo, LocalDateTime fechaEnvio) {
        this.id = id;
        this.solicitudId = solicitudId;
        this.autorRol = autorRol;
        this.autorNombre = autorNombre;
        this.mensaje = mensaje;
        this.archivo = archivo;
        this.fechaEnvio = fechaEnvio;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSolicitudId() {
        return solicitudId;
    }

    public void setSolicitudId(int solicitudId) {
        this.solicitudId = solicitudId;
    }

    public String getAutorRol() {
        return autorRol;
    }

    public void setAutorRol(String autorRol) {
        this.autorRol = autorRol;
    }

    public String getAutorNombre() {
        return autorNombre;
    }

    public void setAutorNombre(String autorNombre) {
        this.autorNombre = autorNombre;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getArchivo() {
        return archivo;
    }

    public void setArchivo(String archivo) {
        this.archivo = archivo;
    }

    public LocalDateTime getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(LocalDateTime fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }
}