-- Ejercicio 1

SELECT ROUND(AVG(racha_viento),2)
FROM climatologia
WHERE provincia IN ('A coruña', 'Lugo', 'Pontevedra', 'Oursense')
	  AND fecha::text ILIKE ('2019-05%')
	  AND racha_viento > 50;

-- Ejercicio 2

SELECT fecha, estacion, provincia, temperatura_minima, temperatura_maxima,
	   ROUND(((temperatura_minima+temperatura_maxima)/2),2) AS temperatura_media,
	   hora_temperatura_maxima, hora_temperatura_minima, racha_viento,
	   hora_racha_viento, velocidad_maxima_viento, hora_velocidad_maxima_viento,
	   precipitacion_total, precipitacion_0_a_6, precipitacion_6_a_12,
	   precipitacion_12_a_18, precipitacion_18_a_24
FROM climatologia
WHERE (estacion ILIKE ('%á%') 
		OR estacion ILIKE('%é%')
	  	OR estacion ILIKE('%í%') 
	  	OR estacion ILIKE('%ó%') 
	  	OR estacion ILIKE('%ú%'))
	  AND fecha::text ILIKE ('2019-01%');


-- Ejercicio 3

SELECT *
FROM climatologia
WHERE estacion ILIKE ('%ón')
	  AND precipitacion_total BETWEEN 10 AND 20
	  AND fecha::text BETWEEN ('2019-02-01') AND ('2019-03-31')
	  AND temperatura_minima < 10
ORDER BY random();

-- Ejercicio 4

SELECT estacion, provincia, fecha, temperatura_maxima,hora_temperatura_maxima,
	CASE
		WHEN temperatura_maxima > 30 AND temperatura_maxima < 35 THEN 'Caluroso'
		WHEN temperatura_maxima >= 35 AND temperatura_maxima < 38 THEN 'Muy caluroso'
		WHEN temperatura_maxima >= 38 THEN 'Extremadamente caluroso'
	END AS "Mensaje temperatura"
FROM climatologia
WHERE temperatura_maxima > 30
	  AND hora_temperatura_maxima = '17:00'
	  AND fecha::text BETWEEN ('2019-06-01') AND ('2019-07-31')
ORDER BY temperatura_maxima DESC;

-- Ejercicio 5

SELECT provincia, estacion, fecha, velocidad_maxima_viento, racha_viento,
	   ROUND((racha_viento*100/velocidad_maxima_viento-100),2) AS "Porcentaje"
FROM climatologia
WHERE velocidad_maxima_viento >= 60
	  AND ROUND((racha_viento*100/velocidad_maxima_viento-100),2) BETWEEN 20 AND 40
ORDER BY provincia ASC, estacion ASC, fecha DESC;