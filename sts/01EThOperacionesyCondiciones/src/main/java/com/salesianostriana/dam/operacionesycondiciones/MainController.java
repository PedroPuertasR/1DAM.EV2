package com.salesianostriana.dam.operacionesycondiciones;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MainController {
	
	/*
	 * Creamos un servicio que nos provea de algunos de los objetos que vamos a utilizar
	 */
	@Autowired
	private DummyService service;
	
	/*La finalidad de @RequestParam, es poder recibir parámetros desde una ruta de tipo GET, 
	 * para trabajar con ellos e incluso poder emitir una respuesta que dependa 
	 * de los parámetros que hemos obtenido
	 * 
	 * En este caso, estamos pasando el parámetro "nombre" (antes del Model) y con la información/detalles que aparecen en 
	 * los paréntesis que van delante, name=nombre, requerido y valor por defecto, si no aparece el parámetro
	 * Mundo)
	 * */
	@GetMapping({"/", "/welcome"})
	public String welcome(@RequestParam(name="nombre", required=false, defaultValue="Mundo") String nombre, Model model) {
		// Funciona igual que en ejemplos anteriores, vamos añadiendo variables y su valor al model mediante 
		//addAttribute (se verá más adelante otras formas de añadir atributos pero esta es válida para casi todo)
		model.addAttribute("nombre", nombre);
		// Tomamos la fecha y hora actual del sistema
		model.addAttribute("today", new Date());
		// Obtenemos desde el servicio la instancia de un producto
		model.addAttribute("producto", service.getProducto());
		// Obtenemos desde el servicio un listado con varios productos
		model.addAttribute("lista", service.getLista());
		// Obtenemos desde el servicio un HashMap con un producto
		model.addAttribute("map", service.getMap());
		// Obtenemos del servicio la instancia de un producto sin alguno de sus valores		
		model.addAttribute("producto2", service.getProductoSinAlgunosValores());
		
		return "index";
	}

}
