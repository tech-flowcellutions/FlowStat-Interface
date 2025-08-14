create or replace function
get_user_id( exp_sens_id numeric )
returns table(
  user_id uuid
)
security invoker
immutable
set search_path = ''
as
$$
/*
returns user_id associated with given exp_sens_id
*/

begin


return query

SELECT E.user_id
FROM public."Experiments" E
WHERE ((E.id)::numeric = div(exp_sens_id, (1000)::numeric))
;


end;
$$
language plpgsql
