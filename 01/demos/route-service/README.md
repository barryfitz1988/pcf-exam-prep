# Cloud Foundry Route Service Example

This project is an example of a [Cloud Foundry Route Service][r] written with Spring Boot[b].  This application does the following to each request:

1. Intercepts an incoming request
2. Logs information about that incoming request
3. Transforms the incoming request to an outgoing request
4. Logs information about that outgoing request
5. Forwards the request and response

## Requirements
### Java, Maven
The application is written in Java 8 and packaged as a self executable JAR file. This enables it to run anywhere that Java is available.

## Deployment
_The following instructions assume that you have [created an account][c] and [installed the `cf` command line tool][i]._

In order to automate the deployment process as much as possible, the project contains a Cloud Foundry [manifest][y].  To deploy run the following commands:
```bash
$ ./mvnw clean package
$ cf push
```

Next, create a user provided service that contains the route service configuration information.  To do this, run the following command, substituting the address that the route service is listening on:
```bash
$ cf create-user-provided-service test-route-service -r https://<ROUTE-SERVICE-ADDRESS>
```

The next step assumes that you have an application already running that you'd like to bind this route service to.  To do this, run the following command, substituting the domain and hostname bound to that application:
```bash
$ cf bind-route-service <APPLICATION-DOMAIN> test-route-service --hostname <APPLICATION-HOST>
```

In order to view the interception of the requests, you will need to stream the logs of the route service.  To do this, run the following command:
```bash
$ cf logs route-service-example
```

Finally, start making requests against your test application.  The route service's logs should start returning results that look similar to the following:
```text
INFO  Incoming Request: <PATCH http://localhost/route-service/patch,[B@4f453e63,{X-CF-Forwarded-Url=[http://localhost/original/patch], X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature], Content-Type=[text/plain], Content-Length=[9]}>
INFO  Outgoing Request: <PATCH http://localhost/original/patch,[B@4f453e63,{X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature], Content-Type=[text/plain], Content-Length=[9]}>
INFO  Incoming Request: <DELETE http://localhost/route-service/delete,{X-CF-Forwarded-Url=[http://localhost/original/delete], X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature]}>
INFO  Outgoing Request: <DELETE http://localhost/original/delete,{X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature]}>
INFO  Incoming Request: <HEAD http://localhost/route-service/head,{X-CF-Forwarded-Url=[http://localhost/original/head], X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature]}>
INFO  Outgoing Request: <HEAD http://localhost/original/head,{X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature]}>
INFO  Incoming Request: <PUT http://localhost/route-service/put,[B@12ffd1de,{X-CF-Forwarded-Url=[http://localhost/original/put], X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature], Content-Type=[text/plain], Content-Length=[9]}>
INFO  Outgoing Request: <PUT http://localhost/original/put,[B@12ffd1de,{X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature], Content-Type=[text/plain], Content-Length=[9]}>
INFO  Incoming Request: <POST http://localhost/route-service/post,[B@9d3c67,{X-CF-Forwarded-Url=[http://localhost/original/post], X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature], Content-Type=[text/plain], Content-Length=[9]}>
INFO  Outgoing Request: <POST http://localhost/original/post,[B@9d3c67,{X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature], Content-Type=[text/plain], Content-Length=[9]}>
INFO  Incoming Request: <GET http://localhost/route-service/get,{X-CF-Forwarded-Url=[http://localhost/original/get], X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature]}>
INFO  Outgoing Request: <GET http://localhost/original/get,{X-CF-Proxy-Metadata=[test-proxy-metadata], X-CF-Proxy-Signature=[test-proxy-signature]}>
```

## Developing
The project is set up as a Maven project and doesn't have any special requirements beyond that. It has been created using [IntelliJ][j] and contains configuration information for that environment, but should work with other IDEs.

## Courses using this application.

`Note`: When updating this application please make sure the corresponding instructions are updated within the following dependent courses. The instructions for these labs may not change but please review before pushing application to production with this [pipeline](http://concourse.enablement.pivotal.io/pipelines/route-service).

- [pivotal-cloud-foundry-developer](https://github.com/pivotal-education/pivotal-cloud-foundry-developer)


## License
The project is released under version 2.0 of the [Apache License][a].


[a]: http://www.apache.org/licenses/LICENSE-2.0
[b]: http://projects.spring.io/spring-boot/
[c]: https://console.run.pivotal.io/register
[i]: http://docs.run.pivotal.io/devguide/installcf/install-go-cli.html
[j]: http://www.jetbrains.com/idea/
[r]: http://docs.cloudfoundry.org/services/route-services.html
[y]: manifest.yml
