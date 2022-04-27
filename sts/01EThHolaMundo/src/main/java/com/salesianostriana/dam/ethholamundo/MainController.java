package com.salesianostriana.dam.ethholamundo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;



/*Necesitamos una clase que separa la vista del modelo, en este caso, un controller que se encarga
 * de atender las peticiones. Los controller:
 * Atienden las peticiones
 * Procesan los datos que llegan de las peticiones
 * Hacen peticiones a la BBDD
 * Definien la información que se verá en la web (modelo)
 * Determinan qué vista será la encargada de generar la pg HTML
 * 
*/

@Controller
public class MainController {


	/*"/ ó /welcome" es la página que queremos mostrar al inicio, el recurso a mostrar y que tendremos que escribir en el navegador después de
	Localhost:9000 o nada o welcome
	@RequestMapping indica que el método justo debajo será el que atenderá la petición tipo Get 
	(cuando solo hay una se supone tipo get, cuando sea Post (formulario) tendremos dos métodos. 
	 * Más adelante veremos que en lugar de usar RequestMapping usaremos GetMapping,pero por si os lo encontráis por el mundo de internet*/
	
	
	@GetMapping ({"/", "welcome"} )
	public String welcome (@RequestParam(name="nombre", required=false, defaultValue= "Mundo") String nombre, Model model) {
		
		//El parámetro "nombre" es la palabra que usamos para darle un nombre a la variable y debemos usar en la plantilla dentro
		// de <p>Hello <span th:text="${nombre}">Friend</span>!</p>
		/*Ojo porque no tener un criterio a la hora de dar estos nombre a las variables hace que tengamos muschos errores (usar mayúsculas o minúsculas, 
		 * que el nombre no indique qué guada, mezclas varias palabras... */
		
		model.addAttribute("nombre", nombre);//Incluimos la información en el modelo
		
		return "index";//Nombre de la plantilla que generará la página HTML (sin extensión), en nuestro caso estos html deben estar
		//dentro de templates y llamarse igual que el String que devuelve el método, index.html Ojo con las máyúsculas y minúsculas del nombre
		//de la plantilla porque son tenidas en cuenta
	}

	
	//Segundo ejemplo, donde se pueden ver distintos parámetros que se le pasan al model, como un objeto de la clase
	//Persona, con valores de sus dos atributos. Más adelante iremos viendo de dónde sacamos esa "información" que cambiar, como aquí la new Persona 
	//creada directamente en el método addAttribute.
	@GetMapping ("/saludo2")
	public String welcome2 (Model model) {
		
		model.addAttribute("persona", new Persona ("Ángel", "Naranjo González"));
		return "SaludoPersonalizado";
	}
	
	/*@GetMapping es una variante de requestMapping, más "nueva" que se utiliza como atajo, ya que 
	 * basta con el nombre del recurso, mientras que con @RequestMapping, en general, tenemos que ir 
	 * diciendo el tipo de petición que se está atendiendo, es decir, 
	 * necesita que le indiquemos el value (nombre el recurso, por ejemplo, /saludo3) y el método que se usa para
	 * la petición, en nuestro caso, tendríamos que escribir 
	 * //@RequestMapping (value="/saludo3", method=RequestMethod.GET) (también existe RequestMethod.POST)
	 * En general, se usa por simplificar el código 
	 * Se puede ver un ejemplo en: https://www.arquitecturajava.com/spring-getmapping-postmapping-etc/*/
	
	
	@GetMapping("/saludo3") 
	
	public String welcome3 (Model model){
		
        model.addAttribute("saludo", "Hola Mundo!!!");
        model.addAttribute("mensaje","Me llena de orgullo y satisfacción...");
        model.addAttribute("url", "https://triana.salesianos.edu");
        return "SaludoYEnlace";
        
	}
	
	
}
