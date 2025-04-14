FROM gradle:8.13-jdk-21-and-23-corretto as builder

WORKDIR /app

# Copy gradle configuration files
COPY build.gradle.kts settings.gradle.kts /app/

# Download dependencies
RUN gradle dependencies --no-daemon

# Copy source code
COPY src /app/src

# Copy data files
COPY trips.csv /app/data/

# Build the application
RUN gradle build --no-daemon

# Create a lightweight runtime image
FROM amazoncorretto:21-alpine-jdk

WORKDIR /app

# Copy the built application
COPY --from=builder /app/build/libs/*.jar /app/app.jar

# Copy data files
COPY --from=builder /app/data /app/data

# Keep the container running for development
CMD ["tail", "-f", "/dev/null"]

# To run the application instead, use:
# CMD ["java", "-jar", "/app/app.jar"]
