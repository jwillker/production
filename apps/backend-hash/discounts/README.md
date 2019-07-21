## Discounts

The Discounts service. Right now the only method the service can respond is the getDiscounts method.

### getDiscounts 

Receives a stream of requests (product id and user id). Fetches the full info for both models and proceeds to apply all active rules returning a stream of discounts.   

For overall specification check `./src/main/protobuf/api.v1.proto`.

## Requirements

You'll need sbt (https://www.scala-sbt.org/) and Docker Compose (https://docs.docker.com/compose/) to develop.

## Run

- Run `sh ./scripts/setup.sh` and `docker-compose up` to run the service.

## Development

You can either:

   - Use `sbt test` to continuously run and verify your code. Recommended approach.

   - Run `sh ./scripts/setup.sh` to make the project ready to be developed and then use `docker-compose up`. This way the volume section in docker-compose configuration file will try to always look for a new runnable jar (needs to run `sbt assembly` to create a new jar). Good if you want to make an integration test.

Other commands:

   - Use `sbt scalastyle` to lint.
   
   - Use `sbt scalafmt` to format. 

## Deployment

Just push to master. It will trigger Google Cloud Builder and deploy a new tagged image to the image repository.

## Design

### Rules

Rules are descriptors on how the discount logic should be applied. They encapsulate all logic relevant to discounts and can compose with each other.

Rules can be active or not. All active rules are composed and applied together in the RulesRegistry. 

Right now the implementation uses fixed rules in a in memory registry but it can be extended to user annotations or a database as a source for the rules.   

### Method

Method is the base abstraction for the rpc method. It normalises how the rpc methods should be implemented, so that the rest of the application can generalise how to handle them.

Makes the treatment of failures required to every rpc method.  

### BidirectionalStream

Transforms any Method in bidirectional stream. Making it possible to respond to requests. Also manages logging of those methods.  

## Improvements

### Bulk Request

A simple improvement in the solution would be to make a method that receives a list of requests and responds them all at once.
