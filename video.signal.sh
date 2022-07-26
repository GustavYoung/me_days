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
        (omxplayer --genlog --vol -8000 --layer 22 --alpha 1 --dbus_name org.mpris.AdsPlayer3.omxplayer "$entry" >> vflog_$(date +%Y_%m_%d).txt) \
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
        echo "Lapso de tiempo entre anuncios" >> vflog_$(date +%Y_%m_%d).txt;
        done
fi
done