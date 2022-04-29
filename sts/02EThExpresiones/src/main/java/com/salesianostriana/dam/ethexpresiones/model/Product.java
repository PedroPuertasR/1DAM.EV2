package com.salesianostriana.dam.ethexpresiones.model;

import java.util.Calendar;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data @NoArgsConstructor @AllArgsConstructor
public class Product {

	private long id;
	
	private String name;
	
	private String description;
	
	private double price;
	
	private boolean inStock = false;
	
	private Calendar date; //Más adelante se ve la forma de usar fechas con Java.Time, ahora solo se usa Calendar para el ejemplo

}
