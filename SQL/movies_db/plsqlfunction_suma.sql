CREATE OR REPLACE FUNCTION suma(numeric,numeric) 
RETURNS numeric
AS $$
DECLARE
	a numeric;
	b numeric;
	res numeric;
BEGIN
	a := $1; -- se refiere al 1er parámetro de la función suma
	b := $2; -- se refiere al 2do parametro de la funcion suma
	res := a + b;
	return res;
END;
$$ 
language 'plpgsql';

