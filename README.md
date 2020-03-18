# docker-cartography

We are Dockerizing Cartography. I want to put it in AWS Fargate and then run Neo4j separately. Using Docker compose to test it locally.

## Prerequisites

* Install Docker and docker compose

## Instructions

#### Build the Cartography docker image

```bash
docker build -f Dockerfile.cartography -t infrasec/cartography .
```

#### Test out Cartography locally

* If you are trying to test this out with your AWS Creds, export your AWS environment variables

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
```

* Then run the Docker image.
  * Make sure Neo4j is running first so you have somewhere to store the data!
  * Also, make sure the environment variables from previous stages are exported before running this.

#### Spin up Neo4j and Cartography at the same time

```bash
docker-compose up
```



# Appendix

#### Start Neo4j on its own

```bash
docker run \
    --name testneo4j \
    -p7474:7474 -p7687:7687 \
    -d \
    -v $HOME/neo4j/data:/data \
    -v $HOME/neo4j/logs:/logs \
    -v $HOME/neo4j/import:/var/lib/neo4j/import \
    -v $HOME/neo4j/plugins:/plugins \
    --env NEO4J_AUTH=neo4j/test \
    neo4j:3.5.16
```