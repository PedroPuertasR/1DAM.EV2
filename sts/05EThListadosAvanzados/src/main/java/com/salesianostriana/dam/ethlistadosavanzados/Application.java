package com.salesianostriana.dam.ethlistadosavanzados;

import java.util.List;
import java.util.Random;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.salesianostriana.dam.ethlistadosavanzados.modelo.Producto;
import com.salesianostriana.dam.ethlistadosavanzados.modelo.Puntuacion;
import com.salesianostriana.dam.ethlistadosavanzados.repositorios.ProductoRepository;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
	
	/**
	 * Como ya habéis visto en las clases de Luismi, este método, que se ejecutará al iniciar el proyecto nos servirá de soporte
	 * para que todos los productos de nuestro sistema tengan una puntuación
	 * (más o menos) aleatoria, simulando el que haya sido puntuado por cientos
	 * de usuarios durante varios meses.
	 * 
	 * 
	 * @param productoRepository Repositorio de productos
	 * @return Una instancia de CommandLineRunner, que será ejecutada al iniciar el proyecto
	 */
	
	@Bean
	public CommandLineRunner initData(ProductoRepository productoRepository) {

		return args -> {

			// Rescatamos todos los productos
			List<Producto> productos = productoRepository.findAll();
			
			Random r = new Random();

			// Para cada uno de ellos, está hecho con números en el código por comodidad
			//ya que es código solo para que se vea todo bien, estos cálculos se deben hacer
			//contando las pulsaciones de usuarios en los productos, etc.
			for (Producto p : productos) {
				// Vamos a añadirle un número aleatorio de puntuaciones, entre 1 y 10
				for (int i = 0; i < r.nextInt(10); i++)
					// Lo valoramos con una puntuación aleatoria, entre 3 y 5.
					p.addPuntuacion(new Puntuacion(3 + r.nextInt(2)));
			}

			// Actualizamos los productos, almacenando así su puntuación
			productoRepository.saveAll(productos);

		};

	}

}
