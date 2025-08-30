FROM maven:3.9.11-eclipse-temurin-21-noble

WORKDIR /usr/src/app

COPY pom.xml /usr/src/app/
COPY ./src/test/java /usr/src/app/src/test/java