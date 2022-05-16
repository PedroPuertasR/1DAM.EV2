	package com.openwebinars.proyecto.controladores;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.openwebinars.proyecto.modelo.Categoria;
import com.openwebinars.proyecto.servicios.CategoriaService;
import com.openwebinars.proyecto.servicios.ProductoService;

/**Esta clase está anotada con @RequestMapping, que significa que todas 
 * las peticiones que atienda, tendrán la ruta
 * /admin/categoria/lo que sea. Con esto, en los getMapping o PostMapping 
 * de los métodos no tenemos que escribir
 * de nuevo toda parte común, admin/categoria sino que solo escribimos 
 * la parte que irá después de eso, por ejemplo, 
 * si en el método nuevaCategoria vemos que en el 
 * getMapping aparece "/nueva" significa que la petición (en el navegador)
 * debe estar escrito como "admin/categoria/nueva"
 * */

@Controller
@RequestMapping("/admin/categoria")
public class CategoriaController {
	
	/**
	 * Inyectamos (es decir, Spring nos pondrá aquí un objeto de este tipo 
	 * cuando "haga falta" los dos objetos necesarios para trabajar 
	 * en los controladores y acceder a la Base de Datos
	 * El CategoriaService para llamar, por ejemplo, 
	 * a findAll () dentro del método index, porque necesitamos
	 * al entrar en la app listar todas las categorías en el menú lateral izquierdo.
	 * */
	
	@Autowired
	private CategoriaService categoriaService;
	
	@Autowired
	private ProductoService productoService;
		
	/**Método que nos atiende la petición (sin escribir nada en el navegador) 
	 * de la página inicial
	 * Para pintar esa página "dinámicamente" necesitamos las 
	 * categorías para ponerlas en el menú lateral, 
	 * por lo que añadimos al modelo
	 * la lista de categorías que previamente buscamos con 
	 * finAll () (y a la cual le damos el nombre de 
	 * categorias (en plural) que será el nombre que 
	 * debemos usar en la planfilla html par acceder a ella)
	 * Estos datos se necesitarán en la plantilla que vamos a pintar, 
	 * por eso se pasan al model con addAttribute como siempre
	 * Al traer la lista, devolvemos la plantilla que se debe usar 
	 * list-categoria, pero como no está directamente dentro 
	 * de la carpeta templates
	 * sino que está dentro de una subcarpeta llamada admin, 
	 * debemos escribir eso en la ruta del return y por eso, 
	 * escribirmos admin/list-categoria
	 * */
	
	@GetMapping("/")
	public String index(Model model) {
		
		model.addAttribute("categorias", categoriaService.findAll());
		return "admin/list-categoria";
	}
	
	/**Añadir una nueva categoría, usará un formulario por lo que, 
	 * como todos los formularios necesitará dos métodos: 
	 * Uno para atender la petición get (mostrar el formulario en blanco) 
	 * y otro para post (recoger los datos de los campos y procesar esa información)
	 * En este caso, el primer método se llama 
	 * nuevaCategoria y el segundo submitNuevaCategoria.
	 * El primero:
	 * Atiende a peticiones /admin/categoria/nueva como se explica al principio
	 * Esto sucederá cuando dentro del menú categorias 
	 * pinchemos en el botón nueva categoría, si te fijas en el 
	 * código de la plantilla list-categoria
	 * 
	 * 				<div class="pull-right">
					<a href="form-categoria.html" th:href="@{/admin/categoria/nueva/}"
						class="btn btn-primary">Nueva categoría</a>

				</div>
		Puedes ver que el href del botón nueva categoría 
		nos lleva a este controlador, en el que simplemente, 
		se añade al modelo una nueva
		categoría (vacía porque es un formulario de "alta" 
		de una categoría y se lleva a la plantilla html del formulario para categorías
		que aparecerá sin datos en sus campos) 
	 * */
	@GetMapping("/nueva")
	public String nuevaCategoria(Model model) {
		model.addAttribute("categoria", new Categoria());
		return "admin/form-categoria";
	}
	
	/**Este segundo método ha "recogido" un parámetro del formulario, 
	 * en este caso, una categoría (formada por todos los campos del form). 
	 * Pueden ser menos campos de los que tiene la entidad 
	 * Categoría pero no más, para hacerlo con más debemos crear otra 
	 * clase diferente (se verá en otro ejemplo)
	 * 
	 * Añadirmos ese parámetro con @ModelAttribute 
	 * (lo estamos llamando categoria y es de tipo Categoria), con esto
	 * estamos diciendo que tenemos disponible en el método 
	 * el objeto categoría recogido en la plantilla.
	 * Es "como" pasar el objeto categoría recogida en el form 
	 * al método que la va a guardar.
	 * 
	 * Dentro del método, hacemos que el método save 
	 * guarde la nueva categoría recogida y "formada" con los parámetros 
	 * del formulario de categorías (esa categoría de 
	 * la que hemos hablado en el párrafo anterior
	 * y redirigimos al controlador admin/categoria/ (método index). 
	 * ¿Qué significa esto?:
	 * 
	 * Al crear una nueva categoría, queremos que se vuelva 
	 * al listado de categorías de donde partimos, pero que aparezca la nueva 
	 * categoría que acabamos de añadir, por lo tanto, 
	 * si en el return solo ponemos el html no aparecerá la 
	 * lista "actualizada". Debemos ir
	 * primero al controlador que muestra la lista de 
	 * categorías (en nuestro caso el método index de esta misma clase) que
	 * busca todas las categorías y las pinta.
	 * Devolver a un controller en lugar de a una página html, 
	 * se hace poniendo entre las comillas del return
	 * la palabra redirect: y la ruta del controller 
	 * al que queremos redirigir
	 * */
	
	@PostMapping("/nueva/submit")
	public String submitNuevaCategoria(@ModelAttribute("categoria") Categoria categoria, Model model) {
		
		categoriaService.save(categoria);
		
		//En el redirect hay que poner la ruta completa del controller al que queremos ir, 
		//incluyendo lo escrito dentro del @RequestMapping del comienzo de la clase
		return "redirect:/admin/categoria/";
	}
	
	/**Método que atiende a la petición de editar una categoría, 
	 * en esta caso, cuando el usuario pulse el botón de editar 
	 * Mira el código en el archivo html list-categoria:
	 * 
	 * <a href="#" th:href="@{/admin/categoria/editar/{id}(id=${categoria.id})}" class="btn btn-primary">Editar</a>
	 * 
	 * Si te fijas, el th:href al pulsar editar, 
	 * nos lleva a la ruta /admin/categoria (con esto ya estamos en esta clase)/
	 * editar (con eso vamos al método justo que 
	 * tenemos debajo llamado editarCategoria/{id}(id=${categoria.id}) y vamos a
	 * pasar el valor del id de la categoría 
	 * pinchada/elegida para editar.
	 * 
	 * Significa que al estar pinchando en el botón de una determinada categoría 
	 * para editar esa y no otra, necesitamos "recoger" 
	 * el id de la categoría en la que estamos pinchando el botón de editar. Ese id es recogido 
	 * al pinchar por este botón y puesto en esta ruta del th:href
	 * 
	 * Ese id es el que estamos poniendo en el siguiente 
	 * GetMapping @GetMapping("/editar/{id}") delante del método editarCategoria y
	 * pasando junto con el modelo mediante la 
	 * anotación @PathVariable dentro de los parámteros de método. 
	 * Ese parámetro que pasamos lo llamaremos "id"
	 * y es del tipo Long
	 * 
	 * Dentro del método, buscamos esa categoría por su id y, 
	 * si es distinta de null añadimos la categoría al modelo y 
	 * en el return llevamos a mostrar 
	 * el formulario de la categoría (admin/form-categoria) 
	 * pero aparecerá ahora ya con datos en los campos.
	 * Si la categoría buscada es null (no la hemos encontrado) 
	 * llevamos en el return a través del redirect, al método 
	 * controller que pinta la lista
	 * de categorías de nuevo, es decir, al index para que las pinte de nuevo
	 * 
	 * */
	
	@GetMapping("/editar/{id}")
	public String editarCategoria(@PathVariable("id") Long id, Model model) {
		
		Categoria categoria = categoriaService.findById(id);
		
		
		/*Si te fijas en el método nuevaCategoría, al model le pasamos una new categoria ( ) vacía porque es el de agregar nueva categoría.
		 * Ahora pasamos la categoría que nos devuelve el método findById (id) que está justo encima de este comentario, por lo que, el 
		 * formulario ya se pinta con los datos de esta categoría buscada*/
		if (categoria != null) {
			model.addAttribute("categoria", categoria);
			return "admin/form-categoria";
		} else {
			return "redirect:/admin/categoria/";
		}
		
	}
	
	
	/**Para el borrado de categorías, el uso del id funciona de 
	 * la misma manera, se recoge al pinchar en el botón borrar y se pasa en 
	 * @PathVariable
	 * Buscamos la categoría y, si la encontramos (es distinta de null), 
	 * comprobamos que no tenga productos (si tiene productos no 
	 * sería buena idea borrarla
	 * porque ¿en qué categoría quedarían dichos productos? 
	 * En ese caso, devolveríamos una página muy sencilla de error 
	 * (vosotros no tenéis que hacerlo)
	 * y si no tiene productos asociados, 
	 * se borra la categoría con delete.
	 * 
	 * Para ver el número de productos que tiene una categoría, 
	 * usamos un método del 
	 * servicio de producto, que a su vez usa del 
	 * repositorio repositorio.findNumProductosByCategoria(categoria);
	 * anotado con una Query
	 * */
	@GetMapping("/borrar/{id}")
	public String borrarCategoria(@PathVariable("id") Long id, Model model) {
		
		Categoria categoria = categoriaService.findById(id);
		
		if (categoria != null) {
			
			if (productoService.numeroProductosCategoria(categoria) == 0) {
				categoriaService.delete(categoria);				
			} else {
				
			//Se ha agregado el parámetro error con valor true a la ruta	
				return "redirect:/admin/categoria/?error=true";
			}
			
		} 

		return "redirect:/admin/categoria/";
		
		
	}
			
	

}
