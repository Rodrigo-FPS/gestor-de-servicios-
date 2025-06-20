#!/bin/bash

#cargar las variables desde el archivo config.txt
source config.txt

#crear el directorio de logs
mkdir -p "$LOG_PATH"

#guardar la ruta del archivo de log
LOG_FILE="$LOG_PATH/acciones.log"

#funcion para mandar notificaciones al bot de telegram
enviar_telegram() {
	NOTIFICACION="$1"
	curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
		-d chat_id="$CHAT_ID" \
		-d text="$NOTIFICACION" > /dev/null
}

#funcion que escribe los logs
registrar_log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

#funcion para crear un usuario nuevo
crear_usuario() {
	echo "Usuario a crear:"
	read USUARIO

	#verificar si el usuario ya existe
	if id "$USUARIO" &>/dev/null; then
		echo "El usuario ya existe."
		return
	fi

	#crear el usuario
	useradd "$USUARIO"
	if [ $? -eq 0 ]; then
		echo "Usuario $USUARIO creado correctamente."
		MENSAJE="Se creo el usuario: $USUARIO"
		enviar_telegram "$MENSAJE"
		registrar_log "$MENSAJE"
	else
		echo "Error al crear el usuario."
	fi
}

#funcion para eliminar un usuario
eliminar_usuario() {
	echo "Usuario a eliminar:"
	read USUARIO

	#verificar si el usuario existe
	if ! id "$USUARIO" &>/dev/null; then
		echo "El usuario no existe."
		return
	fi

	#eliminar el usuario
	userdel "$USUARIO"
	if [ $? -eq 0 ]; then
		echo "Usuario $USUARIO eliminado."
		MENSAJE="Se elimino el usuario: $USUARIO"
		enviar_telegram "$MENSAJE"
		registrar_log "$MENSAJE"
	else
		echo "Error al eliminar el usuario."
	fi
}

#funcion para cambiar la contraseña
modificar_usuario() {
	echo "usuario: "
	read USUARIO

	#verificar si el usuario existe
	if ! id "$USUARIO" &>/dev/null; then
		echo "El usuario no existe."
		return
	fi

	#leer nueva contraseña (oculta)
	echo "Escribe la nueva contraseña:"
	read -s CONTRASENA

	#cambiar la contraseña
	echo "$USUARIO:$CONTRASENA" | chpasswd
	if [ $? -eq 0 ]; then
		echo "Contraseña cambiada para $USUARIO."
		MENSAJE="Se cambio la contraseña de: $USUARIO"
		enviar_telegram "$MENSAJE"
		registrar_log "$MENSAJE"
	else
		echo "Error al cambiar la contraseña."
	fi
}

#funcion para mostrar el menu
mostrar_menu() {
	echo ""
	echo "---- GESTIONAR USUARIOS ----"
	echo "1 - Crear usuario"
	echo "2 - Eliminar usuario"
	echo "3 - Cambiar contraseña"
	echo "4 - Salir"
	echo "Elige una opción:"
}

#bucle para el menu
while true; do
	mostrar_menu
	read OPCION

	case "$OPCION" in
		1) crear_usuario ;;
		2) eliminar_usuario ;;
		3) modificar_usuario ;;
		4) exit 0 ;;
		*) echo "Opcion invalida" ;;
	esac
done
