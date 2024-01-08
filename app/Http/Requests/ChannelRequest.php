<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ChannelRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'message' => ['required', 'string', 'min:10'],
            'to'      => ['sometimes', 'email:rfc,dns', 'ends_with:@myswooop.de'],
            'from'    => ['required', 'email:rfc,dns', 'ends_with:@myswooop.de'],
        ];
    }
}
