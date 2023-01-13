
SELECT 
	j_id_jugador, 
	j_id_equipo, j_equipo, j_nombre, 
	j_fecha_nacimiento, 
	LEFT(j_edad,2)			AS j_edad,
	'Juvenil'				as j_categoria,	
	j_numero, j_posicion, 
	j_altura, j_peso, j_imc
FROM public._jugadores
WHERE j_edad in ('16', '17','18','19','20','23')

UNION

SELECT 
	j_id_jugador, 
	j_id_equipo, j_equipo, j_nombre, 
	j_fecha_nacimiento, 
	LEFT(j_edad,2)			AS j_edad,
	'Adulto'				as j_categoria,	
	j_numero, j_posicion, 
	j_altura, j_peso, j_imc
FROM public._jugadores
WHERE j_edad in ('24', '25','26','27','28','29')