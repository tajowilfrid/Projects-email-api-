<?php

namespace App\Http\Controllers;

use App\Http\Requests\ChannelRequest;
use App\Mail\ChannelMail;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Mail;
use Spatie\RouteAttributes\Attributes\Post;

class EmailApiController extends Controller
{
    #[Post('/{channel}')]
    public function handle(ChannelRequest $request, string $channel): JsonResponse|Response
    {
        Mail::to(
            $request->string('to', 'nofication@myswooop.de')->toString()
        )
            ->send(
                new ChannelMail(
                    $channel,
                    $request->string('from')->toString(),
                    $request->string('message')->toString(),
                )
            );
        $data = [
            $request->string('to'),
            $request->string('from'),
        ];

        return new JsonResponse($data, 202);
    }
}
