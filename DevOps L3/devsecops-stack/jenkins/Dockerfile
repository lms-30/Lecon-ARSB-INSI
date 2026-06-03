FROM jenkins/jenkins:lts-jdk21

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs

USER root

# Dépendances système + Trivy via apt (plus fiable que GitHub releases)
RUN apt-get update && apt-get install -y \
    curl wget git unzip docker.io jq gnupg apt-transport-https \
    && curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key \
       | gpg --dearmor -o /usr/share/keyrings/trivy.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
       > /etc/apt/sources.list.d/trivy.list \
    && apt-get update && apt-get install -y trivy \
    && rm -rf /var/lib/apt/lists/*

# Vault CLI
RUN wget --tries=5 --retry-connrefused --waitretry=10 \
        -O /tmp/vault.zip \
        https://releases.hashicorp.com/vault/1.15.6/vault_1.15.6_linux_amd64.zip \
    && unzip /tmp/vault.zip -d /usr/local/bin/ \
    && rm /tmp/vault.zip \
    && chmod +x /usr/local/bin/vault

RUN usermod -aG docker jenkins || true

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY casc/ /var/jenkins_home/casc_configs/
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

EXPOSE 8080 50000
