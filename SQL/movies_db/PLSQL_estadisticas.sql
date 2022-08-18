-- FUNCTION: public.peliculas_stats()

-- DROP FUNCTION public.peliculas_stats();

CREATE OR REPLACE FUNCTION public.peliculas_stats(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	total_peliculas REAL := 0.0;
	tiempo_prom_renta REAL := 0.0;
	precio_prom_renta REAL := 0.0;
	costo_prom_reemplazo REAL := 0.0;
	peliculas_larger_100 REAL := 0.0;
	peliculas_less_100 REAL := 0.0;
BEGIN
	total_peliculas = COUNT(*) FROM peliculas;
	tiempo_prom_renta := AVG(duracion_renta) FROM peliculas;
	precio_prom_renta := AVG(precio_renta) FROM peliculas;
	costo_prom_reemplazo := AVG(costo_reemplazo) FROM peliculas;
	peliculas_larger_100  := COUNT(*) FROM peliculas WHERE duracion > 100;
	peliculas_less_100 := COUNT(*) FROM peliculas WHERE duracion < 100;
	
	TRUNCATE TABLE peliculas_estadisticas;
	
	INSERT INTO peliculas_estadisticas(estadistica,valor_estadistica)
	VALUES 
	('total_peliculas', total_peliculas),
	('tiempo promedio de renta', tiempo_prom_renta),
	('precio promedio de renta', precio_prom_renta),
	('costo promedio reemplazo',costo_prom_reemplazo),
	('peliculas que duran mas de 100 min', peliculas_larger_100),
	('peliculas que duran menos de 100 min', peliculas_less_100);
END 
$BODY$;

ALTER FUNCTION public.peliculas_stats()
    OWNER TO postgres;
