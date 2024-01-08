<?php

use Illuminate\Contracts\Console\Kernel;
use Illuminate\Support\Facades\Artisan;
use Symfony\Component\Console\Output\ConsoleOutput;

require_once dirname(__DIR__).'/vendor/autoload.php';

shell_exec('rm -rf ./tests/test_results/php/*');

$app = require __DIR__.'/../bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();
$output = $app->make(ConsoleOutput::class);

Artisan::call('config:clear', [], $output);
Artisan::call('route:clear', [], $output);
Artisan::call('cache:clear', [], $output);
