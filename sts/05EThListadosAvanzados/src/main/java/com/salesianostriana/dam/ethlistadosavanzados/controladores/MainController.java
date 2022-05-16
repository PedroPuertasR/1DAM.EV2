package com.salesianostriana.dam.ethlistadosavanzados.controladores;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.salesianostriana.dam.ethlistadosavanzados.modelo.Producto;
import com.salesianostriana.dam.ethlistadosavanzados.servicios.CategoriaService;
import com.salesianostriana.dam.ethlistadosavanzados.servicios.ProductoService;



@Controller
public class MainController {

	private static final int NUM_PRODUCTOS_ALEATORIOS = 8;

	@Autowired
	private CategoriaService categoriaService;

	@Autowired
	private ProductoService productoService;

	/**
	 * El método index, responde a las peticiones de la ruta solo barra (raiz):
	 * Agregamos todas las categorías al modelo 
	 * (el modelo es "como el lugar en el que metemos las cosas para 
	 * tenerlas disponibles en el contexto en el que estamos, 
	 * es decir, nuestra plantilla al renderizar")
	 * Obtenemos 8 productos aleatorios para mostrar inicialmente y los guardamos
	 * en una lista (List) auxiliar que hemos llamado productos.
	 * Volvemos a meter en el model, esos productos aleatorios 
	 * de la lista auxiliar para poder mostrarlos en el html index.
	 * 
	 * */
	
	@GetMapping("/")
	public String index(Model model) {

		model.addAttribute("categorias", categoriaService.findAll());

		List<Producto> productos;

		productos = productoService.obtenerProductosAleatorios(NUM_PRODUCTOS_ALEATORIOS);

		model.addAttribute("productos", productos);

		return "index";
	}

}