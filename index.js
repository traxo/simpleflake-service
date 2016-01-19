'use strict';

/**
 * Distributed ID generation network service
 *
 * This service is based on Simpleflake and the
 * simpleflake npm module. The generated IDs are
 * generally compatible (in time) with IDs generated
 * by other Simpleflake implementations as long as
 * the same epoch is used.
 *
 * Simpleflake by design is an non-coordinated solution
 * to the same problem solved by coordinated solutions
 * like Twitter Snowflake. ID collisions in practice
 * will likely be a rare occurrence, but should be
 * anticipated.
 *
 * Application developers that are able to embed a
 * well-tested Simpleflake library within their codebases
 * should consider that approach prior to deploying
 * this network service.
 *
 * @author Chris Stevens
 * @see https://github.com/simonratner/node-simpleflake
 */
var express, app, flake, epoch;

// Web server
express = require('express');
app     = express();

// Simpleflake
flake   = require('simpleflake');
epoch   = Date.UTC(2016, 0, 1);

// Configuration
app.set('port', process.env.PORT || 3000);


/**
 * Returns an id using the standard base10 encoding
 *
 */
app.get('/v1', function(request, response) {
  var id = generate('base10');
  response.send(id);
});


/**
 * Returns an id using the base58 encoding
 *
 */
app.get('/v1/base58', function(request, response) {
  var id = generate('base58');
  response.send(id);
});


/**
 * Returns an id using the hex encoding
 *
 */
app.get('/v1/hex', function(request, response) {
  var id = generate('hex');
  response.send(id);
});


/**
 * Health check
 *
 */
app.get('/health_check', function(request, response) {
  response.sendStatus(200);
});


/**
 * Start the app on the listed port
 *
 */
app.listen(app.get('port'));


/**
 * Generate the id using the underlying simpleflake library
 * with a specific encoding
 *
 */
function generate(encoding) {
  // It should be possible to vary the epoch via request, if needed.
  flake.options.epoch = epoch;

  var id = flake();

  switch (encoding) {
      default:
      case 'base10':
        return id.toString('base10');

      case 'base58':
        return id.toString('base58');

      case 'hex':
        return id.toString('hex');
  }

  return false;
}
