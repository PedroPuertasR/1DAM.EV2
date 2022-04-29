package com.salesianostriana.dam.operacionesycondiciones;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

/*Creamos un pequeño servicio que nos dé algún producto o listado 
 * como si estuviéramos consultando una base de datos, 
 * que todavía no tenemos*/
@Service
public class DummyService {
	

	public Producto getProducto() {
		return new Producto("Camiseta","¡Wena de verdad!)",15.0f, 87, 91.1f);
	}
	
	public Producto getProductoSinAlgunosValores() {
		return new Producto("Otro producto", null, 1.0f);
	}
	
	public List<Producto> getLista() {
		return Arrays.asList(
				new Producto("Producto 1", "Descripción 1", 1.0f),
				new Producto("Producto 2", "Descripción 2", 2.0f),
				new Producto("Producto 3", "Descripción 3", 3.0f)
				);
		//return null;
	}
	
	
	public Map<String, Producto> getMap() {
		return Collections.singletonMap("p4", new Producto("Producto 4", "Descripción 4", 4.0f));
	}
	
	

}
