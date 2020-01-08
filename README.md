# Distributed Computing "Cloud-Datenmanagement"

## Aufgabenstellung
Die detaillierte [Aufgabenstellung](TASK.md) beschreibt die notwendigen Schritte zur Realisierung.

## Design und Beschreibung

This server has a index with links to login and register. The registered users are persited and stored in a JSON file datastore. Most of the answers of the server when trying to register or login. When logged in successfully you get a rendered page so that you cannot just copy the path and access it all the time.

## Implementierung

My solution is using a [Dart](https://dart.dev/) framework named [Aqueduct](https://aqueduct.io/) as a base. I am using this because it was the first I found and I did not look for another one since I was just trying it out. And it had a ORM which sadly only works for Postgres. It also has a test framework which helped me to write the tests.

### Endpoints

Accepts post with content type (`content-type` header):

* x-www-form-urlencoded (For human/from html)
* application/json (For api/curl)

Can respond with (`accept` header):

* text/html (For human interaction)
* application/json (For api/curl)

#### /login

Parameters:

* mail: Mail of the user
* password: Password of the user

```json
{"mail": "setup@setup", "password": "setup"}
```

Returns (json)

* error: Bool if error has occoured (always false if no error)

* name: Name of the user
* mail: Mail of the user

```json
{"name":"Setup User","mail":"setup@setup","error":false}
```

#### /register

Parameters:

* name: Name of the user
* mail: Mail of the user
* password: Password of the user

```json
{"name": "curl-register", "mail": "register@curl", "password": "curl"}
```

Returns (json)

* error: Bool if error has occoured (always false if no error)

* name: Name of the user
* mail: Mail of the user

```json
{"name":"curl-register","mail":"register@curl","error":false}
```

#### Error

If an error occoures the returned json object has the following parameters:

* error: Bool if error has occoured (always true)
* message: Human readable error message

```json
{"message":"Wrong credentials","error":true}
```



## Deployment

Requirements:

* Dart
* pub

### Needed for all Deploys

Clone the repository

```bash
git clone https://github.com/dlangheiter-tgm/syt5-gk933-cloud-datamanagement-dlangheiter-tgm.git cloud-data
cd cloud-data
```

#### Basic run
Install dependencies

```bash
cd src
pub get
```

Run the server

```bash
pub run aqueduct:aqueduct serve
```

This runs the server without any changed configuration on port `8888`.

#### Test run

Install dependencies

```
cd src
pub get
```

Run the tests

```
pub run test
```

#### Docker

Build docker image

```bash
cd src
docker build . -t cloud-data
```

Start the docker container

```bash
docker run -p 8888:8888 cloud-data
```

Make the data persistent

```
docker run -p 8888:8888 -v ./users.db:/app/users.db cloud-data
```

Config the docker container:

```bash
docker run -p 8888:8888 -v ./config.yaml:/app/config.yaml cloud-data
```

### Configuration

Example development config:

```yaml
server:
  port: 8888
  processors: 0
  caching: true

database:
  path: ./users.db
```

#### Config info:

* server.port: Port the server starts on
* server.processors: How many processes should be started:
  * \> 0: Number of processors to run
  * 0: 'auto' uses the number of processors as number of processes to start
  * < 1: Number of processors minus the number
* server.caching: If the html files should be cached or not
* database.path: The path to the database file

### Access

Open `http://localhost:8888` in your browser

### Test with CURL

Login

```bash
curl -i -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8888/login -d '{"mail": "setup@setup", "password": "setup"}'
```

Register

```bash
curl -i -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8888/register -d '{"name": "curl-register", "mail": "register@curl", "password": "curl"}'
```



## Quellen

[Dart Aqueduct framework](https://aqueduct.io/)

[Docker](https://www.docker.com/)

[Save Config Dart Package](https://pub.dev/packages/safe_config)

[Args Dart Package](https://pub.dev/packages/args)

[Sembast Dart Package](https://pub.dev/packages/sembast)

