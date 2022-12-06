# This file is available under the following license:
# under LGPL 2.1 (LICENSE.TXT) Copyright 2022 ...

FROM tomcat:9-jdk8

LABEL maintainer="..."

ARG target_app
ARG target_workspace

ENV WEB_APP=${target_app}
ENV WORKSPACE=${target_workspace}
ENV CATALINA_OPTS="-Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"
ENV DEEGREE_WORKSPACE_ROOT=/var/lib/tomcat/.deegree

RUN groupadd -r -g 3000 tomcat && useradd -g tomcat -d ${CATALINA_HOME} -s /bin/bash -u 3000 tomcat && \
    chown -R tomcat:tomcat $CATALINA_HOME && \
	mkdir /var/lib/tomcat && \
	chown -R tomcat:tomcat /var/lib/tomcat

COPY ${WEB_APP} /usr/local/tomcat/webapps/${WEB_APP}
RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps/${WEB_APP}

RUN mkdir /tmp/workspaces/

COPY workspaces/${WORKSPACE} /tmp/workspaces/${WORKSPACE}/
COPY workspaces/webapps.properties /tmp/workspaces/webapps.properties
COPY workspaces/console.pw /tmp/workspaces/console.pw
COPY prod/main.xml /tmp/workspaces/${WORKSPACE}/services/main.xml

USER tomcat

EXPOSE 8080

# run tomcat
CMD ["catalina.sh", "run"]
