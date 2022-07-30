#!/bin/bash
#(R) 2017-2022 Gustavo Santana
#(C) 2017-2022 Mirai Works LLC
#set -x
#Metodos para el DBUS
#OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.${USER:-root}"
#OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.${USER:-root}.pid"
#export DBUS_SESSION_BUS_ADDRESS=`cat $OMXPLAYER_DBUS_ADDR`
#export DBUS_SESSION_BUS_PID=`cat $OMXPLAYER_DBUS_PID`
#El logic test quedo funcional en el equipo de prueba para la v1.0.0

TIMER="1";
TXSEC="$(($TIMER * 60))";

VIDEOPATH="/home/uslu/elements/Spots_sin_audio";

Current_day=$(date +%-A);

echo "$Current_day";

if [ $Current_day == Monday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Lunes"
elif [ $Current_day == Tuesday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Martes"
elif [ $Current_day == Wednesday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Miercoles"
elif [ $Current_day == Thursday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Jueves"
elif [ $Current_day == Friday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Viernes"
elif [ $Current_day == Saturday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Sabado"
elif [ $Current_day == Sunday ]
then
   VIDEOPATH="/home/uslu/elements/Spots_sin_audio/Domingo"
fi

# Nombre de instancia para que no choque con la de uxmalstream
SERVICE="omxplayer2";

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
        echo "sudo service AdsPlayer restart;"
        fi
        echo "start $entry" >> vflog_$(date +%Y_%m_%d).txt;
        date >> vflog_$(date +%Y_%m_%d).txt;
        ( cmdpid="$BASHPID";
        (echo "omxplayer --genlog --vol -8000 --layer 22 --alpha 1 --dbus_name org.mpris.AdsPlayer3.omxplayer $entry" >> vflog_$(date +%Y_%m_%d).txt) \
        & while ! echo "bash /home/uslu/me_days/fadein.sh";
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