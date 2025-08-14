-- get sweep stats
create or replace function
get_sweep_stats( exp_sens_id int4, time_ms_first int8 =null, time_ms_last int8 =null )
returns table(
  time_ms_start int8, time_ms_end int8, cd_mag float4, open_v float4, time_ms int8
)
security invoker
stable
set search_path = ''
set statement_timeout to '2min'
as
$$
/*
return table with rows corresponding to sweep stats
*/

declare
  _exp_sens_id int4 := exp_sens_id;


begin

return query
with

-- get ranges as rows of: [sweep_start, sweep_end]
SR as
(
  select * from public.get_sweep_ranges(_exp_sens_id, time_ms_first, time_ms_last)
),

-- join with PD so that each datapoint includes its corresponding sweep-index
J as
(
  select
    SR.time_ms_start  as sweep_id,
    PD.current
  from SR
  join public."Potentiostat_Data" PD on
    PD.time_ms between SR.time_ms_start and SR.time_ms_end
  where
    PD.exp_sens_id = _exp_sens_id
),

-- find minimal current per sweep
M0 as
(
select distinct on (J.sweep_id)
  J.*
from J
order by
  J.sweep_id,
  J.current  asc
),
-- find maximal current per sweep
M1 as
(
select distinct on (J.sweep_id)
  J.*
from J
order by
  J.sweep_id,
  J.current  desc
),
-- compute current magnitude
CDM as
(
select
  M0.sweep_id,
  (M1.current - M0.current)  as cd_mag
from M0
join M1 on
  M0.sweep_id = M1.sweep_id
),

-- find row with min-abs-current
MAV as
(
select distinct on (SR.time_ms_start)
  SR.time_ms_start  as sweep_id,
  PD.time_ms,
  PD.voltage
from public."Potentiostat_Data" PD
join SR on
    PD.time_ms between SR.time_ms_start and SR.time_ms_end
where
    PD.exp_sens_id = _exp_sens_id
order by
  SR.time_ms_start,
  abs(PD.current),
  PD.time_ms
)


select
  SR.time_ms_start,
  SR.time_ms_end,
  CDM.cd_mag,
  MAV.voltage,
  MAV.time_ms
from SR
join MAV on
    MAV.sweep_id = SR.time_ms_start
join CDM on
    CDM.sweep_id = SR.time_ms_start
order by
  SR.time_ms_start
;


end;
$$
language plpgsql
