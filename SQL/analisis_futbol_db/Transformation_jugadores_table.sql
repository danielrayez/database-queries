--command " "\\
DROP TABLE IF EXISTS public.jugadores_tmp;

CREATE TABLE jugadores_tmp
			(id_jugador TEXT,  equipo TEXT, 
			 nombre TEXT, fecha_nacimiento TEXT, 
			 edad TEXT, nacionalidad TEXT, 
			 numero TEXT, posicion TEXT, 
			 altura TEXT, peso TEXT);

COPY public.jugadores_tmp (id_jugador, equipo, nombre, fecha_nacimiento, edad, nacionalidad, numero, posicion, altura, peso) 
FROM 'C:\Users\Public\plantillas-ligas-jugadores2022-2.txt' 
DELIMITER E'\t' 
ENCODING 'LATIN9';

-- SELECT * FROM jugadores_tmp

--borro primer registro. contiene los nombres de las columnas

DELETE FROM jugadores_tmp
WHERE id_jugador = 'id_jugador';

-- cambio tipo de datos en columnas edad, altura, peso: de texto a numerico

ALTER TABLE jugadores_tmp
ALTER COLUMN altura SET DATA TYPE numeric
USING altura::numeric;

ALTER TABLE jugadores_tmp
ALTER COLUMN peso SET DATA TYPE numeric
USING peso::numeric;


-- SELECT * FROM jugadores_tmp

--- extraigo los 2 primeros caracteres de la columna de texto edad

SELECT edad, left(edad,2)
FROM jugadores_tmp;

UPDATE jugadores_tmp
SET edad = left(edad,2);

DELETE FROM jugadores_tmp
WHERE edad = '';

ALTER TABLE jugadores_tmp
ALTER COLUMN edad SET DATA TYPE integer
USING edad::integer;

-- elimino id_jugador duplicados
-- SELECT DISTINCT(id_jugador)
-- FROM jugadores_tmp

CREATE TABLE jugadores_tmp1 AS
SELECT 
	DISTINCT ON(id_jugador)
	id_jugador, 
	equipo, 
	nombre, 
	fecha_nacimiento, 
	edad, 
	nacionalidad, 
	numero, 
	posicion, 
	altura, 
	peso
	FROM jugadores_tmp;
DROP TABLE jugadores_tmp;
-- creo la columna calculada Indice de Masa Corporal (Imc)

-- SELECT 
-- 	id_jugador, 
-- 	equipo, 
-- 	nombre, 
-- 	fecha_nacimiento, 
-- 	edad,
-- 	nacionalidad, 
-- 	numero, 
-- 	posicion, 
-- 	altura,
-- 	peso,
-- 	ROUND((peso/((altura/100)*(altura/100))),1) as Imc
-- FROM jugadores_tmp1;

ALTER TABLE jugadores_tmp1
ADD COLUMN  Imc Numeric;

UPDATE jugadores_tmp1
SET Imc = ROUND((peso/((altura/100)*(altura/100))),1);

-- SELECT * FROM jugadores_tmp1

-- creo la columan Clasificacion por imc

-- SELECT id_jugador, imc,
-- CASE  
-- WHEN imc < 18.5 THEN 'Bajo Peso'
-- WHEN imc > 18.5 AND IMC < 25 THEN 'Peso Normal'
-- ELSE 'Sobre Peso'
-- END AS Clasificacion
-- FROM jugadores_tmp1
-- ORDER BY imc Desc;

ALTER TABLE jugadores_tmp1
ADD COLUMN clasificacion VARCHAR(50);

UPDATE jugadores_tmp1
SET clasificacion =
				CASE  
				WHEN imc < 18.5 THEN 'Bajo Peso'
				WHEN imc > 18.5 AND IMC < 25 THEN 'Peso Normal'
				ELSE 'Sobre Peso'
				END;

-- creo una columna Categoria

-- SELECT 	
-- 	edad,
-- 	CASE WHEN edad <= 23 THEN 'Juvenil'
-- 	WHEN edad > 23 THEN 'Mayor'
-- 	ELSE 'Otro'
-- 	END AS Categoria
-- FROM jugadores_tmp1;

ALTER TABLE jugadores_tmp1
ADD COLUMN categoria VARCHAR(25);

UPDATE jugadores_tmp1
SET categoria = 
	CASE WHEN edad <= 23 THEN 'Juvenil'
	WHEN edad > 23 THEN 'Mayor'
	ELSE 'Otro'
	END;
	
-- la tabla jugadores_tmp1 es una tabla de hechos que debe tener 
-- las llaves primarias de _regiones y _equipos.

CREATE TABLE jugadores_tmp2 AS 
SELECT DISTINCT ON (id_jugador)
	id_jugador, equipo, 
	nombre, fecha_nacimiento, 
	edad, nacionalidad, 
	numero, posicion, 
	altura, peso, 
	imc, clasificacion, 
	categoria, r.r_id_pais_nacionalidad,
	e.e_id_equipo
FROM public.jugadores_tmp1 j
	LEFT JOIN _regiones r 	ON j.nacionalidad = r.r_cod_pais
	LEFT JOIN _equipos e	ON j.equipo = e.e_nombre_equipo;

DROP TABLE jugadores_tmp1;

-- 
CREATE TABLE jugadores_tmp3 AS
SELECT 
id_jugador							as j_id_jugador, 
equipo								as j_equipo	, 
nombre								as j_nombre, 
fecha_nacimiento					as j_fecha_nacimiento, 
edad								as j_edad, 
nacionalidad						as j_nacionalidad, 
numero								as j_numero, 
posicion							as j_posicion, 
altura								as j_altura, 
peso								as j_peso, 
imc									as j_imc, 
clasificacion						as j_clasificacion, 
categoria							as j_, 
r_id_pais_nacionalidad				as j_id_pais, 
e_id_equipo							as j_id_equipo
FROM public.jugadores_tmp2;
DROP TABLE jugadores_tmp2;	
	
DROP TABLE IF EXISTS public._jugadores;

ALTER TABLE jugadores_tmp3
	ADD CONSTRAINT jugadores_tmp1_fk_regiones
	FOREIGN KEY (j_id_pais)
	REFERENCES _regiones(r_id_pais_nacionalidad);

ALTER TABLE jugadores_tmp3
	ADD CONSTRAINT jugadores_tmp1_fk_equipos
	FOREIGN KEY (j_id_equipo)
	REFERENCES _equipos(e_id_equipo);

ALTER TABLE jugadores_tmp3
	ADD CONSTRAINT jugadores_pk
	PRIMARY KEY (j_id_jugador);


ALTER TABLE jugadores_tmp3 RENAME TO _jugadores

