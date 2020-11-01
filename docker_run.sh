#!/bin/bash
docker build -t jenkins2 .
docker run --name=jobs -itd -p 8080:8080 jenkins2
sleep 40
docker exec jobs  jenkins-jobs --conf /etc/jenkins_jobs/jenkins_jobs.ini --user=admin --password=admin123 update jobs

