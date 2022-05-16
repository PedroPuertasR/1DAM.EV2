package com.salesianostriana.dam.ethlistadosavanzados.servicios;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.salesianostriana.dam.ethlistadosavanzados.modelo.Categoria;
import com.salesianostriana.dam.ethlistadosavanzados.repositorios.CategoriaRepository;

@Service
public class CategoriaService {
	
	//No echéis cuenta al autowired, ya ha explicado Luismi cómo hacerlo este año
	//Incluismos en el servicio, los métodos para buscar destacadas, guardar, borrar...
	//Se han explicado los repositorios y servicios en las clases de Luismi
	@Autowired
	private CategoriaRepository repositorio;
	
	public List<Categoria> findAll() {
		return repositorio.findAll();
	}	
	
	public List<Categoria> findDestacadas() {
		return repositorio.findDestacadas();
	}
	
	public Categoria save(Categoria categoria) {
		return repositorio.save(categoria);
	}
	
	public Categoria findById(Long id) {
		return repositorio.findById(id).orElse(null);
	}
	
	public Categoria delete(Categoria categoria) {
		Categoria result = findById(categoria.getId());
		repositorio.delete(result);
		return result;
	}

}
