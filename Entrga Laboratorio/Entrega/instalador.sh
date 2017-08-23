
if [ $1 = nonInteractive ];
then instalation.sh $2 $3 $3 false
 #Se hace la instalacion sin vista.
else 

#Instalacion de Zenity para poder usar la parte grafica.
sudo apt-get install zenity


ENTRY=$(zenity --forms --title="Instalador NextCloud" --text="Bienvenido al asistente de instalacion de NextCloud.\n Por favor ingrese su usuario y contrasemia de su motor de base de datos. \n De no contar con una, estos se crearan con los datos que ingrese a continuacion.\n"\
   --add-entry="Usuario:" \
   --add-password="Contrasenia:" \
   --add-password="Confirme la contrasenia:"\
   ) 




case $? in
         0)
	 	user=`echo $ENTRY | cut -d'|' -f1`
		pass=`echo $ENTRY | cut -d'|' -f2`
		checkpass=`echo $ENTRY | cut -d'|' -f3`
;;
         1)
                echo "Se ha detenido la instalacion de NextCloud.";;
        -1)
                echo "Ha ocurrido un error inesperado. Favor de contactar a Soporte Tecnico.";;
esac


if [ $pass != $checkpass ]; then zenity --error \
--text="Las contrasenias no iguales"

else 
	`zenity --info \
	--text="A continuacion seleccione el archivo comprimido que contiene NextCloud.\n Recuerde puede descargar la ultima version de Nextcloud en\n www.nextcloud.com/install/"`

	FILE=`zenity --file-selection --title="Seleccione el archivo comprimido de NextCloud"`
	if [ $FILE = NULL ]; then zenity --error \--text="No se selecciono ningun archivo.\n\n La instalacion de NextCloud se cancelara"
	else instalation.sh $FILE $user $pass true
	fi
fi

fi

