create or replace function
get_pstat_data( exp_sens_id int4, time_ms_start int8 =null, time_ms_end int8 =null )
returns table(
  time_ms int8, voltage float4, current_density float4
)
security invoker
stable
set search_path = ''
set statement_timeout to '2min'
as
$$
/*
return table with rows corresponding to datapoints
convert current into current_density (based on sensor area)
*/

declare
  _exp_sens_id int4 := exp_sens_id;
  _time_start int8 := coalesce(time_ms_start, -1);
  _time_end   int8 := coalesce(time_ms_end, 1e18);
  _area_cm2 float4;

begin


select
  -- density conversion [A -> mA/cm2]
  (1e3/ S.area_cm2)
from public."Sensors" S
join public."Experiments" E on
  E.id = div(_exp_sens_id, 1000)
where
  (E.info->'sensor_id')::int4 = S.id
into _area_cm2;


return query

select
  PD.time_ms,
  PD.voltage,
  (PD.current *_area_cm2)
from public."Potentiostat_Data" PD
where
  PD.exp_sens_id = _exp_sens_id
  and
  -- constrain datapoints within [start, end] (inclusive)
  PD.time_ms between _time_start and _time_end
order by PD.time_ms
;


end;
$$
language plpgsql
