<?php

use Illuminate\Bus\BusServiceProvider;
use Illuminate\Cache\CacheServiceProvider;
use Illuminate\Database\DatabaseServiceProvider;
use Illuminate\Encryption\EncryptionServiceProvider;
use Illuminate\Filesystem\FilesystemServiceProvider;
use Illuminate\Foundation\Providers\ConsoleSupportServiceProvider;
use Illuminate\Foundation\Providers\FoundationServiceProvider;
use Illuminate\Foundation\Support\Providers\EventServiceProvider;
use Illuminate\Hashing\HashServiceProvider;
use Illuminate\Mail\MailServiceProvider;
use Illuminate\Pipeline\PipelineServiceProvider;
use Illuminate\Queue\QueueServiceProvider;
use Illuminate\Support\Facades\Facade;
use Illuminate\Translation\TranslationServiceProvider;
use Illuminate\Validation\ValidationServiceProvider;
use Illuminate\View\ViewServiceProvider;
use myswooop\RMMK2\Providers\RedisServiceProvider;
use mySWOOOP\Swooopvel\Providers\RouteServiceProvider;
use mySWOOOP\Swooopvel\Providers\SwooopvelAppServiceProvider;
use mySWOOOP\Utils\Providers\HealthCheckProvider;

return [
    'name' => env('APP_NAME', 'Email-API'),

    'env' => env('APP_ENV', 'production'),

    'debug' => (bool) env('APP_DEBUG', false),

    'url' => env('APP_URL', 'https://email-api-service.myswooop.de'),

    'asset_url' => env('ASSET_URL'),

    'timezone' => 'Europe/Berlin',

    'locale' => 'de',

    'fallback_locale' => 'en',

    'faker_locale' => 'de_DE',

    'key' => env('APP_KEY'),

    'cipher' => 'AES-256-CBC',

    'providers' => [
        BusServiceProvider::class,
        CacheServiceProvider::class,
        ConsoleSupportServiceProvider::class,
        DatabaseServiceProvider::class, // TODO: why ???? there is no database here
        EncryptionServiceProvider::class,
        FilesystemServiceProvider::class,
        FoundationServiceProvider::class,
        HashServiceProvider::class,
        MailServiceProvider::class,
        PipelineServiceProvider::class,
        QueueServiceProvider::class,
        RedisServiceProvider::class,
        TranslationServiceProvider::class,
        ValidationServiceProvider::class,
        ViewServiceProvider::class,
        HealthCheckProvider::class,
        SwooopvelAppServiceProvider::class,
        EventServiceProvider::class,
        RouteServiceProvider::class,
    ],

    'aliases' => Facade::defaultAliases()->toArray(),
];
