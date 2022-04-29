package com.openwebinars.primerproyecto;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MainController {
	
	/* 2021
	 * Creamos un servicio que nos provea de algunos de los objetos que vamos a utilizar
	 * No echéis cuenta a la anotación de @autowired, ya que como ha comentado Luismi en sus clases
	 * este curso no se usará por estar deprecated
	 * Podéis dejarla así para que el ejemplo funcione ya qu elo importante de este es
	 * que se vea cómo formatear y usar las expresiones de Thymeleaf
	 */
	@Autowired
	private DummyService service;
	
	@GetMapping({"/", "/welcome"})
	public String welcome(@RequestParam(name="nombre", required=false, defaultValue="Mundo") String nombre, Model model) {
		// Funciona igual que en ejemplos anteriores
		model.addAttribute("nombre", nombre);
		// Tomamos la fecha y hora actual del sistema
		model.addAttribute("today", LocalDate.now());
		// Obtenemos desde el servicio la instancia de un producto
		model.addAttribute("producto", service.getProducto());
		// Obtenemos desde el servicio un listado con varios productos
		model.addAttribute("lista", service.getLista());
		// Obtenemos desde el servicio un HashMap con un producto
		model.addAttribute("map", service.getMap());
		
		
		return "index";
	}

}
