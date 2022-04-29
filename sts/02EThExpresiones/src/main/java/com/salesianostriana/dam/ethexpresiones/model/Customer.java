package com.salesianostriana.dam.ethexpresiones.model;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor
public class Customer {

	
	private String nombre;
	private String apellido1;
	private String apellido2;
	private String genero;
	private long id;
}
