package com.salesianostriana.dam.holamundodos;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class Controlador {

	@GetMapping ({"/", "welcome"})
	public String welcome (@RequestParam(name="nombre", required=false, defaultValue= "Mundo") String
	nombre, Model model) {
		
		model.addAttribute("nombre", nombre);
		return "index";
	}

	@GetMapping ("/saludo2")
	public String welcome2 (Model model) {
		
		model.addAttribute("persona", new Persona ("Ángel", "Naranjo González"));
		return "SaludoPersonalizado";
	}
	
	@GetMapping("/saludo3")
	public String welcome3 (Model model){
		
		model.addAttribute("saludo", "Hola Mundo!!!");
		model.addAttribute("mensaje","Me llena de orgullo y satisfacción...");
		model.addAttribute("url", "https://triana.salesianos.edu");
		
		return "SaludoYEnlace";
	}
	
}
