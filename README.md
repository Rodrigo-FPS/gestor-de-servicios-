# Gestor Automatizado de Servicios con Notificación con uso de Bot de Telegram usando API.

Sistema automatizado para la administración de servicios en entornos Linux con notificaciones en tiempo real vía Telegram.


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


# Automated service manager with notifications via the Telegram Bot API

Automated system for Linux service administration with real-time notifications with Telegram API.


## Description

This project provides a complete suite of tools for automated Linux service administration, including user management, service monitoring, automatic backups, and remote script execution. All operations are logged in detail and generate automatic notifications via Telegram.

## Features

- **User Management**: Creation, deletion, and modification of system users
- **Service Monitoring**: Automatic supervision and restart of critical services
- **Backup System**: Automatic generation of tar.gz files with timestamp
- **Remote Execution**: Distribution and execution of scripts on multiple hosts
- **Resource Monitoring**: Continuous monitoring of CPU and disk space
- **Telegram Notifications**: Instant alerts for all system events
- **Complete Logging**: Detailed logging of all operations with timestamp

## Installation

### Prerequisites

- Linux system (Ubuntu/Debian/CentOS)
- Administrator permissions
- Internet connection
- Packages: `curl`, `tar`, `ssh`, `systemctl`

### Quick Installation

```
# Clone the repository
git clone https://github.com/user/service-manager-telegram.git
cd service-manager-telegram

# Make scripts executable
chmod +x *.sh

# Create necessary directories
sudo mkdir -p /var/log/service_management
sudo mkdir -p /backup
```

## Configuration

### 1. Telegram Bot Configuration

1. Create bot with @BotFather on Telegram
2. Get the bot token
3. Get Chat ID by sending a message and querying:
   ```
   https://api.telegram.org/bot<TOKEN>/getUpdates
   ```

### 2. Configuration File

Edit `config.txt`:

```
# Telegram Configuration
TOKEN="your_bot_token"
CHAT_ID="your_chat_id"

# System Paths
LOG_PATH="/var/log/service_management"
RESPALDO_DIR="/home/user/documents"
BACKUP_PATH="/backup"
```

### 3. Service Configuration

Edit `servicios.txt`:
```
ssh
apache2
mysql
nginx
```

### 4. Remote Hosts Configuration

Edit `host.txt`:
```
user@192.168.1.10
admin@company.server.com
root@backup.local
```

## Usage

### Main Scripts

#### User Management
```
sudo ./usuarios.sh
```
Interactive interface to create, delete, and modify users.

#### Service Monitoring
```
./servicios.sh
```
Checks and restarts services defined in `servicios.txt`.

#### Backup System
```
./respaldo.sh
```
Creates compressed backup of configured directory.

#### Remote Execution
```
./remoto.sh
```
Executes `hola.sh` on all configured hosts.

#### Resource Monitoring
```
# Default limits (70% CPU, 70% disk)
./monitoreo.sh

# Custom limits
./monitoreo.sh 80 85
```

### Automation with Cron

```
# Daily backup at 2:00 AM
0 2 * * * /path/to/project/respaldo.sh

# Check services every 5 minutes
*/5 * * * * /path/to/project/servicios.sh

# Continuous monitoring
@reboot /path/to/project/monitoreo.sh &
```

## Architecture

### File Structure

```
service-manager-telegram/
├── usuarios.sh          # User management
├── servicios.sh         # Service monitoring
├── respaldo.sh          # Backup system
├── remoto.sh           # Remote execution
├── monitoreo.sh        # Resource monitoring
├── hola.sh             # Example script
├── config.txt          # Main configuration
├── servicios.txt       # Service list
├── host.txt            # Host list
└── README.md           # This file
```

### Workflow

1. **Configuration Loading**: All scripts load variables from `config.txt`
2. **Operation Execution**: Each script performs its specific function
3. **Log Recording**: All actions are logged with timestamp
4. **Telegram Notification**: Important events are automatically notified

### Log System

Logs are stored in `/var/log/service_management/`:

- `acciones.log`: User management
- `servicios.log`: Service status
- `remoto.log`: Remote execution

Format:
```
2024-01-15 14:30:25 - User john created successfully
2024-01-15 14:35:10 - Service ssh restarted
```

## Detailed Features

### usuarios.sh

- Interactive menu with 4 options
- User existence validation
- Secure password input (hidden)
- Automatic notification of all actions

### servicios.sh

- Automatic reading of service list
- Silent verification with `systemctl`
- Automatic restart of failed services
- Notification only in case of problems

### respaldo.sh

- Unique names based on timestamp
- Source directory verification
- Automatic creation of destination directories
- Validation of successful backups

### remoto.sh

- Secure transfer via SCP
- Remote execution via SSH
- Command output capture
- Connection error handling

### monitoreo.sh

- Precise CPU calculation from `/proc/stat`
- Disk space monitoring
- Configurable limits by parameters
- Alerts only when limits are exceeded

## Troubleshooting

### Common Issues

**Bot doesn't send notifications:**
```bash
# Verify configuration
curl -s "https://api.telegram.org/bot<TOKEN>/getMe"
```

**Services don't restart:**
```bash
# Check sudo permissions
sudo systemctl status <service>
```

**SSH connection error:**
```bash
# Verify key authentication
ssh-copy-id user@host
```

## License

This project is under the MIT License. See the `LICENSE` file for more details.

## Contact

- **Project**: Automated Service Manager
- **Author**: José Antonio Montane Dominguez, Rodrigo Fernando Perez Sanchez y Roberto Perez de la Garza
- **University**: Universidad Veracruzana
- **Subject**: Programming in Service Administration

---

**Note**: This is an academic project developed for educational purposes. Thorough testing is recommended before implementing in production environments or others.
