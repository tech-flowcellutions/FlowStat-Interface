create or replace function
get_sweep_ranges( exp_sens_id int4, time_ms_first int8 =null, time_ms_last int8 =null )
returns table(
  time_ms_start int8,
  time_ms_end int8
)
security invoker
stable
set search_path = ''
set statement_timeout to '2min'
as
$$
/*
return table with rows corresponding to time-ranges [start, end) of up/downward sweeps
*/

declare
  _exp_sens_id int4 := exp_sens_id;


begin

-- set default vals
select coalesce(time_ms_first, -1) into time_ms_first;
select coalesce(time_ms_last, 1e18) into time_ms_last;


return query
with

-- dV/dt
"dV_dTimeIndex" as
(
  select
    *,
    coalesce(
      voltage - (lag(voltage) over (order by time_ms))
    , 0)
      as dv
  from public."Potentiostat_Data" PD
  where
    PD.exp_sens_id = _exp_sens_id
    and
    -- include first time
    time_ms_first <= PD.time_ms  and  PD.time_ms <= time_ms_last
),

-- cusp rows: where d2V/dTimeIndex2 < 0
"Cusps" as
(
  select
    time_ms,
    dv * (lag(dv) over (order by time_ms)) < 0
      as is_cusp_start
  from "dV_dTimeIndex" DV
  where
    -- exclude first time
    time_ms_first < DV.time_ms  and  DV.time_ms <= time_ms_last
)


select
  (lag(time_ms, 1, time_ms_first) over (order by time_ms))  as time_ms_start,
  (time_ms -1)  as time_ms_end
from "Cusps"
where
  is_cusp_start
;


end;
$$
language plpgsql