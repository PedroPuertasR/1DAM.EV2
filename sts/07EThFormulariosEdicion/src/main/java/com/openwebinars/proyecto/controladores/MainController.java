package com.openwebinars.proyecto.controladores;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.openwebinars.proyecto.modelo.Producto;
import com.openwebinars.proyecto.servicios.CategoriaService;
import com.openwebinars.proyecto.servicios.ProductoService;

@Controller
public class MainController {
	
	private static final int NUM_PRODUCTOS_ALEATORIOS = 8;
	
	@Autowired
	private CategoriaService categoriaService;
	
	@Autowired
	private ProductoService productoService;
	
	
	//La finalidad de @RequestParam, es recibir parámetros 
	//desde una ruta de tipo GET, 
	//para trabajar con ellos e incluso poder emitir una respuesta 
	//que dependa de los parámetros que hemos obtenido
	//ya hablamos en los primeros ejemplos de ello
	
	@GetMapping("/")
	public String index(@RequestParam(name="idCategoria", required=false) Long idCategoria, Model model) {		
		
		//Agregamos lista con todas las categorías al modelo
		model.addAttribute("categorias", categoriaService.findAll());
		
		List<Producto> productos;
		
		/*Si la categoría no es nula, obtenemos 8 productos aleatoriamente, 
		 * si es nula obtenemos todos los de 
		 * la categoría con ese id, el llamado idcategoria*/
		if (idCategoria == null) {
			productos = productoService.obtenerProductosAleatorios(NUM_PRODUCTOS_ALEATORIOS);
		} else {			
			productos = productoService.findAllByCategoria(idCategoria);
		}
		
		model.addAttribute("productos", productos);
		
		return "index";
	}
	
	
	/*Método que muestra los detalles de un producto
	 * Atiende a la petición de /product/id del producto sobre el que se ha 
	 * hecho click
	 * Al hacer click sobre el producto, se recoge el id y es el 
	 * que tenemos en la ruta de getMapping
	 * se pasa el método mediante @PathVariable ("id") Long id*/
	@GetMapping("/product/{id}")
	public String showDetails(@PathVariable("id") Long id, Model model) {
		
		//Buscamos el producto por id
		Producto p = productoService.findById(id);
		//Si el producto no es null (si existe el producto buscado) se añade al modelo y mostramos la página del detalle detail.html
		//Si no existe, volvemos a la página index que vuelve a realizar todo lo que hace el método index
		if (p != null) {
			model.addAttribute("producto", p);
			return "detail";
		}
		
		return "redirect:/";
		
	}
	
	
	

}
