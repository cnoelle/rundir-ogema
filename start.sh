#!/bin/bash

#
# Start OGEMA with default configuration (Equinox OSGi and no security)
#

LAUNCHER=${OGEMA_LAUNCHER:-./ogema-launcher.jar}
CONFIG=${OGEMA_CONFIG:-config/config.xml}
PROPERTIES=${OGEMA_PROPERTIES:-config/ogema.properties}
OPTIONS=$OGEMA_OPTIONS
JAVA=${JAVA_HOME:+${JAVA_HOME}/bin/}java
EXTENSIONS=bin/ext$(find bin/ext/ -iname "*jar" -printf :%p)
VMOPTS="$VMOPTS -cp $LAUNCHER:$EXTENSIONS"

# Determine java version (with result 1 for version <= 8)
jver=$($JAVA -version 2>&1 |head -n1 |cut -d'"' -f2)
MAJOR_VERSION=${jver%%.*}
if [[ $MAJOR_VERSION -ge 9 ]]; then
  if [[ $MAJOR_VERSION -lt 11 ]]; then
    VMOPTS="--add-modules java.xml.bind,jdk.unsupported ${VMOPTS}";
  else
    # starting with JDK11, JAXB is no longer part of the standard libraries - using eclipse moxy instead
    JAVA="$JAVA -Djavax.xml.bind.JAXBContextFactory=org.eclipse.persistence.jaxb.JAXBContextFactory"
    CONFIG="$CONFIG config/config11_fragment.xml"
  fi
fi

if [[ " $@ " =~ --verbose ]]; then
VMOPTS="$VMOPTS -Dequinox.ds.debug=true -Dequinox.ds.print=true"
echo $JAVA $VMOPTS org.ogema.launcher.OgemaLauncher --config $CONFIG --properties $PROPERTIES $OPTIONS "$@"
fi

while true; do
    $JAVA $VMOPTS org.ogema.launcher.OgemaLauncher --config $CONFIG --properties $PROPERTIES $OPTIONS "$@"
	RETURNCODE=$?
	# 252 = 256 - 4
    if [[ $RETURNCODE != 252 && $RETURNCODE != 124 && $RETURNCODE != 127 ]]; then
        break
    else
		if [ "$OPTIONS" == "${OPTIONS/-restart/}" ]; then
			OPTIONS="$OPTIONS -restart"
		fi
    fi
done
