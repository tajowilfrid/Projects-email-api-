Es soll hier ein API-Service entstehen, welcher eine POST route bereitstellt.

Diese Route soll einen variablen URI Path $channel bereitstellen, welcher von einem Controller entgegengenommen wird.

Payload für die Route sollen sein:
  - message (string, die zu sendende Nachricht)
  - from (email, Absenderadresse)
  - to (email,optional, Empfängeraddresse, wenn nicht gegeben 'nofication@myswooop.de' )

Als Aktion soll eine Mail mit einem Betreff = $channel entstehen und versendet werden.

Als Response Code sollte hier ein 202 (Accepted)

So soll z.B. ein Post request auf /notification

mit dem payload

 - message: 'Hello'
 - from: 'somewhere@myswooop.de'
 - to: 'it@myswooop.de'

eine Email versenden mit

 - Betreff: 'notification'
 - Message: 'Hello'
 - Absender: 'somewhere@myswooop.de'
 - Empfänger: 'it@myswooop.de'

Die nächste Ausbaustufe soll sein:

Eine Config mit einem mapping erstellen.

Dieses Mapping soll einen channel-name auf definierte Empfänger-Addressen mappen

so soll z.B. beim senden auf /alerts immer 'it-service@myswooop.de' als Empfänger verwendet werden.

Final muss der Service abgesichert werden, sodass nur erlaubte IPs oder Netzwerke (CIDR-Notation) diesen Service verwenden können.

Hierzu muss die Request-IP geprüft werden, und sofern nicht erlaubt, darf keine Mail versendet werden, sondern eine
Response mit Status 401 (Unauthorized)

Desweiteren muss sichergestellt werden, dass als empfänger (payload:to) nur @myswooop.de addressen erlaubt sind. Ein abweichender Empfänger via channel-config-mapping kann diese regel brechen


--> links

https://de.wikipedia.org/wiki/HTTP-Statuscode

https://laravel.com/docs/10.x/controllers

für routing verwenden wir

https://github.com/spatie/laravel-route-attributes

https://laravel.com/docs/10.x/requests + https://laravel.com/docs/10.x/validation