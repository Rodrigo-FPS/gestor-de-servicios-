# Gestor Automatizado de Servicios con Notificación con uso de Bot de Telegram usando API.

Sistema automatizado para la administración de servicios en entornos Linux con notificaciones en tiempo real vía Telegram.

# Tabla de Contenidos

## Descripción

Este proyecto proporciona una suite completa de herramientas para la administración automatizada de servicios Linux, incluyendo gestión de usuarios, monitoreo de servicios, respaldos automáticos y ejecución remota de scripts. Todas las operaciones se registran en logs detallados y generan notificaciones automáticas via Telegram.

# Características

- **Gestión de Usuarios**: Creación, eliminación y modificación de usuarios del sistema
- **Monitoreo de Servicios**: Supervisión automática y reinicio de servicios críticos
- **Sistema de Respaldos**: Generación automática de archivos tar.gz con timestamp
- **Ejecución Remota**: Distribución y ejecución de scripts en múltiples hosts
- **Monitoreo de Recursos**: Vigilancia continua de CPU y espacio en disco
- **Notificaciones Telegram**: Alertas instantáneas para todos los eventos del sistema
- **Logging Completo**: Registro detallado de todas las operaciones con timestamp

## Instalación

### Requisitos Previos

- Sistema Linux (Ubuntu/Debian/CentOS)
- Permisos de administrador
- Conexión a internet
- Paquetes: `curl`, `tar`, `ssh`, `systemctl`

### Instalación Rápida

```
# Clonar el repositorio
git clone https://github.com/usuario/gestor-servicios-telegram.git
cd gestor-servicios-telegram

# Hacer ejecutables los scripts
chmod +x *.sh

# Crear directorios necesarios
sudo mkdir -p /var/log/gestion_servicios
sudo mkdir -p /backup
```

## Configuración

### 1. Configuración del Bot de Telegram

1. Crear bot en Telegram
2. Obtener el token del bot
3. Obtener el Chat ID enviando un mensaje y consultando:
   ```
   https://api.telegram.org/bot<TOKEN>/getUpdates
   ```

### 2. Archivo de Configuración

Editar `config.txt`:

```bash
# Configuración Telegram
TOKEN="tu_token_de_bot"
CHAT_ID="tu_chat_id"

# Rutas del sistema
LOG_PATH="/var/log/gestion_servicios"
RESPALDO_DIR="/home/usuario/documentos"
BACKUP_PATH="/backup"
```

### 3. Configuración de Servicios

Editar `servicios.txt`:
```
ssh
apache2
mysql
nginx
```

### 4. Configuración de Hosts Remotos

Editar `host.txt`:
```
usuario@192.168.1.10
admin@servidor.empresa.com
root@backup.local
```

## Uso

### Scripts Principales

#### Gestión de Usuarios
```
sudo ./usuarios.sh
```
Interfaz interactiva para crear, eliminar y modificar usuarios.

#### Monitoreo de Servicios
```
./servicios.sh
```
Verifica y reinicia servicios definidos en `servicios.txt`.

#### Sistema de Respaldos
```
./respaldo.sh
```
Crea respaldo comprimido del directorio configurado.

#### Ejecución Remota
```
./remoto.sh
```
Ejecuta `hola.sh` en todos los hosts configurados.

#### Monitoreo de Recursos
```
# Límites por defecto (70% CPU, 70% disco)
./monitoreo.sh

# Límites personalizados
./monitoreo.sh 80 85
```

### Automatización con Cron

```
# Respaldo diario a las 2:00 AM
0 2 * * * /ruta/al/proyecto/respaldo.sh

# Verificar servicios cada 5 minutos
*/5 * * * * /ruta/al/proyecto/servicios.sh

# Monitoreo continuo
@reboot /ruta/al/proyecto/monitoreo.sh &
```

## Arquitectura

### Estructura de Archivos

```
gestor-servicios-telegram/
├── usuarios.sh          # Gestión de usuarios
├── servicios.sh         # Monitoreo de servicios
├── respaldo.sh          # Sistema de respaldos
├── remoto.sh           # Ejecución remota
├── monitoreo.sh        # Monitoreo de recursos
├── hola.sh             # Script de ejemplo
├── config.txt          # Configuración principal
├── configservicios.txt       # Lista de servicios
├── confighost.txt            # Lista de hosts
└── README.md           # Este archivo
```

### Flujo de Trabajo

1. Carga de Configuración: Todos los scripts cargan variables desde `config.txt`
2. Ejecución de Operación: Cada script realiza su función específica
3. Registro de Logs: Todas las acciones se registran con timestamp
4. Notificación Telegram: Eventos importantes se notifican automáticamente

### Sistema de Logs

Los logs se almacenan en `/var/log/gestion_servicios/`:

- `acciones.log`: Gestión de usuarios
- `servicios.log`: Estado de servicios
- `remoto.log`: Ejecución remota

Formato:
```
2024-01-15 14:30:25 - Usuario deadpixel creado correctamente
2024-01-15 14:35:10 - Servicio ssh reiniciado
```

## Funcionalidades Detalladas

### usuarios.sh

- Menú interactivo con 4 opciones
- Validación de existencia de usuarios
- Entrada segura de contraseñas (oculta)
- Notificación automática de todas las acciones

### servicios.sh

- Lectura automática de lista de servicios
- Verificación silenciosa con `systemctl`
- Reinicio automático de servicios caídos
- Notificación solo en caso de problemas

### respaldo.sh

- Nombres únicos basados en timestamp
- Verificación de directorios fuente
- Creación automática de directorios destino
- Validación de respaldos exitosos

### remoto.sh

- Transferencia segura via SCP
- Ejecución remota via SSH
- Captura de salida de comandos
- Manejo de errores de conexión

### monitoreo.sh

- Cálculo preciso de CPU desde `/proc/stat`
- Monitoreo de espacio en disco
- Límites configurables por parámetros
- Alertas solo cuando se exceden límites

## Troubleshooting

### Problemas Comunes

Bot no envía notificaciones:
```bash
# Verificar configuración
curl -s "https://api.telegram.org/bot<TOKEN>/getMe"
```

Servicios no se reinician:
```bash
# Verificar permisos sudo
sudo systemctl status <servicio>
```

Error de conexión SSH:
```bash
# Verificar autenticación por clave
ssh-copy-id usuario@host
```


## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.
**Nota:** Algunas dependencias utilizadas pueden tener sus propias licencias. Revisa sus respectivos repositorios para más información.

## Contacto

- **Proyecto**: Gestor Automatizado de Servicios
- **Autores**: José Antonio Montane Dominguez, Rodrigo Fernando Perez Sanchez y Roberto Perez de la Garza
- **Universidad**: Universidad Veracruzana
- **Materia**: Programación en la Administración de Servicios para el maestro Javier Sánchez Acosta


**Nota**: Este es un proyecto académico desarrollado para fines educativos. Se recomienda realizar pruebas exhaustivas antes de implementar en entornos de producción u algun otro.
