package com.salesianostriana.dam.ethexpresiones.controller;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.salesianostriana.dam.ethexpresiones.model.Customer;


/*Como en el ejemplo, las peticiones de los productos no están relacionadas con las de los clientes
 * creamos una nueva clase controller para los clientes (customer) y la anotamos con @Controller*/

@Controller
public class CustomerController {
	
	//Nuevamente anotamos con el tipo de petición que atenderá este método (get) cuando se escriba la ruta
	//localhost:9000/listGen
	@GetMapping("/listGen")
	public String listarVarios (Model model) {
		
		/*se ha metido aquí la lista para no tener que escribir 
		 * el repositorio, etc. No se hace en el proyecto, solo como ejemplo*/
		
		List<Customer> lista = new ArrayList<Customer>();
		
		lista.add(new Customer("Ángel", "Naranjo", "González", "male", 1));
		lista.add(new Customer ("Luis Miguel", "López", "Magaña", "male", 2));
		lista.add(new Customer ("Novia del Gato", "Doraemon", "No sé", "female", 3));
		lista.add(new Customer ("Corona", "Virus", "A", " ", 3));
		
		//Agregamos la lista al modelo como siempre, ojo al nombre. Debe ser el usado en el html
		
		model.addAttribute("customerList", lista);
		
		return "PlantillaSwitch";
	}
	
}
