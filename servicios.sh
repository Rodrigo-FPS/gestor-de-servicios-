#!/bin/bash

# Cargar configuración
source config.txt

# Archivo de servicios a revisar
SERVICIOS_FILE="servicios.txt"

# Crear directorio de logs si no existe
mkdir -p "$LOG_PATH"
LOG_FILE="$LOG_PATH/servicios.log"

# Función para enviar notificaciones
enviar_telegram() {
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$1" > /dev/null
}

# Función para registrar log
registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Revisar servicios
while IFS= read -r servicio; do
    if systemctl is-active --quiet "$servicio"; then
        registrar_log "Servicio $servicio activo."
    else
        systemctl start "$servicio"
        if systemctl is-active --quiet "$servicio"; then
            MENSAJE="Servicio $servicio estaba caído y fue reiniciado."
            registrar_log "$MENSAJE"
        else
            MENSAJE="Servicio $servicio no se pudo iniciar."
            registrar_log "$MENSAJE"
        fi
        enviar_telegram "$MENSAJE"
    fi
done < "$SERVICIOS_FILE"
