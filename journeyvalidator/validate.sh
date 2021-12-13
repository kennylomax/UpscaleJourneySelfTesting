#!/bin/bash 
mkdir -p /home/chrome/Downloads
chmod 777 /home; chmod 777 /home/chrome; chmod 777 /home/chrome/Downloads 
source ~/upscaleenvdocker.sh 
rm -rf UpscaleJourneySelfTesting
git clone https://github.com/kennylomax/UpscaleJourneySelfTesting
cd UpscaleJourneySelfTesting/journeyvalidator
mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD} -DRunningOnMac=false
# mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @preflightChecks"' -Dtest=\!UpscaleTest#runThruTutorial  -Dtest=WebRunner


