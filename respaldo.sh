#!/bin/bash

#cargamos variables desde config.txt
source config.txt

#enviar notificacion a telegram
enviar_telegram() {
	NOTIFICACION="$1"
	curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
		-d chat_id="$CHAT_ID" \
		-d text="$NOTIFICACION" > /dev/null
}

#funcion que crea el respaldo
realizar_respaldo() {

	#se define la fecha y nombre de respaldo
	FECHA=$(date '+%Y-%m-%d_%H-%M-%S')
	NOMBRE_ARCHIVO="respaldo_$FECHA.tar.gz"
	RUTA_FINAL="$BACKUP_PATH/$NOMBRE_ARCHIVO"
	
        #verificamos que la ruta a respaldar exista
        if [ ! -d "$RESPALDO_DIR" ]; then
                MENSAJE="Error: la ruta: $RESPALDO_DIR no existe: error generado el: $FECHA"
                enviar_telegram "$MENSAJE"
                return
        fi


	#crear carpeta de destino para respaldos por si no existe
	mkdir -p "$BACKUP_PATH"

	#crear respaldo con tar
	tar -czf "$RUTA_FINAL" -c "$RESPALDO_DIR" 2> /dev/null

	#verificamos si se creo correctamente el respaldo
	if [ -f "$RUTA_FINAL" ]; then
		MENSAJE="Respaldo creado: $RUTA_FINAL"
		echo "$MENSAJE"
		enviar_telegram "$MENSAJE"
	else
		MENSAJE="Error al crear respaldo el $FECHA"
		echo "$MENSAJE"
		enviar_telegram "$MENSAJE"
	fi
}

#mandamos a llamar a la funcion que crea el respaldo
realizar_respaldo
