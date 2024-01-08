<?php

return [
    'container' => [
        'id' => env('CONTAINER_ID', 'unknown'),
    ],

    'active' => env('APM_ACTIVE', env('ELASTIC_APM_ENABLED', false)),

    'log-level' => env('APM_LOG_LEVEL', 'error'),

    'cli' => [
        'active' => env('APM_ACTIVE_CLI', true),
    ],

    'app' => [
        'appName' => env('APP_NAME'),

        'appVersion' => env('APP_VERSION', 'local'),
    ],

    'env' => [
        'env' => ['DOCUMENT_ROOT', 'REMOTE_ADDR'],

        'environment' => env('APP_ENV', 'local'),
    ],

    'server' => [
        'serverUrl' => env('APM_SERVERURL', env('ELASTIC_APM_SERVER_URL', 'http://apm:8200')),

        'secretToken' => env('APM_SECRETTOKEN', env('ELASTIC_APM_SECRET_TOKEN')),

        'hostname' => env('ELASTIC_APM_HOSTNAME', gethostname()),
    ],

    'agent' => [
        'transactionSampleRate' => env('ELASTIC_APM_TRANSACTION_SAMPLE_RATE', 1),
    ],

    'transactions' => [
        'useRouteUri' => env('APM_USEROUTEURI', true),

        'ignorePatterns' => env('APM_IGNORE_PATTERNS'),
    ],

    'spans' => [
        'maxTraceItems' => env('APM_MAXTRACEITEMS', 1000),

        'backtraceDepth' => env('APM_BACKTRACEDEPTH', env('ELASTIC_APM_STACK_TRACE_LIMIT', 25)),

        'querylog' => [
            'enabled'   => env('APM_QUERYLOG', true),
            'threshold' => env('APM_THRESHOLD', 200),
        ],
    ],
];
