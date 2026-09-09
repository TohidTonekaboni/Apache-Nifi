#!/bin/bash
# Downloads the PostgreSQL JDBC driver used by the DBCPConnectionPool controller service
# in this section's exercise. The jar itself is gitignored (binary, easily re-fetched).
set -euo pipefail
cd "$(dirname "$0")"
curl -sL -o postgresql-42.7.4.jar https://jdbc.postgresql.org/download/postgresql-42.7.4.jar
echo "Downloaded $(pwd)/postgresql-42.7.4.jar"
