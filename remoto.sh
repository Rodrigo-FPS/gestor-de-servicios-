#!/bin/bash

# Cargar configuración
source config.txt
# Crear directorio de logs
mkdir -p "$LOG_PATH"
LOG_FILE="$LOG_PATH/remoto.log"

# Archivo de hosts
HOSTS_FILE="host.txt"

# Script que se desea ejecutar remotamente
SCRIPT_LOCAL="hola.sh"

# Función para enviar notificaciones
enviar_telegram() {
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$1" > /dev/null
}

# Función para registrar logs
registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ejecutar en cada host
while IFS= read -r host; do
    echo "Conectando a $host..."
    scp "$SCRIPT_LOCAL" "$host:/tmp/$SCRIPT_LOCAL"
    if [ $? -eq 0 ]; then
        salida=$(ssh "$host" "bash /tmp/$SCRIPT_LOCAL 2>&1")
        echo -e "[$host] Resultado:\n$salida" >> "$LOG_FILE"
        enviar_telegram "Script ejecutado en $host. Resultado guardado en el log."
        registrar_log "Ejecutado correctamente en $host"
    else
        MENSAJE="Error al conectar o copiar el script a $host"
        enviar_telegram "$MENSAJE"
        registrar_log "$MENSAJE"
    fi
done < "$HOSTS_FILE"
