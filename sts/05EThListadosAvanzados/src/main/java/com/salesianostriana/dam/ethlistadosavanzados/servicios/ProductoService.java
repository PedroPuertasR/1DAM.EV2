package com.salesianostriana.dam.ethlistadosavanzados.servicios;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.salesianostriana.dam.ethlistadosavanzados.modelo.Categoria;
import com.salesianostriana.dam.ethlistadosavanzados.modelo.Producto;
import com.salesianostriana.dam.ethlistadosavanzados.repositorios.ProductoRepository;


@Service
public class ProductoService {
	
	//No echéis cuenta al autowired, ya ha explicado Luismi la forma en la que lo haremos este año sin usarlo
	
	//Se han explicado los repositorios y servicios en las clases de Luismi. 
	//Se agrega un servicio además de los "típicos" abajo del todo
	@Autowired
	private ProductoRepository repositorio;
	
	public List<Producto> findAll() {
		return repositorio.findAll();
	}
	
	public List<Producto> findAllByCategoria(Categoria categoria) {
		return repositorio.findByCategoria(categoria);
	}
	
	public List<Producto> findAllByCategoria(Long categoriaId) {
		return repositorio.findByCategoriaId(categoriaId);
	}
	
	public Producto findById(Long id) {
		return repositorio.findById(id).orElse(null);
	}
	
	public Producto save(Producto producto) {
		return repositorio.save(producto);
	}
	
	public Producto delete(Producto producto) {
		Producto result = findById(producto.getId());
		repositorio.delete(result);
		return result;
	}
	
	public int numeroProductosCategoria(Categoria categoria) {
		return repositorio.findNumProductosByCategoria(categoria);
	}
	
	
	/*
	 * Este método sirve para obtener un número de productos aleatorios y así, cada vez que se recargue la página aparcerán 
	 * distintos productos inicialmente.
	 * Lo realizamos en Java para abstraernos mejor de la base de datos concreta que vamos a usar.
	 * Algunos SGBDR nos permitirían usar la función RANDOM, y podríamos hacer esta consulta de forma nativa
	 * en la base de datos.
	 * Hay que pasarle el número de productos aleatorios que se quiere, se pude ver 
	 * que se le pasa en el MainController como una variable static y constante, por comodidad
	 */
	public List<Producto> obtenerProductosAleatorios(int numero) {
		// Obtenemos los ids de todos los productos usando el método obtenerIds del repositorio de producto
		List<Long> listaIds = repositorio.obtenerIds();
		// Los desordenamos con el método "barajar-desordenar" de la clase Colletions
		Collections.shuffle(listaIds);
		// Nos quedamos con los N primeros, con N = número dado al método por si se quiere cambiar 
		//dicho número de productos aleatorios usando stream
		
		//De nuevo para este proceso usamos un Stream con los id:	listaIds.stream()
		//De todos ellos nos quedamos con unos cuantos, los especificados por la variable "numero": 	limit(numero)
		//Recogemos estos en una List: collect(Collectors.toList()
		
		listaIds = listaIds.stream().limit(numero).collect(Collectors.toList());
		// Buscamos los productos con esos IDs y devolvemos la lista
		return repositorio.findAllById(listaIds);

	}
	

}
