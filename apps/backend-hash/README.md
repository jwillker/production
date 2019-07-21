## Hash Code Assignment

The system is composed of two services. One in scala (Discounts) and one in javascript (Products). A simple initial database is provided so the projects can easily run.

- Products - A service that can communicate through a rest api to return a list of stored products to the client. In case a user id is provided, it will fetch possible discounts from the Discounts service through a stream. 

- Discounts - A service that transforms a stream of requests (product id and user id) into discounts according to configured rules. 
 

## Requirements

To run the two services you will need Docker Compose. 

- Docker Compose - (https://docs.docker.com/compose/)

## Run

Just run `sh ./run.sh`. Both services and the database will be build and started.

## Development, Deployment

To develop and deploy look inside each service folder.

## Design

Both services were created so that they could resemble each other but not lose the features of each language. The projects structures are intentionally similar so the developer has less cognitive load when switching between them while trying to maintain as idiomatic as possible.
