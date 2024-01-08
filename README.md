zum initialen start:

./sail build

./sail init

dann

./sail up

service läuft auf localhost:8000

für die verwendung ist docker, docker-compose sowie ein valides gitlab-auth-token notwendig

-> hierzu z.B. folgendes script nutzen:

https://paste.ziegert.coffee/egupahadon.bash

Ein Token lässt sich über gitlab -> https://gitlab.myschubert.com/-/profile/personal_access_tokens erstellen und muss die permission 'api' führen

Als erste Test route ist ein echo implementiert:

<code>
curl -d 'message=Hello World' localhost:8000/echo
</code>