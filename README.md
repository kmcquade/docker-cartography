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


## Where I can use some help

When I run `docker-compose up` I am getting this error and it makes me sad inside:

```
neo4j          | 2020-03-18 20:52:15.943+0000 INFO  Remote interface available at http://0.0.0.0:7474/
cartography    | + curl http://neo4j:7474
cartography    |   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
cartography    |                                  Dload  Upload   Total   Spent    Left  Speed
100   208  100   208    0     0    976      0 --:--:-- --:--:-- --:--:--   976
cartography    | {
cartography    |   "bolt_routing" : "neo4j://0.0.0.0:7687",
cartography    |   "transaction" : "http://neo4j:7474/db/{databaseName}/tx",
cartography    |   "bolt_direct" : "bolt://0.0.0.0:7687",
cartography    |   "neo4j_version" : "4.0.1",
cartography    |   "neo4j_edition" : "community"
cartography    | }+ echo 'Neo4j is up - executing command'
cartography    | Neo4j is up - executing command
cartography    | + exec python -m cartography --neo4j-uri bolt://neo4j:7687 --neo4j-user neo4j --neo4j-password-env-var NEO4J_PASSWORD --aws-sync-all-profiles
cartography    | Traceback (most recent call last):
cartography    |   File "/usr/local/lib/python3.8/runpy.py", line 193, in _run_module_as_main
cartography    |     return _run_code(code, main_globals, None,
cartography    |   File "/usr/local/lib/python3.8/runpy.py", line 86, in _run_code
cartography    |     exec(code, run_globals)
cartography    |   File "/usr/local/lib/python3.8/site-packages/cartography/__main__.py", line 7, in <module>
cartography    |     sys.exit(cartography.cli.main())
cartography    |   File "/usr/local/lib/python3.8/site-packages/cartography/cli.py", line 259, in main
cartography    |     return CLI(default_sync, prog='cartography').main(argv)
cartography    |   File "/usr/local/lib/python3.8/site-packages/cartography/cli.py", line 239, in main
cartography    |     return cartography.sync.run_with_config(self.sync, config)
cartography    |   File "/usr/local/lib/python3.8/site-packages/cartography/sync.py", line 97, in run_with_config
cartography    |     neo4j_driver = GraphDatabase.driver(
cartography    |   File "/usr/local/lib/python3.8/site-packages/neo4j/__init__.py", line 120, in driver
cartography    |     return Driver(uri, **config)
cartography    |   File "/usr/local/lib/python3.8/site-packages/neo4j/__init__.py", line 161, in __new__
cartography    |     return subclass(uri, **config)
cartography    |   File "/usr/local/lib/python3.8/site-packages/neo4j/__init__.py", line 235, in __new__
cartography    |     pool.release(pool.acquire())
cartography    |   File "/usr/local/lib/python3.8/site-packages/neobolt/direct.py", line 715, in acquire
cartography    |     return self.acquire_direct(self.address)
cartography    |   File "/usr/local/lib/python3.8/site-packages/neobolt/direct.py", line 608, in acquire_direct
cartography    |     connection = self.connector(address, error_handler=self.connection_error_handler)
cartography    |   File "/usr/local/lib/python3.8/site-packages/neo4j/__init__.py", line 232, in connector
cartography    |     return connect(address, **dict(config, **kwargs))
cartography    |   File "/usr/local/lib/python3.8/site-packages/neobolt/direct.py", line 972, in connect
cartography    |     raise last_error
cartography    |   File "/usr/local/lib/python3.8/site-packages/neobolt/direct.py", line 963, in connect
cartography    |     s, der_encoded_server_certificate = _secure(s, host, security_plan.ssl_context, **config)
cartography    |   File "/usr/local/lib/python3.8/site-packages/neobolt/direct.py", line 854, in _secure
cartography    |     s = ssl_context.wrap_socket(s, server_hostname=host if HAS_SNI and host else None)
cartography    |   File "/usr/local/lib/python3.8/ssl.py", line 500, in wrap_socket
cartography    |     return self.sslsocket_class._create(
cartography    |   File "/usr/local/lib/python3.8/ssl.py", line 1040, in _create
cartography    |     self.do_handshake()
cartography    |   File "/usr/local/lib/python3.8/ssl.py", line 1309, in do_handshake
cartography    |     self._sslobj.do_handshake()
cartography    | OSError: [Errno 0] Error
cartography exited with code 1
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
    neo4j:latest
```