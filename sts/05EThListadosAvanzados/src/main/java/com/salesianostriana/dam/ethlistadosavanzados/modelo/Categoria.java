package com.salesianostriana.dam.ethlistadosavanzados.modelo;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity @Data @NoArgsConstructor @AllArgsConstructor
public class Categoria {

	
	@Id
	@GeneratedValue
	private Long id;
	
	private String nombre;
	
	private boolean destacada;
	
	private String imagen;
}
