package model;

/**
 * Represents an administrator in the system. Administrators
 * manage and respond to academic requests submitted by
 * students. Like students, administrator passwords are kept
 * in plain text for demonstration and should be hashed in a
 * production environment.
 */
public class Admin {
    private int id;
    private String nombre;
    private String email;
    private String password;

    public Admin() {}

    public Admin(int id, String nombre, String email, String password) {
        this.id = id;
        this.nombre = nombre;
        this.email = email;
        this.password = password;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}