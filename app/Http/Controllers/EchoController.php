<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Spatie\RouteAttributes\Attributes\Get;
use Spatie\RouteAttributes\Attributes\Post;

class EchoController extends Controller
{
    #[Post('/echo', 'echo.test')]
    public function echo(Request $request): JsonResponse
    {
        return response()->json($request->all());
    }

    #[Get('/explode', 'explode.test')]
    public function explode(): never
    {
        throw new Exception('BOOOM');
    }
}
