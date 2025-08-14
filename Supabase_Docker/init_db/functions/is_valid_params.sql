
create or replace function
is_valid_params( params jsonb )
returns boolean
security invoker
immutable
set search_path = ''
as
$$
/*
returns whether params values are valid
*/

begin


return
(
  (params->'v_min')::float <= (params->'v_max')::float
  and
  (params->'v_rate')::float > 0
  and
  (params->'cycles')::int > 0
)
;


end;
$$
language plpgsql;
