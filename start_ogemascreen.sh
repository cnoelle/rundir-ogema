#!/bin/bash
#Start the OGEMA-framework in a new screen

ogemaPath="/home/pi/ogema"
name="ogema"
echo "Starting OGEMA ..."
screen -dmS $name
screen -S $name -X stuff "cd $ogemaPath/\n"
screen -S $name -X stuff "./start_security.sh -uro\n"
echo "OGEMA started. Use 'screen -r $name' to attach to console"
