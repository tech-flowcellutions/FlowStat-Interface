create or replace function
add_datapoint( exp_uuid text, sensor int2, current float4, voltage float4, time_ms int8 )
returns void
security definer
set search_path = ''
as
$$
/*
add datapoint to table
this function is called by database-user via 'secret' exp_uuid
*/

declare
  exp_sens_id int4;


begin

select (E.id *1000 + sensor) into exp_sens_id
from public."Experiments" E
where
  E.uuid = exp_uuid::uuid
;


insert into public."Potentiostat_Data"
values (
  exp_sens_id,
  current,
  voltage,
  time_ms
)
;


end;
$$
language plpgsql
