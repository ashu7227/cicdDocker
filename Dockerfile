FROM openjdk:11 as builder
WORKDIR application
COPY ./pom.xml ./pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY ./src ./src
RUN ["chmod", "+x", "mvnw"]
RUN ./mvnw dependency:go-offline -B
RUN ./mvnw clean package && cp target/cicdDocker-0.0.1-SNAPSHOT.jar cicdDocker-0.0.1-SNAPSHOT.jar
RUN java -Djarmode=layertools -jar cicdDocker-0.0.1-SNAPSHOT.jar extract
#ENTRYPOINT ["java","-jar", "cicdDocker-0.0.1-SNAPSHOT.jar"]
FROM openjdk:11-jre-slim
WORKDIR application

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
