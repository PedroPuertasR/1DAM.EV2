-- Temperatura maxima de cada provincia el 9 de diciembre de 2019 mostrando además la estación.

-- MAL

SELECT provincia, estacion, MAX(temperatura_maxima)
FROM climatologia
WHERE TO_CHAR(fecha, 'DD/MM') = '09/12'
GROUP BY provincia, estacion;

-- BIEN

SELECT provincia, estacion, temperatura_maxima
FROM climatologia c1
WHERE TO_CHAR(fecha, 'DD/MM') = '09/12'
	  AND temperatura_maxima >= ALL (SELECT temperatura_maxima
									 FROM climatologia c2
									 WHERE TO_CHAR(fecha, 'DD/MM') = '09/12'
									 	   AND c1.pronvicia = c2.provincia
	  								);