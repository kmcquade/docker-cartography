#!/usr/bin/env bash
set -x

BOLT_URI="${BOLT_URI:-bolt://localhost:7687}"

# This is just for local testing; if these values are not provided, no worries
AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN:-}"
AWS_CONFIG_FILE="${AWS_CONFIG_FILE}"

NEO4J_PASSWORD="${NEO4J_PASSWORD}"
NEO4J_USER="${NEO4J_USER:-neo4j}"
SYNC_ALL_PROFILES="" # Provide this as environment variable, if not specified, set --aws-sync-all-profiles
#SYNC_ALL_PROFILES="${SYNC_ALL_PROFILES:- --aws-sync-all-profiles}" # Provide this as environment variable, if not specified, set --aws-sync-all-profiles

set -e

host="$1"
shift
#cmd="$@"

cmd="
python -m cartography \
    --neo4j-uri $BOLT_URI \
    --neo4j-user $NEO4J_USER \
    --neo4j-password-env-var NEO4J_PASSWORD \
    $SYNC_ALL_PROFILES
"

until curl "$host"; do
  >&2 echo "Neo4j is unavailable; sleeping"
  sleep 1
done

>&2 echo "Neo4j is up - executing command"
exec $cmd

#python -m cartography \
#    --neo4j-uri $BOLT_URI \
#    --neo4j-user $NEO4J_USER \
#    --neo4j-password-env-var NEO4J_PASSWORD \
#    $SYNC_ALL_PROFILES
