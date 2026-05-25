package model;

import java.time.LocalDateTime;

/**
 * Represents an academic request submitted by a student.
 * Each request has a type, description, submission date,
 * current state and optionally a response by an administrator.
 */
public class Solicitud {
    private int id;
    private Student estudiante;
    private TipoSolicitud tipo;
    private String descripcion;
    private LocalDateTime fechaSolicitud;
    private String estado; // Enviada, Pendiente, Aprobada, Rechazada
    private String documento;
    private LocalDateTime fechaRespuesta;
    private String comentarioRespuesta;
    private Admin administrador;
    private Admin responsable;
    private LocalDateTime fechaLimite;

    public Solicitud() {}

    public Solicitud(int id, Student estudiante, TipoSolicitud tipo,
                     String descripcion, LocalDateTime fechaSolicitud,
                     String estado, String documento,
                     LocalDateTime fechaRespuesta,
                     String comentarioRespuesta, Admin administrador) {
        this.id = id;
        this.estudiante = estudiante;
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.fechaSolicitud = fechaSolicitud;
        this.estado = estado;
        this.documento = documento;
        this.fechaRespuesta = fechaRespuesta;
        this.comentarioRespuesta = comentarioRespuesta;
        this.administrador = administrador;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Student getEstudiante() {
        return estudiante;
    }

    public void setEstudiante(Student estudiante) {
        this.estudiante = estudiante;
    }

    public TipoSolicitud getTipo() {
        return tipo;
    }

    public void setTipo(TipoSolicitud tipo) {
        this.tipo = tipo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDateTime getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(LocalDateTime fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public LocalDateTime getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(LocalDateTime fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public String getComentarioRespuesta() {
        return comentarioRespuesta;
    }

    public void setComentarioRespuesta(String comentarioRespuesta) {
        this.comentarioRespuesta = comentarioRespuesta;
    }

    public Admin getAdministrador() {
        return administrador;
    }

    public void setAdministrador(Admin administrador) {
        this.administrador = administrador;
    }

    public Admin getResponsable() {
        return responsable;
    }

    public void setResponsable(Admin responsable) {
        this.responsable = responsable;
    }

    public LocalDateTime getFechaLimite() {
        return fechaLimite;
    }

    public void setFechaLimite(LocalDateTime fechaLimite) {
        this.fechaLimite = fechaLimite;
    }
}