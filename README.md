Distributed ID Generation Network Service
=========================================

Simple distributed ID generation network service based on Simpleflake.

This service is based on [Simpleflake](https://github.com/simonratner/node-simpleflake) and the simpleflake [npm module](https://www.npmjs.com/package/simpleflake).

It generates ids consisting of a 41 bit time (millisecond precision with custom epoch)
followed 23 random bits. Result is a Buffer with an added feature of base58 and
base10 conversions for producing compact and readable strings.

The generated IDs are generally compatible (in time) with IDs generated
by other Simpleflake implementations as long as the same epoch is used.

Simpleflake by design is an un-coordinated solution to the same problem
solved by coordinated solutions like Twitter Snowflake.

ID collisions in practice will likely be a rare occurrence, but should be
anticipated when integration this service.

Application developers that are able to embed a well-tested Simpleflake library
within their codebase should consider that approach prior to deploying
this network service to save on network round-trips.


Build
-----
```
npm install
```


Configure
---------

Configuration should be done via process environment variables.

##### Epoch

This implementation uses a default epoch of 2016-01-01 and is not yet configurable via environment variable.

##### Port

3000 by default.


Usage
-----

Start the service by hand or use a process manager like Supervisord:
```
node index.js
```

The following examples show the available endpoints:
```
curl http://localhost:3000/v1 (returns a base10 ID)

curl http://localhost:3000/v1/base58 (returns a base58 ID)

curl http://localhost:3000/v1/hex (returns a hex ID)
```

Within your application, make a HTTP GET request to return a new ID in the response
body. Different endpoints provide different encodings.

A status endpoint is available at `/health_check` to verify service availability.

In a production environment, this service can be placed behind an HTTP load
balancer.


Testing
-------

The underlying simpleflake-node library includes tests that can be run as needed.

This project includes a benchmarking script (`tests/benchmark.php`) that can be
used to gauge real-world performance.

The script will call the service over the network layer in a tight loop.

It will exit when a collision is detected and report some basic statistics.

The report number of requests per sec (Req/sec) is a rough guide as to the
number of IDs that could be generated without a collision.

This would be a reasonable expectation of the maximum theoretical number of inserts
that could be performed into a **single** RDBMS table if these IDs are used as the
primary key.



Resources
---------

Since the original blog posts and discussions are no longer available, remaining resources will be listed below.

* http://akmanalp.com/simpleflake_presentation



License
-------

[MIT](https://github.com/simonratner/node-simpleflake/blob/master/LICENSE)
