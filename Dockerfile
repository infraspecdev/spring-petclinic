FROM openjdk:17 AS builder

COPY target/spring-petclinic-3.3.0-SNAPSHOT.jar application.jar
RUN java -Djarmode=tools -jar application.jar extract --layers --launcher

FROM openjdk:17

COPY --from=builder application/dependencies/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/application/ ./
COPY opentelemetry-javaagent.jar ./
ENV JAVA_TOOL_OPTIONS="-javaagent:opentelemetry-javaagent.jar"
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
