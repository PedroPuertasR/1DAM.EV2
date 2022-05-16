package com.salesianostriana.dam.ethlistadosavanzados.modelo;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Data @NoArgsConstructor @AllArgsConstructor
public class Producto {

	
	@Id
	@GeneratedValue
	private Long id;
	
	private String nombre;
	
	@Lob 
	private String descripcion;
	
	private float pvp;
	
	private float descuento;
	
	private String imagen;
	
	@ManyToOne
	private Categoria categoria;
	
	
	//Ojo, Excluimos Equals y hashcode y toString de Lombok para evitar problemas con la asociación	
	//Como se ha visto en clase con Luismi
	//Es una collección que guardará las puntuaciones de cada producto (un producto puede tener muchas puntuaciones)
	@EqualsAndHashCode.Exclude
	@ToString.Exclude
	@OneToMany(mappedBy="producto", cascade=CascadeType.ALL, orphanRemoval=true, fetch=FetchType.EAGER)
	private Set<Puntuacion> puntuaciones = new HashSet<Puntuacion>();
	
	public Producto(String nombre, String descripcion, float pvp, float descuento, String imagen, Categoria categoria) {
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.pvp = pvp;
		this.descuento = descuento;
		this.imagen = imagen;
		this.categoria = categoria;
	}
	
	/**
	 * Métodos helper que ayudarán a las puntuaciones, se explican en el video
	 */
	public void addPuntuacion(Puntuacion puntuacion) {
		this.puntuaciones.add(puntuacion);
		puntuacion.setProducto(this);
	}
	
	/**
	 * Para calcular la media de puntuación. 
	 * Comprobamos que no se acero
	 * Se utiliza Stream en el que:
	 * this.puntuaciones.stream()	Sacamos un stream con las puntuaciones: 
	 * .mapToInt(Puntuacion::getPuntuacion)	Creamos un Stream de enteros (es lo que devuelve mapToInt) con el valor 
	 * "puntuación" de cada elemento
	 * .average()	Calcula la media
	 * .getAsDouble();		Pasamos le resultado a double para ver la media con decimales
	 * */
	
	public double getPuntuacionMedia() {
		if (this.puntuaciones.isEmpty())
			return 0;
		else 
			return this.puntuaciones.stream()
					.mapToInt(Puntuacion::getPuntuacion)
					.average()
					.getAsDouble();
	}
	
	public double getNumeroTotalPuntuaciones() {
		return this.puntuaciones.size();
	}
}
