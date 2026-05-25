package model;

/**
 * Represents a type of academic request. Examples include
 * cancellation of a semester, directed courses, changes in
 * study schedule, etc. The available types are loaded from
 * the database and presented to the student when creating
 * a new request.
 */
public class TipoSolicitud {
    private int id;
    private String nombre;
    private int tiempoRespuestaDias;
    private String tipoTiempo;

    public TipoSolicitud() {}

    public TipoSolicitud(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    public TipoSolicitud(int id, String nombre, int tiempoRespuestaDias, String tipoTiempo) {
        this.id = id;
        this.nombre = nombre;
        this.tiempoRespuestaDias = tiempoRespuestaDias;
        this.tipoTiempo = tipoTiempo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getTiempoRespuestaDias() {
        return tiempoRespuestaDias;
    }

    public void setTiempoRespuestaDias(int tiempoRespuestaDias) {
        this.tiempoRespuestaDias = tiempoRespuestaDias;
    }

    public String getTipoTiempo() {
        return tipoTiempo;
    }

    public void setTipoTiempo(String tipoTiempo) {
        this.tipoTiempo = tipoTiempo;
    }

    @Override
    public String toString() {
        return nombre;
    }
}