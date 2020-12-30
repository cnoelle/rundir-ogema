@ECHO OFF
REM Start OGEMA using felix as OSGi framework.
setlocal
set LAUNCHER=ogema-launcher.jar
set CONFIG=config/config.xml
set PROPERTIES=config/ogema.properties
REM set OPTIONS="%OPTIONS% -clean"

set EXTENSIONS=bin\ext;bin\ext\jssc-2.8.0.jar;bin\ext\libusb4java-1.2.0-linux-arm.jar;bin\ext\libusb4java-1.2.0-linux-x86.jar;bin\ext\libusb4java-1.2.0-linux-x86_64.jar;bin\ext\libusb4java-1.2.0-windows-x86.jar;bin\ext\libusb4java-1.2.0-windows-x86_64.jar;bin\ext\usb-api-osgi-1.0.2.jar;bin\ext\usb4java-1.2.0.jar;bin\ext\usb4java-javax-1.2.0.jar;bin\ext\zwave4j-0.6-SNAPSHOT.jar
set OGEMA_CLASSPATH=%LAUNCHER%;%EXTENSIONS%
set VMOPTS=%VMOPTS% -cp %OGEMA_CLASSPATH%
set JAVA=java

REM find out java version; in case of java >= 9 add required modules
REM see https://stackoverflow.com/questions/17714681/get-java-version-from-batch-file
for /f tokens^=2-5^ delims^=.+-_^" %%j in ('%JAVA% -fullversion 2^>^&1') do @set "jver=%%j"
REM for java version <= 8 the version returned starts with "1.", e.g. "1.7.0_80-b15", starting from Java 9 it starts with "9", "10", etc.
REM if %jver% GTR 1 @set "JAVA=%JAVA% --add-modules java.xml.bind,jdk.unsupported"
if %jver% GTR 10 (
        REM Java >= 11 does not contain jaxb any more
	@set "CONFIG=%CONFIG% config/config11_fragment.xml"
        @set "JAVA=%JAVA -Djavax.xml.bind.JAXBContextFactory=org.eclipse.persistence.jaxb.JAXBContextFactory"
) else (
        REM Java >= 9 needs special option for jaxb
	if %jver% GTR 1 (
		@set "JAVA=%JAVA% --add-modules java.xml.bind,jdk.unsupported"
))

set FIRST=true
:loop
%JAVA% %VMOPTS% org.ogema.launcher.OgemaLauncher ^
  --config %CONFIG% --properties %PROPERTIES% ^
  %OPTIONS% %*
set /a RETURNCODE=%errorlevel%
if %FIRST%==true (
    @set "OPTIONS=%OPTIONS% -restart"
)
set FIRST=false
if %RETURNCODE%==-4 goto :loop
endlocal
