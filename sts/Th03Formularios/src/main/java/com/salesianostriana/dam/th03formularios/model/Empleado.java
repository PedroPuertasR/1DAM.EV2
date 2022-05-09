package com.salesianostriana.dam.th03formularios.model;

public class Empleado {

	
	private String nombre;
    private long id;
    private String email;
    
    public Empleado() {
    	
    }
    
	public Empleado(String nombre, long id, String email) {
		this.nombre = nombre;
		this.id = id;
		this.email = email;
	}
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	@Override
	public String toString() {
		return "Empleado [nombre=" + nombre + ", id=" + id + ", email=" + email + "]";
	}
}
