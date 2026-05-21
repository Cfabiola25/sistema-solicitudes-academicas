package model;

/**
 * Represents a student in the system. Students can submit
 * academic requests and view their history. Each student is
 * associated with an academic program, a campus (sede) and a
 * study schedule (jornada). Passwords are stored as plain text
 * for demonstration purposes; in a real application they should
 * be securely hashed.
 */
public class Student {
    private int id;
    private String nombre;
    private String apellido;
    private String email;
    private String password;
    private Integer programaId;
    private Integer sedeId;
    private Integer jornadaId;
    private String programaNombre;
    private String sedeNombre;
    private String jornadaNombre;

    public Student() {}

    public Student(int id, String nombre, String apellido, String email, String password,
                   Integer programaId, Integer sedeId, Integer jornadaId) {
        this.id = id;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.password = password;
        this.programaId = programaId;
        this.sedeId = sedeId;
        this.jornadaId = jornadaId;
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

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
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

    public Integer getProgramaId() {
        return programaId;
    }

    public void setProgramaId(Integer programaId) {
        this.programaId = programaId;
    }

    public Integer getSedeId() {
        return sedeId;
    }

    public void setSedeId(Integer sedeId) {
        this.sedeId = sedeId;
    }

    public Integer getJornadaId() {
        return jornadaId;
    }

    public void setJornadaId(Integer jornadaId) {
        this.jornadaId = jornadaId;
    }

    public String getProgramaNombre() {
        return programaNombre;
    }

    public void setProgramaNombre(String programaNombre) {
        this.programaNombre = programaNombre;
    }

    public String getSedeNombre() {
        return sedeNombre;
    }

    public void setSedeNombre(String sedeNombre) {
        this.sedeNombre = sedeNombre;
    }

    public String getJornadaNombre() {
        return jornadaNombre;
    }

    public void setJornadaNombre(String jornadaNombre) {
        this.jornadaNombre = jornadaNombre;
    }

    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }
}