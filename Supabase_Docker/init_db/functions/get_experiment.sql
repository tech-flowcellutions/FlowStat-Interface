create or replace function
get_experiment( exp_uuid text )
returns table(
  params jsonb,
  name text,
  info jsonb,
  sensors text[]
)
security definer
stable
set search_path = ''
set statement_timeout to '2min'
as
$$
/*
return table with row corresponding to specific experiment
this function is called by database-user via 'secret' exp_uuid
*/

begin


return query
select
  E.params,
  E.name,
  E.info,
  E.sensors
from public."Experiments" E
where
  E.uuid = exp_uuid::uuid
;


end;
$$
language plpgsql
