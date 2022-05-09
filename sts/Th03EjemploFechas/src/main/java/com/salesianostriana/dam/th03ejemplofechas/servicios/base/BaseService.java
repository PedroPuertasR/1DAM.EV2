package com.salesianostriana.dam.th03ejemplofechas.servicios.base;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Esta clase base nos permite tener un envoltorio genérico 
 * para cualquier tipo de repositorio que maneje una determinada entidad. 
 * De esta forma, los métodos CRUD más habituales, ya los 
 * tenemos implementados, y solamente necesitaremos implementar por nuestra cuenta 
 * aquellos métodos más complejos de nuestra lógica de negocio.
 * 
 * Esta versión no incluye ningún mecanismo de validación para garantizar 
 * que T sea una entidad
 * 
 * T debe ser el tipo de entidad que se va a gestionar, en nuestro caso será Alumno.
 * ID el tipo de dato de su ID (La clave primaria de T)
 * R Es el tipo de dato del repositorio, en este caso AlumnoRepository.
 * Este tipo de datos se llama "delimitado". ¿Qué significa eso? 
 * Básicamente dice, pásame un R pero este, debe extender JpaRepository <T, ID> obligatoriamente.
 * Significa que R debe ser de un tipo que extienda (herede) a JPARepository <T, ID> por lo que no 
 * puede ser de cualquier tipo que queramos, sino que debe cumplir esta condición, 
 * de ahí el que se le llame delimitado, pues estamos delimitando el tipo de objetos 
 * que se pueden usar a aquellos que cumplan esto.
 * 
 * Una de las limitaciones que tiene es fácilmente subsanable. 
 * Se podría dar el caso de que el tipo T no fuese una entidad de nuestro modelo. 
 * Para solucionarlo, podríamos forzar a que todas nuestras clases modelo implementaran una interfaz, 
 * y utilizar dicha interfaz para delimitar el tipo del parámetro T.
 */
public abstract class BaseService<T, ID, R extends JpaRepository<T, ID>> {

	@Autowired
	protected R repositorio;
	
	/**
	 * Almacenamos una nueva entidad a través del repositorio
	 * @param t
	 * @return 
	 */
	public T save(T t) {
		return repositorio.save(t);
	}
	
	/**
	 * Localizamos una entidad en base a su Id.
	 * 
	 * 
	 * @param id
	 * @return
	 */
	public T findById(ID id) {
		//Devolvemos la entidad si la encuentra u otro si no lo encuentra, 
		//en este caso, hemos dicho que ese "otro" sea null
		return repositorio.findById(id).orElse(null);
	}
	
	/**
	 * Obtenemos todas las entidades de un tipo de entidad
	 * @return
	 */
	public List<T> findAll() {
		return repositorio.findAll();
	}
	
	/**
	 * Editamos una instancia de una entidad (si no tiene Id, la insertamos).
	 * @param t
	 * @return
	 */
	public T edit(T t) {
		return repositorio.save(t);
	}
	
	/**
	 * Eliminamos una instancia de una entidad
	 * @param t
	 */
	public void delete(T t) {
		repositorio.delete(t);
	}
	
	/**
	 * Eliminamos una instancia en base a su ID
	 * @param id
	 */
	public void deleteById(ID id) {
		repositorio.deleteById(id);
	}
	
	
}

