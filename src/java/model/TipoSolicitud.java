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

    public TipoSolicitud() {}

    public TipoSolicitud(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
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

    @Override
    public String toString() {
        return nombre;
    }
}