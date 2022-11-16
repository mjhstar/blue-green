FROM ubuntu:18.04
FROM openjdk:16
VOLUME /tmp
ARG JAVA_FILE=build/libs/*SNAPSHOT.jar
COPY ${JAVA_FILE} testproject.jar
ENTRYPOINT ["java", "-Duser.timezone=Asia/Seoul", "-jar","/testproject.jar"]