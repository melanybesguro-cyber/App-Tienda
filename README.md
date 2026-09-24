# App-Tienda

## Correo de confirmación

Los pedidos se confirman por SMTP. Para Gmail, la cuenta debe tener activada
la verificación en dos pasos y se debe usar una contraseña de aplicación, no
la contraseña normal de la cuenta.

Configura estas variables antes de iniciar Rails:

```text
SMTP_USERNAME=tu-cuenta@gmail.com
SMTP_PASSWORD=tu-contraseña-de-aplicación
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=gmail.com
MAILER_FROM=tu-cuenta@gmail.com
```

En PowerShell puedes definirlas para la sesión actual con `$env:NOMBRE=\"valor\"`.
Después de modificarlas, reinicia el servidor Rails.

Si en Windows aparece `certificate verify failed: self-signed certificate in
certificate chain` durante el desarrollo local, puedes desactivar esa
verificación únicamente en esa sesión:

```powershell
$env:SMTP_SKIP_SSL_VERIFY="1"
```

No uses esa opción en producción; allí debes configurar una autoridad
certificadora válida mediante `SMTP_CA_FILE`.

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
