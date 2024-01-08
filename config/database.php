<?php

use Illuminate\Support\Str;

return [
    'default'     => 'default',
    'connections' => [
    ],
    'redis' => [
        'client'  => env('REDIS_CLIENT', 'phpredis'),
        'options' => [
            'cluster' => env('REDIS_CLUSTER', 'redis'),
            'prefix'  => env('REDIS_PREFIX', Str::slug(env('APP_NAME', 'laravel'), '_').'_database_'),
        ],
        'default' => [
            'timeout'      => 2,
            'read_timeout' => 2,
            'url'          => env('REDIS_URL'),
            'host'         => env('REDIS_HOST', 'redis'),
            'password'     => env('REDIS_PASSWORD'),
            'port'         => env('REDIS_PORT', 6379),
            'database'     => env('REDIS_DB', env('REDIS_CACHE_DB', '2')),
        ],
    ],
];
