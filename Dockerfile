FROM adoptopenjdk/openjdk15
RUN mkdir /opt/ogema
WORKDIR /opt/ogema
#ADD https://github.com/ogema/ogema-launcher/releases/download/v1.3.1/ogema-launcher-1.3.1.jar ogema-launcher.jar
COPY ogema-launcher.jar ogema-launcher.jar
COPY config/config* config/
#COPY bin/lib bin/lib
RUN java -jar ogema-launcher.jar -b --output-archive NONE --config config/config.xml config/config11_fragment.xml
COPY config config
CMD java \
    -Djavax.xml.bind.JAXBContextFactory=org.eclipse.persistence.jaxb.JAXBContextFactory \
    -Dorg.osgi.framework.security=osgi -Djava.security.policy=config/all.policy -Dorg.ogema.security=on \
    -Dorg.ogema.non-secure.http.enable=true \
    -jar ogema-launcher.jar \
    --config config/config.xml config/config11_fragment.xml --security config/ogema.policy --use-rundir-only

