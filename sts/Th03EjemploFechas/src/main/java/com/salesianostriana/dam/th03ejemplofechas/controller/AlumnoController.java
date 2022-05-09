package com.salesianostriana.dam.th03ejemplofechas.controller;


import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.salesianostriana.dam.th03ejemplofechas.model.Alumno;
import com.salesianostriana.dam.th03ejemplofechas.servicios.AlumnoServicio;


@Controller
public class AlumnoController {
	
	private AlumnoServicio alumnoServicio;
	
	public AlumnoController(AlumnoServicio servicio) {
		alumnoServicio = servicio;
	}
	
	@GetMapping("/")
	public String index(Model model) {
		model.addAttribute("alumnos", alumnoServicio.findAll());
		return "list";
	}
	
	@GetMapping("/nuevo")
	public String muestraFormulario(Model model) {
		model.addAttribute("alumno", new Alumno());
		return "form";
	}
	
	@PostMapping("/nuevo/submit")
	public String procesaFormulario(@ModelAttribute("alumno") Alumno alumno) {
		alumno.setFechaUltimoAcceso(LocalDateTime.now());
		alumnoServicio.save(alumno);
		
		return "redirect:/";
	}

}
