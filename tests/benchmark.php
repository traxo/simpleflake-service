<?php
/**
 * This is a simple benchmark script to call the
 * id generation service over the network layer
 * in a tight loop.
 *
 * It will exit when a collision is detected and
 * report some basic statistics. The reported number
 * of requests per sec (Req/sec) is a rough guide
 * as to the number of IDs that could be generated
 * without a collision. This would be a reasonable
 * expectation of the number of inserts that could
 * be done into a SINGLE RDBMS table if these IDs
 * are used as the primary key.
 *
 */

$port = 3000;

$url = "http://127.0.0.1:$port/v1";
// $url = "http://127.0.0.1:$port/v1/base58";
// $url = "http://127.0.0.1:$port/v1/hex";

$i = 0;
$max = 500000;
$storage = array();

$time_start = microtime(true);

while ($i < $max) {
    $flake = file_get_contents($url);

    if (array_key_exists('x'.$flake, $storage)) {
        echo "Collision on ".$flake . " ($i of $max)".PHP_EOL;
        $time = microtime(true) - $time_start;
        echo "Runtime: $time seconds" . PHP_EOL;
        echo "Req/sec: " . ($i / $time) . PHP_EOL;
        exit(1);
    }
    $storage['x'.$flake] = null;

    echo $flake . PHP_EOL;
    $i++;
}

$time_end = microtime(true);
$time = $time_end - $time_start;

echo "Runtime: $time seconds" . PHP_EOL;
echo "Req/sec: " . ($i / $time) . PHP_EOL;
