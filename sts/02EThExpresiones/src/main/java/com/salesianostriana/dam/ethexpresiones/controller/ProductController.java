package com.salesianostriana.dam.ethexpresiones.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.salesianostriana.dam.ethexpresiones.model.Product;


//Anotamos con controller
@Controller
public class ProductController {

	
	//Anotamos con el tipo de petición que atenderá este método, tipo get ("sin datos"), cuando se escriba en el navegador la ruta
	// barra productos (después de localhost....
	@GetMapping ("/productos")
	public String controladorCondicionales (Model model){
		//Para simplificar el ejemplo, se ha instanciado la lista y se han agregado
		//algunos productos directamente dentro del método pero esto nunca se hace, solo es para el ejemplo
		//Poco a poco veremos que el uso de servicios y repositorios traerán los datos de la base de datos
		//en lugar de crear la lista de productos aquí
		
		List<Product> lista = new ArrayList<Product>();
		
		lista.add(new Product (1, "Botijo", "Enfría agua hasta menos 10 grados", 20.5055, true, Calendar.getInstance()) );
		lista.add(new Product (1, "BotijoExtra", "Enfría agua hasta menos 200 grados", 200.50, true, Calendar.getInstance()) );
		
		//Añadimos la lista al model con el nombre "productList" y será el usado en la plantilla HTML para acceder
		//a los datos que se han agregado al modelo (lista)
		model.addAttribute("productList", lista  );
		return "PlantillaBucleYFormateo";//Se devuelve la plantilla en HTML
	}
}
