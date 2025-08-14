-- get and cache sweep stats
create or replace function
sweep_stats( exp_sens_id int4, time_ms_last int8 =null )
returns table(
  time_ms_start int8, time_ms_end int8, cd_mag float4, open_v float4, time_ms int8
)
security invoker
set search_path = ''
set statement_timeout to '2min'
as
$$
/*
return table with rows corresponding to sweep stats
cache responses
*/

declare
  _exp_sens_id int4 := exp_sens_id;
  _last_update int8;
  _time_first int8;


begin

-- get last update in cached Sweep_Stats
select
  max(SS.time_ms_end)
into _last_update
from public."Sweep_Stats" SS
where
  SS.exp_sens_id = _exp_sens_id
;

-- get time of latest row in PD within corresponding _last_update
select
  max(PD.time_ms)
into _time_first
from public."Potentiostat_Data" PD
where
  PD.exp_sens_id = _exp_sens_id
  and
  PD.time_ms <= _last_update
;


insert into public."Sweep_Stats" (exp_sens_id, time_ms_start, time_ms_end, cd_mag, open_v, time_ms)
select
  _exp_sens_id,
  SS.time_ms_start,
  SS.time_ms_end,
  SS.cd_mag,
  SS.open_v,
  SS.time_ms
from public.get_sweep_stats(_exp_sens_id, _time_first, time_ms_last) SS
;


return query

select
  SS.time_ms_start,
  SS.time_ms_end,
  SS.cd_mag,
  SS.open_v,
  SS.time_ms
from public."Sweep_Stats" SS
where
  SS.exp_sens_id = _exp_sens_id
;


end;
$$
language plpgsql
