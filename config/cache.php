<?php

use Illuminate\Support\Str;

return [
    'default' => env('CACHE_DRIVER', 'apc'),

    'stores' => [
        'apc' => [
            'driver' => 'apc',
        ],
        'array' => [
            'driver'    => 'array',
            'serialize' => false,
        ],
        'file' => [
            'driver' => 'file',
            'path'   => storage_path('framework/cache/data'),
        ],
    ],

    'prefix' => env('CACHE_PREFIX', Str::slug(env('APP_NAME', 'laravel'), '_').'_cache_'),
];
