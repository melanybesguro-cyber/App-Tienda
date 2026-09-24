# App-Tienda

Aplicación Rails para una tienda de productos creados por artistas. Permite
consultar el catálogo, administrar productos y categorías, registrar pedidos,
gestionar comisiones y consumir las operaciones principales mediante una API
JSON versionada.

## Estado actual

- Rails `8.1.3.1` sobre Ruby `4.0.6`.
- SQLite para desarrollo y pruebas.
- Active Storage con almacenamiento local para imágenes.
- Autenticación web mediante sesión y contraseñas protegidas con BCrypt.
- Autenticación de la API mediante tokens almacenados en `users.api_token`.
- Envío de confirmaciones de pedido por SMTP.
- Solid Cache, Solid Queue y Solid Cable configurados para producción.
- Brakeman y RuboCop disponibles para validaciones de seguridad y estilo.

## Requisitos

Para trabajar localmente se necesita:

- Ruby `4.0.6`, indicado en `.ruby-version`.
- Bundler compatible con Ruby 4.
- SQLite 3.
- Git.
- En Windows, RubyInstaller con MSYS2. La gema `fiddle` debe poder compilarse;
	Ruby 4 ya no la incluye como gema predeterminada y `reline` la necesita.

No hace falta instalar Node.js para el flujo normal: JavaScript se gestiona con
Importmap y los paquetes existentes en `vendor/javascript`.

## Instalación local

Desde la raíz del repositorio:

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

La aplicación queda disponible en `http://localhost:3000`.

En Windows se pueden usar los equivalentes:

```powershell
bundle install
bin\rails db:prepare
bin\rails db:seed
bin\rails server
```

`db:prepare` crea o actualiza la base de datos y ejecuta las migraciones
pendientes. `db:seed` crea usuarios de prueba; no se debe usar sin revisar las
credenciales en un entorno compartido o productivo.

## Configuración SMTP

En desarrollo Rails exige `SMTP_USERNAME` y `SMTP_PASSWORD` al iniciar. Para
Gmail, la cuenta debe tener activada la verificación en dos pasos y se debe usar
una contraseña de aplicación, no la contraseña normal.

Variables disponibles:

```text
SMTP_USERNAME=tu-cuenta@gmail.com
SMTP_PASSWORD=tu-contraseña-de-aplicación
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=gmail.com
SMTP_CA_FILE=
SMTP_SKIP_SSL_VERIFY=0
```

En PowerShell, las variables pueden definirse para la sesión actual:

```powershell
$env:SMTP_USERNAME="tu-cuenta@gmail.com"
$env:SMTP_PASSWORD="tu-contraseña-de-aplicación"
$env:SMTP_ADDRESS="smtp.gmail.com"
$env:SMTP_PORT="587"
$env:SMTP_DOMAIN="gmail.com"
```

Después de modificar variables, hay que reiniciar el servidor Rails. En
producción también son obligatorias `SMTP_ADDRESS`, `SMTP_DOMAIN`,
`SMTP_USERNAME` y `SMTP_PASSWORD`.

Si Windows muestra `certificate verify failed: self-signed certificate in
certificate chain` durante el desarrollo local, se puede desactivar la
verificación solo para esa sesión:

```powershell
$env:SMTP_SKIP_SSL_VERIFY="1"
```

No usar esta opción en producción. Allí se debe configurar una autoridad
certificadora válida mediante `SMTP_CA_FILE`.

## Usuarios y permisos

El modelo `User` admite tres roles:

| Rol | Responsabilidad |
| --- | --- |
| `customer` | Consulta productos y crea pedidos o comisiones propias. |
| `artist` | Gestiona sus productos y categorías desde el área de artista. |
| `admin` | Administra productos, categorías, pedidos, comisiones y usuarios. |

`db:seed` crea estas cuentas de prueba:

| Rol | Email | Contraseña |
| --- | --- | --- |
| Administrador | `admin@artelier.com` | `admin123` |
| Artista | `artista@artelier.com` | `artist123` |
| Cliente | `cliente@artelier.com` | `customer123` |

Estas credenciales son únicamente para desarrollo. Deben cambiarse o eliminarse
antes de desplegar la aplicación.

## Funcionalidad web

- **Inicio:** catálogo público de productos.
- **Cliente:** registro, inicio/cierre de sesión y creación de pedidos.
- **Artista:** registro, inicio/cierre de sesión, alta, edición, consulta y
	eliminación de productos; también puede crear categorías.
- **Administrador:** inicio/cierre de sesión y administración de usuarios,
	productos, categorías, pedidos y comisiones.
- **Pedidos:** al crear un pedido se valida el stock, se descuenta la cantidad
	disponible y se envía un correo de confirmación al cliente.
- **Imágenes:** los productos pueden tener una imagen mediante Active Storage.

El estado inicial de los pedidos y comisiones creados por la API es `pending`.
Los valores permitidos y las reglas definitivas deben consultarse en los
modelos y controladores antes de cambiar integraciones externas.

## Rutas web principales

| Área | Rutas |
| --- | --- |
| Pública | `GET /` |
| Cliente | `/customer/login`, `/customer/register`, `/customer/`, `POST /customer/orders` |
| Artista | `/artist/login`, `/artist/register`, `/artist/products`, `/artist/categories` |
| Administrador | `/admin/login`, `/admin/register`, `/admin/products`, `/admin/categories`, `/admin/orders`, `/admin/commissions`, `/admin/users` |

La lista completa y la fuente de verdad de las rutas están en
`config/routes.rb`. Para inspeccionarlas:

```bash
bin/rails routes
```

## API JSON v1

La API está bajo `/api/v1` y espera respuestas JSON. Las peticiones protegidas
usan el encabezado:

```http
Authorization: Bearer TOKEN
Content-Type: application/json
```

### Autenticación

Registrar un cliente:

```http
POST /api/v1/register
```

```json
{
	"user": {
		"name": "Nuevo cliente",
		"email": "cliente@example.com",
		"password": "secreto",
		"password_confirmation": "secreto"
	}
}
```

Iniciar sesión y obtener el token:

```http
POST /api/v1/login
```

```json
{
	"email": "cliente@example.com",
	"password": "secreto"
}
```

### Catálogo y perfil

| Método | Endpoint | Token |
| --- | --- | --- |
| `GET` | `/api/v1/products` | No |
| `GET` | `/api/v1/products/:id` | No |
| `GET` | `/api/v1/profile` | Sí |
| `GET` | `/api/v1/orders` | Sí |
| `GET` | `/api/v1/orders/:id` | Sí |
| `POST` | `/api/v1/orders` | Sí |
| `GET` | `/api/v1/commissions` | Sí |
| `GET` | `/api/v1/commissions/:id` | Sí |
| `POST` | `/api/v1/commissions` | Sí |

Crear un pedido:

```json
{
	"products": [
		{ "product_id": 1, "quantity": 2 },
		{ "product_id": 3, "quantity": 1 }
	]
}
```

Crear una comisión asociada a un pedido propio:

```json
{
	"order_id": 1,
	"description": "Ilustración personalizada",
	"deadline": "2026-10-15"
}
```

Los pedidos validan que exista cada producto, que la cantidad sea mayor que
cero y que haya stock suficiente. La operación y el descuento de stock se
realizan dentro de una transacción. Si SMTP falla, el pedido se conserva y la
respuesta indica `email_sent: false`.

## Modelo de datos

- `User`: identidad, rol, contraseña y token de API.
- `Category`: nombre y descripción; tiene muchos productos.
- `Product`: nombre, descripción, precio, stock, artista, categoría e imagen.
- `Order`: cliente, estado y total.
- `OrderItem`: producto, cantidad y precio unitario guardado al comprar.
- `Commission`: cliente, pedido, descripción, estado y fecha límite.

Las relaciones y validaciones están en `app/models`. Las migraciones se
encuentran en `db/migrate`; no se debe editar `db/schema.rb` manualmente.

## Estructura del proyecto

```text
app/
	controllers/       Controladores públicos, customer, artist, admin y API
	models/            Entidades y reglas de validación
	views/             Plantillas HTML y respuestas de correo
	mailers/           Confirmación de pedidos
	javascript/        Stimulus e Importmap
	assets/            Estilos e imágenes
config/
	routes.rb          Rutas web y API
	environments/      Configuración por entorno
db/
	migrate/           Cambios de esquema
	seeds.rb           Datos iniciales de desarrollo
test/                Pruebas Minitest, fixtures y pruebas de controladores
lib/tasks/           Tareas Rake propias
bin/                 Comandos Rails, pruebas, auditorías y despliegue
```

## Pruebas y calidad

Ejecutar toda la suite:

```bash
bin/rails test
```

Ejecutar una prueba concreta:

```bash
bin/rails test test/controllers/api/v1/orders_controller_test.rb
```

Revisar estilo:

```bash
bin/rubocop
```

Analizar vulnerabilidades:

```bash
bin/brakeman --no-pager
bin/bundler-audit check --update
```

Después de cambiar rutas, autenticación, pedidos o permisos, se deben ampliar
las pruebas correspondientes en `test/controllers` y `test/models`. Las
pruebas usan la base SQLite de `storage/test.sqlite3` y fixtures YAML.

## Desarrollo y servicios

El servidor local se inicia con:

```bash
bin/dev
```

Para iniciar solo Rails:

```bash
bin/rails server
```

En desarrollo la caché usa memoria, la cola de Active Job usa la configuración
por defecto y Active Storage guarda archivos en `storage/`. En producción se
usan `solid_cache`, `solid_queue` y `solid_cable`, cada uno con su base SQLite
configurada en `config/database.yml`.

## Docker y despliegue

El `Dockerfile` está preparado principalmente para producción. Usa Ruby
`4.0.6`, instala SQLite y libvips, precompila assets y arranca Rails mediante
Thruster.

Construcción y ejecución local de la imagen:

```bash
docker build -t app_tienda .
docker run -d -p 80:80 \
	-e RAILS_MASTER_KEY=valor-real \
	--name app_tienda app_tienda
```

Antes de desplegar hay que revisar `.kamal`, `config/deploy.yml`, el volumen
persistente de `storage/`, `RAILS_MASTER_KEY`, las variables SMTP y el dominio
usado por los enlaces de correo. No se deben subir secretos ni archivos de
credenciales al repositorio.

## Mantenimiento para futuros cambios

1. Leer `config/routes.rb`, el controlador del área afectada y el modelo
	 relacionado antes de modificar una funcionalidad.
2. Mantener la autorización en los filtros `require_customer`, `require_artist`,
	 `require_admin` y `authenticate_api_user`; no confiar solo en ocultar
	 enlaces de la interfaz.
3. Crear una migración con `bin/rails generate migration ...` para cambios de
	 base de datos y ejecutar `bin/rails db:migrate`.
4. Mantener las respuestas de `/api/v1` compatibles o documentar cualquier
	 cambio que rompa clientes existentes.
5. Añadir o actualizar pruebas antes de cambiar el flujo de pedidos, stock,
	 comisiones, roles o tokens.
6. Ejecutar tests, RuboCop, Brakeman y Bundler Audit antes de publicar.
7. Actualizar este README cuando cambien comandos, variables, rutas o roles.

## Seguridad

- No usar las contraseñas de `db/seeds.rb` fuera de desarrollo.
- No guardar contraseñas SMTP, tokens, `RAILS_MASTER_KEY` ni claves cloud en Git.
- No desactivar la verificación SSL de SMTP en producción.
- Tratar los tokens de API como credenciales: no imprimirlos en logs ni
	compartirlos en issues.
- Revisar autorización y pertenencia del recurso antes de exponer nuevas rutas.
