# Build stage

FROM maven:amazoncorretto as BUILD
#FROM maven:3.8.3-openjdk-17
WORKDIR /app
COPY .  .
RUN mvn package -DskipTests 


# Run stage
FROM amazoncorretto as RUN
WORKDIR /run
COPY --from=BUILD /app/target/demo-0.0.1-SNAPSHOT.jar demo.jar
EXPOSE 8080

ARG USER=notroot
#RUN mkdir /home/notroot
ENV HOME /home/notroot
RUN yum -y install shadow-utils
RUN adduser -d /home/notroot notroot 
RUN chown $USER:$USER /run/demo.jar
RUN yum erase -y shadow-utils
USER $USER


CMD java  -jar /run/demo.jar
