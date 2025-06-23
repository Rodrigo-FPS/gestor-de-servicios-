#!/bin/bash

#cargar variables desde el archivo config.txt
source config.txt

#valores por defecto del limite
LIMITE_CPU=70
LIMITE_DISCO=70

#si se pasa un primer argumento, se usa como nuevo limite de cpu
if [ ! -z "$1" ]; then
        LIMITE_CPU=$1
fi

#si se pasa un segundo argumento, se usa como nuevo limite de disco
if [ ! -z "$2" ]; then
        LIMITE_DISCO=$2
fi

#funcion para enviar las notificaciones a telegram
enviar_telegram() {
        MENSAJE="$1"
        curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
                -d chat_id="$CHAT_ID" \
                -d text="$MENSAJE" > /dev/null
}

#funcion para calcular el uso de cpu usando /proc/stat
obtener_cpu() {

        #leer los primeros valores de la linea cpu en /proc/stat
        read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
        prev_idle=$((idle + iowait))
        prev_non_idle=$((user + nice + system + irq + softirq + steal))
        prev_total=$((prev_idle + prev_non_idle))

        #espera un segundo para calcular la diferencia
        sleep 1

        #lee los valores nuevamente
        read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
        idle2=$((idle + iowait))
        non_idle2=$((user + nice + system + irq + softirq + steal))
        total2=$((idle2 + non_idle2))

        #calcula las diferencias
        totald=$((total2 - prev_total))
        idled=$((idle2 - prev_idle))

        #si no hay diferencia, retornar 0
        if [ $totald -eq 0 ]; then
                echo 0
                return
        fi

        #calcular porcentaje de uso de cpu
        cpu_usage=$(( ( (totald - idled) * 100) / totald ))
        echo $cpu_usage
}

#funcion para obtener el uso de disco en la particion raiz
obtener_disco() {
        #leer el uso de disco con df y extraer porcentaje como entero
        df -h / | awk 'NR==2 {print int($5)}'
}

#mensaje inicial con los limites establecidos
echo "Iniciando monitoreo. Limite CPU: $LIMITE_CPU%, Limite Disco: $LIMITE_DISCO%"

#bucle infinito para monitorear periodicamente
while true; do
        #obtener el uso actual de cpu y disco
        CPU_USO=$(obtener_cpu)
        DISCO_USO=$(obtener_disco)

        echo "Uso CPU: $CPU_USO% - Uso Disco: $DISCO_USO%"

        #enviar alerta si el uso de cpu supera el limite
        if [ "$CPU_USO" -ge "$LIMITE_CPU" ]; then
                enviar_telegram "Alerta: Uso de CPU alto: $CPU_USO%"
        fi

        #enviar alerta si el uso de disco supera el limite
        if [ "$DISCO_USO" -ge "$LIMITE_DISCO" ]; then
                enviar_telegram "Alerta: Uso de disco alto: $DISCO_USO%"
        fi

        #esperar 5 segundos antes de volver a comprobar
        sleep 5
done