#!/bin/sh

CONFIGFILE=server.config

if [ -d Databases ]; then
	echo "Starting from existing server"
else
	echo "Creating config file..."

	CONFIG_CONTENT=(
		"ServerName $HELIXPLAN_SERVER_NAME"
		"ServerPort 50256"
		"ServiceName \"HPMServer\""
		"DatabaseName $HELIXPLAN_SERVER_DATABASE_NAME"
		"DatabasePassword $HELIXPLAN_SERVER_DATABASE_PASSWORD"
		"ServerPassword $HELIXPLAN_SERVER_ADMIN_PASSWORD"
	)

	echo "" > "$CONFIGFILE"
	for line in "${CONFIG_CONTENT[@]}"; do
		echo "$line" >> "$CONFIGFILE"
		echo $'\n ' >> "$CONFIGFILE"
	done

	cat $CONFIGFILE

	echo "Configuring server..."

	./HPMServer -CreateConfig $CONFIGFILE
	echo "Server configured."
fi

echo "Server started !"
./HPMServer -RunAsProgram
