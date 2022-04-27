package com.salesianostriana.dam.ethholamundo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//Una clase POJO como las que hemos estado trabajando durante todo el año
//Esta clase iría en el paquet model, está colacada aquí solo ppor comodidad para el ejemplo

@Data @NoArgsConstructor @AllArgsConstructor
public class Persona {

	private String nombre;
	private String apellidos;
	
}
