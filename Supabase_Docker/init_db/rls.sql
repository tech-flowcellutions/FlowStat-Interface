
-- Experiments RLS

create policy "'Insert' E based on user_id"
on public."Experiments"
to authenticated
with check ((
  SELECT (auth.uid() = "Experiments".user_id)
));

create policy "'Select' E based on user_id"
on public."Experiments"
to authenticated
using ((
  (SELECT auth.uid() AS uid) = user_id
));


-- Potentiostat_Data RLS

create policy "'Insert' PD based on E.user_id"
on public."Potentiostat_Data"
to authenticated
with check ((
  (SELECT auth.uid() AS uid) = (
    SELECT E.user_id
    FROM "Experiments" E
    WHERE ((E.id)::numeric = div(("Potentiostat_Data".exp_sens_id)::numeric, (1000)::numeric))
  )
));

create policy "'Select' PD based on E.user_id"
on public."Potentiostat_Data"
to authenticated
using ((
  (SELECT auth.uid() AS uid) = (
    SELECT E.user_id
    FROM "Experiments" E
    WHERE ((E.id)::numeric = div(("Potentiostat_Data".exp_sens_id)::numeric, (1000)::numeric))
  )
));


-- Sensors (all authenticated users)

create policy "'Select' permission for authenticated users"
on public."Sensors"
to authenticated
using ( true );


-- Sweep Stats

create policy "'Insert' based on E.user_id"
on public."Sweep_Stats"
to authenticated
with check ((
  (SELECT auth.uid() AS uid) = (
    SELECT E.user_id
    FROM "Experiments" E
    WHERE ((E.id)::numeric = div(("Sweep_Stats".exp_sens_id)::numeric, (1000)::numeric))
  )
));

create policy "'Select' based on E.user_id"
on public."Sweep_Stats"
to authenticated
using ((
  (SELECT auth.uid() AS uid) = (
    SELECT E.user_id
    FROM "Experiments" E
    WHERE ((E.id)::numeric = div(("Sweep_Stats".exp_sens_id)::numeric, (1000)::numeric))
  )
));
