package com.salesianostriana.dam.ethfragmentos.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {
	
	
	//Ruta de inicio, es decir, sin poner nada en el navegador después de localhost:9000/
	@GetMapping("/")
	public String index() {
		return "index";//Mostramos la plantilla index
	}
	
	@GetMapping("/otra") 
	public String otra(Model model){
		model.addAttribute("mensaje", "Este es un mensaje en una cadena de caracteres");
		return "otrapagina";//Mostramos otra página
	}

}