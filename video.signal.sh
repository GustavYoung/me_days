#!/bin/bash
#(R) 2017-2022 Gustavo Santana
#(C) 2017-2022 Mirai Works LLC
sleep 2;
#set -x
#Metodos para el DBUS
#OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.${USER:-root}"
#OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.${USER:-root}.pid"
#export DBUS_SESSION_BUS_ADDRESS=`cat $OMXPLAYER_DBUS_ADDR`
#export DBUS_SESSION_BUS_PID=`cat $OMXPLAYER_DBUS_PID`

TIMER="4";
TXSEC="$(($TIMER * 60))";

VIDEOPATH="/home/uslu/elements/Spots_sin_audio";

Current_day=$(date +%-A);

echo "$Current_day";

if [ $Current_day == Monday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/01_Lunes"
elif [ $Current_day == Tuesday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/02_Martes"
elif [ $Current_day == Wednesday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/03_Miercoles"
elif [ $Current_day == Thursday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/04_Jueves"
elif [ $Current_day == Friday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/05_Viernes"
elif [ $Current_day == Saturday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/06_Sabado"
elif [ $Current_day == Sunday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/07_Domingo"
fi

# Nombre de instancia para que no choque con la de uxmalstream
SERVICE="omxplayer2";

#Arreglo para el alpha channel del omxplayer
#Determinar resolucion de pantalla
resolution=$(tvservice -s | grep -oP '[[:digit:]]{1,4}x[[:digit:]]{1,4} ')
a="1920x1080 "
b="1280x720 "
c="720x480 "
d="320x240 "
#Asignar el valor actual si esta disponible(1)
echo "$resolution"

        if [ "$resolution" == "$a" ]
        then
                boxed="--win 0,0,1920,1080";
        elif [ "$resolution" == "$b" ]; 
        then
                boxed="--win 0,0,1280,720";
        elif [ "$resolution" == "$c" ]; 
        then
                boxed="--win 0,15,720,465";
        elif [ "$resolution" == "$d" ]; 
        then
                exit;
        fi
        echo "$boxed"

# infinite loop!
while true; do
        if ps ax | grep -v grep | grep $SERVICE > /dev/null
        then
        sleep 1;
else
        for entry in $VIDEOPATH/*
        do
        if [[ $Current_day != $(date +%-A) ]]
        then
        echo "dia incorrecto reiniciando servicio $Current_day no es $(date +%-A)" >> vflog_$(date +%Y_%m_%d).txt;
        sudo service AdsPlayer restart;
        fi
        echo "start $entry" >> vflog_$(date +%Y_%m_%d).txt;
        if [[ `lsof | grep $target_fix/parallelads/pl1/` ]]
        then
        sleep 40;
        echo "espera por L activa" >> vflog_$(date +%Y_%m_%d).txt;
        fi
        if [[ `lsof | grep $target_fix/ads/` ]]
        then
        sleep 40;
        echo "espera por anuncio con audio" >> vflog_$(date +%Y_%m_%d).txt;
        fi
	    if [[ `lsof | grep /home/uslu/elements/imagenes-flotantes` ]]
        then
        sleep 40;
        echo "espera por imagen sin audio" >> vflog_$(date +%Y_%m_%d).txt;
        fi
        date >> vflog_$(date +%Y_%m_%d).txt;
        ( cmdpid="$BASHPID";
        (omxplayer --genlog --vol -8000 --layer 22 $boxed --alpha 1 --dbus_name org.mpris.AdsPlayer3.omxplayer "$entry" >> vflog_$(date +%Y_%m_%d).txt) \
        & while ! bash /home/uslu/me_days/fadein.sh;
        do
               echo "Todo listo";
               #exit;
        done
        wait)
	date >> vflog_$(date +%Y_%m_%d).txt;
	echo "Stop $entry" >> vflog_$(date +%Y_%m_%d).txt;
#        clear;
	sleep $TXSEC;
        echo "Lapso de tiempo entre anuncios $TXSEC segundos" >> vflog_$(date +%Y_%m_%d).txt;
        done
fi
done