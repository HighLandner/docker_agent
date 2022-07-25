#!/bin/bash

JAVA_VERSION=openjdk-11-jdk
JENKINS_HOME="/var/lib/jenkins/"
mkdir -p $JENKINS_HOME
# "blueocean" "pipeline-utility-steps" "greenballs" "workflow-cps" "gitlab-plugin" "gitlab-api" "gitlab-oauth" "git"
pluginList=("git", "pipeline-model-definition:2.2097.v33db_b_de764b_e", "allure-jenkins-plugin:2.30.2", "ec2:1.68", "aws-device-farm:1.30", "scm-sqs:1.4", "aws-codepipeline:0.45", "codedeploy:1.23", "sonar:2.14", "miniorange-saml-sp:1.0.11")

apt-get update && apt-get install -y ${JAVA_VERSION} wget gpg
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update && apt-get install -y jenkins

while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
    echo "Secrets not found ..."
    sleep 2
done

key=$(cat /var/lib/jenkins/secrets/initialAdminPassword)

while [ ` echo $response | grep 'Authenticated' | wc -l ` = 0 ]; do
  response=` java -jar /var/cache/jenkins/war/WEB-INF/lib/cli-*.jar -s http://localhost:8080 -auth admin:$key who-am-i `
  echo $response
  echo "Jenkins not started yet, waiting for 2 seconds ..."
  sleep 2
done

for plugin in ${pluginList[@]}; do 
  java -jar /var/cache/jenkins/war/WEB-INF/lib/cli-*.jar -s http://localhost:8080 -auth admin:$key install-plugin $plugin
done

echo "Finish" initialAdminPassword = ${key}
