-- Two environments, two databases, same table shape — lets the Parameter Contexts
-- exercise prove which database a promoted flow actually queried by content, not just
-- by which parameter it *should* have used. Applied by hand (docker-entrypoint-initdb.d
-- scripts only run on first container creation).

-- In sourcedb (the "dev" environment):
CREATE TABLE IF NOT EXISTS status_check (
    environment VARCHAR(50),
    checked_at  TIMESTAMP DEFAULT now()
);
INSERT INTO status_check (environment) VALUES ('dev');

-- In a separate database representing "staging":
--   docker exec nifi-postgres psql -U nifi -d sourcedb -c "CREATE DATABASE staging_db;"
--   docker exec nifi-postgres psql -U nifi -d staging_db -c "<same CREATE TABLE above>"
--   docker exec nifi-postgres psql -U nifi -d staging_db -c "INSERT INTO status_check (environment) VALUES ('staging');"
