## Products

The Products service. Right now the only method the service can respond is the getProducts method.

### getProducts 

Fetches a list of products and returns to the client.

If the user id is provided on the request through a metadata (X-USER-ID) it also fetches possible discounts for each product from the discount service, otherwise uses a default value for the discounts.
Even if the discount service is down or errored, returns all the products to the client.  

Can be accessed through rest on  `GET /products`.

For overall specification check `./proto/api.v1.proto`.

## Requirements

You'll need yarn (https://yarnpkg.com/en/), nodejs (https://nodejs.org/en/), and Docker Compose (https://docs.docker.com/compose/) to develop.

## Run

Run `sh ./scripts/setup.sh` and `docker-compose up` to run the service.

## Development

You can either:

   - Use `yarn install` to install the dependencies then `yarn test` to continuously run and verify your code. Recommended approach.

   - Run `sh ./scripts/setup.sh` to make the project ready to be developed and then use `docker-compose up`. This way the volume section in docker-compose configuration file will try to always look for the current source code. Good if you want to make an integration test.

Other commands:

   - Use `yarn lint` to lint.
   
   - Use `yarn format` to format. 

## Deployment

Just push to master. It will trigger Google Cloud Builder and deploy a new tagged image to the image repository.

## Design

### Method

Method is the base abstraction for the rpc method. It normalises how the rpc methods should be implemented, so that the rest of the application can generalise how to handle them. 

### CollectStream

Writes all requests in a stream and collects all data from it, generation a list of responses as a result. This is used to easily abstract call to streaming services.  

### Gateway

The Gateway provides a way to access grpc methods through rest. It uses an api .proto file to configure a http server and expose them.

## Improvements

### Use @grpc/proto-loader

The project has a deprecation warning because the `grpc-dynamic-gateway` library does not use the new `@grpc/proto-loader`. It also causes the application to requires the google api .proto files to build correctly.
I have already updated the `grpc-dynamic-gateway` and sent a pull request to solve this `https://github.com/konsumer/grpc-dynamic-gateway/pull/17`, once this is done the issue is fixed and the google .proto files can be deleted.    
