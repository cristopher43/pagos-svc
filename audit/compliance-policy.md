# Políticas de Cumplimiento y Auditoría Automatizada (IE5)

Este documento define la matriz de gobernanza y políticas de seguridad automatizadas implementadas en el ciclo de vida del software (DevOps CI/CD) para el microservicio **Delivery Service (`delivery-svc`)**, dando cumplimiento estricto a las exigencias de la **Evaluación Parcial N°3**.

---

## 1. Matriz de Cumplimiento: Política $\rightarrow$ Herramienta $\rightarrow$ Verificación

| Política Normativa | Herramienta / Mecanismo | Nivel de Bloqueo | Verificación en Pipeline |
| :--- | :--- | :--- | :--- |
| **P1: Cero Fuga de Secretos** | Script de Auditoría (`audit/check-secrets.sh`) + Snyk | **Crítico (Exit 1)** | Falla inmediata del pipeline si detecta tokens AWS, GitHub, claves SSH privadas o passwords hardcodeados. |
| **P2: Cobertura Mínima de Pruebas (100%)** | JaCoCo Maven Plugin + Prometheus Pushgateway | **Calidad (Exit 1)** | `mvn clean verify` falla si la cobertura de líneas cae por debajo del 100%. Métrica exportada a Grafana. |
| **P3: Calidad y Deuda Técnica (Quality Gate)** | SonarCloud / SonarQube Scanner | **Calidad (Gate)** | Bloqueo si hay Security Hotspots o vulnerabilidades críticas no resueltas. |
| **P4: Análisis de Dependencias (SCA)** | Snyk Vulnerability Scanner | **Seguridad (High/Critical)** | Evaluación continua de CVEs conocidos en las dependencias de terceros (`pom.xml`). |
| **P5: Protección de Rama Principal** | GitHub Branch Protection Rules | **Gobernanza** | Bloqueo de `push --force` en `main`; requiere Pull Request y status checks en verde (`test`, `security-audit`, `build`). |
| **P6: Principio de Menor Privilegio en K8s** | Kubernetes Resource Quotas & Probes | **Operación** | Verificación de `limits/requests` y `liveness/readiness` en `k8s/01-app.yaml`. Prohibición de usuario root. |

---

## 2. Reglas de Branch Protection en GitHub

Para garantizar la trazabilidad y gobernanza del código (IE5):
1. **Require pull request before merging**: No se permiten commits directos a `main`.
2. **Require status checks to pass before merging**:
   - `Pruebas Unitarias y Cobertura (IE2)`
   - `Auditoría Automatizada de Seguridad y Secretos (IE5)`
   - `Análisis de Seguridad y Gating (IE3)`
   - `Construcción de Imagen Docker Optimizada (IE1)`
3. **Require branches to be up to date before merging**.
4. **Include administrators**: Las políticas aplican para todo el equipo sin excepciones.
