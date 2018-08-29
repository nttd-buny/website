FROM sonarqube:6.7
RUN set -x \
    && wget -O /opt/sonarqube/extensions/plugins/sonar-ldap-plugin-2.2.0.608.jar "https://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-2.2.0.608.jar"
COPY sonar.properties /opt/sonarqube/conf/sonar.properties
