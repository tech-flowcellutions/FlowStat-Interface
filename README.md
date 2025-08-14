# FlowStat-Interface
Interface between sensor, database, and dashboard

## 0. Install Docker
[https://www.docker.com/get-started/](Download Docker Desktop)

## FlowStat_Docker
Uses online database

## 1. Git Clone Dashboard/Interface
    cd FlowStat_Docker
    git clone https://github.com/tech-flowcellutions/Dashboard.git
    git clone https://github.com/tech-flowcellutions/Interface.git

## 2. Start Docker
    docker compose up --build -d

## Supabase_Docker
Uses local database

## 1. Git Clone Supabase
    cd Supabase_Docker
    mkdir _Supabase
    git clone --depth 1 https://github.com/supabase/supabase _Supabase
[~ 5-10 mins]

## 2. Start Docker
    cp .env _Supabase/docker
    cp docker-compose.yml _Supabse/docker
    docker compose up --build -d
(may have to run multiple times due to failed connections, but caches progress)
[~ 15 mins on first run]

