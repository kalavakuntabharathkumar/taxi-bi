FROM maven:3.9-eclipse-temurin-11 AS b
WORKDIR /a
COPY pom.xml .
COPY src src
RUN mvn -q -DskipTests package
FROM eclipse-temurin:11-jre
COPY --from=b /a/target/taxi-bi-api-1.0.0.jar /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
