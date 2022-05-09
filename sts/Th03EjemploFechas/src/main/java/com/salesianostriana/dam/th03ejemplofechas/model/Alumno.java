package com.salesianostriana.dam.th03ejemplofechas.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


//Anotaciones de Lombok y entidad
@Data @NoArgsConstructor
@AllArgsConstructor
@Entity
public class Alumno {
	
	@Id	
	@GeneratedValue(strategy=GenerationType.AUTO)
	private long id;
	
	private String nombre;
	private String apellidos;
	private String email;
	
	
//Anotamos con @DateTimeFormat de Spring para indicar el formato en el que queremos 
//la fecha, en esta caso, año, mes y día	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate fechaNacimiento;
	
	private LocalDateTime fechaUltimoAcceso;
	
	
	/**
	 * @param nombre
	 * @param apellidos
	 * @param email
	 */
	public Alumno(String nombre, String apellidos, String email) {
		this.nombre = nombre;
		this.apellidos = apellidos;
		this.email = email;
	}


	/**
	 * @param nombre
	 * @param apellidos
	 * @param email
	 * @param fechaNacimiento
	 */
	public Alumno(String nombre, String apellidos, String email, LocalDate fechaNacimiento) {
		this.nombre = nombre;
		this.apellidos = apellidos;
		this.email = email;
		this.fechaNacimiento = fechaNacimiento;
	}
	
}