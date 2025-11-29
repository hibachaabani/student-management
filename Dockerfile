FROM eclipse-temurin:17-jre-focal

WORKDIR /app

# Copier le jar généré par Maven
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
