# ========================================================
# Etapa 1: Construcción (Builder Stage)
# ========================================================
FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Aprovechamiento de cache de dependencias Maven
COPY pom.xml ./
RUN mvn -B -q dependency:go-offline

# Compilación y empaquetado del artefacto omitiendo tests (los tests corren en el job CI)
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ========================================================
# Etapa 2: Entorno de Ejecución (Runtime Stage)
# Optimizado con Alpine Linux y usuario sin privilegios root
# ========================================================
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

# Crear grupo y usuario no root por seguridad (Gobernanza / Least Privilege)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copiar artefacto compilado desde la etapa builder
COPY --from=builder /build/target/*.jar /app/app.jar

# Asignar permisos al usuario no root
RUN chown -R appuser:appgroup /app

# Cambiar a usuario no root
USER appuser

# Exponer puerto del microservicio
EXPOSE 8080

# Healthcheck nativo para orquestadores (Docker Compose / Kubernetes)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 --start-period=25s \
  CMD wget -q --spider http://127.0.0.1:8080/api/entregas || exit 1

# Comando de inicio del microservicio
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
