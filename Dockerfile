FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    python2.7

# install jenkins plugins
COPY ./jenkins-plugins /usr/share/jenkins/plugins
RUN while read i ; \
    do /usr/local/bin/install-plugins.sh $i ; \
    done < /usr/share/jenkins/plugins


# allows to skip Jenkins setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false


# Jenkins runs all grovy files from init.groovy.d dir
# use this for creating default admin user
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

VOLUME /var/jenkins_home

RUN apt-get install python-pip -y \
    && pip install pyyaml \
    && pip install jenkins-job-builder
  
RUN apt-get install apt-utils sudo -y \
    && echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins 

COPY jenkins-plugin-cli.sh /usr/local/bin/jenkins-plugin-cli.sh
RUN chmod 755 /usr/local/bin/jenkins-plugin-cli.sh

## Create directory for jenkins-job-builder
RUN mkdir -p  /etc/jenkins_jobs
RUN chmod u+x /etc/jenkins_jobs

## Create jenkins-job-builder config directory
#RUN echo " \
#[jenkins] \n\
#user=$admin \n\
#password=admin123 \n\
#url=http://127.0.0.1:8080 \n\
#query_plugins_info=False \
#"  > /etc/jenkins_jobs/jenkins_jobs.ini

## Create jenkins-job-builder config directory
ADD jenkins_jobs.ini /etc/jenkins_jobs/jenkins_jobs.ini

#USER jenkins
## Create directory for jenkins-job-builder
RUN sudo mkdir -p  /etc/jenkins_jobs
RUN sudo  chmod u+x /etc/jenkins_jobs
ADD job1.yaml /var/jenkins_home/jobs/job1.yaml
ADD job2.yaml /var/jenkins_home/jobs/job2.yaml
#RUN  sh -c "sudo jenkins-jobs test /var/jenkins_home/jobs/job1.yaml"
## Expose jenkins http port
EXPOSE 8080 

## Update the job builder jenkins jobs
#RUN sudo chown -R root:root /etc/jenkins_jobs 
WORKDIR /var/jenkins_home

#RUN sleep 30 && jenkins-jobs --conf /etc/jenkins_jobs/jenkins_jobs.ini --user=admin --password=admin123 update jobs
#RUN sleep 30 && sudo jenkins-jobs --conf /etc/jenkins_jobs/jenkins_jobs.ini update jobs
#RUN sudo chown -R jenkins:jenkins $JENKINS_HOME 
#RUN ["/bin/bash", "-c", "sudo jenkins-jobs update jobs"]
