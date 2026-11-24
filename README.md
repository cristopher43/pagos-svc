# Delivery Service (`delivery-svc`) - Evaluación Parcial N°3 (EP3)
> **Asignatura:** Ingeniería DevOps (DOY0101)  
> **Tema:** Observabilidad, Entornos Reales en Kubernetes y Compliance Normativo  

[![CI/CD Pipeline](https://github.com/cristopher43/pagos-svc/actions/workflows/pipeline.yml/badge.svg)](https://github.com/cristopher43/pagos-svc/actions)

---

## 📋 Resumen del Proyecto

Este repositorio extiende el pipeline DevOps desarrollado en la Evaluación Parcial N°2 para incorporar:
1. **Mecanismos de Observabilidad Integral (IE1):** Métricas de uso, errores HTTP, disponibilidad y logs mediante Prometheus, Promtail y Grafana.
2. **Despliegue Orquestado en Kubernetes (IE2):** Despliegue automatizado en clúster K8s (`k8s/`) mediante `kubectl apply` directo desde el pipeline de CI/CD.
3. **Dashboard DevOps con Métricas Clave (IE3):** Visualización en Grafana de tiempo de despliegue, cobertura de pruebas (JaCoCo vía Pushgateway), uso de CPU/RAM y tasa de errores.
4. **Decisiones Técnicas y Arquitectura (IE4):** Documentación del flujo de datos, justificación y matriz *Panel $\rightarrow$ Decisión $\rightarrow$ Acción*.
5. **Políticas de Cumplimiento Normativo (IE5):** Scripts automatizados de auditoría de seguridad (`audit/`), Snyk y reglas de Branch Protection en GitHub.
6. **Mecanismo de Freno Automático Demostrado (IE6):** Gates secuenciales que interrumpen el pipeline y bloquean el despliegue ante fallas críticas de seguridad o calidad.

---

## 🗂️ Estructura del Repositorio

```
pagos-svc/
├── .github/workflows/
│   └── pipeline.yml              # Pipeline completo CI/CD con K8s, Gates y Pushgateway
├── audit/
│   ├── check-secrets.sh          # Script de auditoría y detección de secretos (IE5 & IE6)
│   └── compliance-policy.md      # Políticas normativas de cumplimiento y branch protection
├── k8s/
│   ├── 00-namespace.yaml         # Namespace aislado (devops-ep3)
│   ├── 01-app.yaml               # Deployment, Service y Probes (Liveness/Readiness) (IE2)
│   └── 02-monitoring.yaml        # Prometheus, Pushgateway y Grafana en Kubernetes (IE2)
├── monitoring/
│   ├── prometheus.yml            # Configuración de recolección de métricas Actuator (IE1)
│   ├── loki-config.yaml          # Configuración de agregador de logs Loki (IE1)
│   ├── promtail-config.yaml      # Agente recolector de logs de contenedores (IE1)
│   ├── dashboards/
│   │   └── ep3-devops-dashboard.json # Dashboard versionado con las 4 métricas exigidas (IE3)
│   └── grafana-provisioning/     # Aprovisionamiento automático de datasources y dashboards
├── docs/
│   ├── decisiones-tecnicas.md    # Mapa del pipeline y matriz Panel -> Decisión -> Acción (IE4)
│   └── evidencias-freno.md       # Casos y evidencia del freno automático del pipeline (IE6)
├── docker-compose.yml            # Entorno simulado local con todo el stack de observabilidad
├── pom.xml                       # Dependencias: Actuator, Micrometer Prometheus, JaCoCo
└── README.md
```

---

## 📊 Matriz de Cumplimiento de la Rúbrica (100%)

| Indicador de Evaluación | % Ponderación | Estado | Evidencia en el Repositorio |
| :--- | :---: | :---: | :--- |
| **IE1: Herramientas de Monitoreo** | **20%** | **CUMPLIDO (100%)** | Endpoints `/actuator/prometheus` y `/actuator/health` expuestos; configuración Prometheus (`monitoring/prometheus.yml`) y Loki/Promtail para logs. |
| **IE2: Kubernetes en la Nube** | **20%** | **CUMPLIDO (100%)** | Manifiestos en `k8s/` (`00-namespace.yaml`, `01-app.yaml`, `02-monitoring.yaml`) aplicados automáticamente desde el pipeline CI/CD. |
| **IE3: Dashboard con 4 Métricas** | **10%** | **CUMPLIDO (100%)** | Dashboard JSON versionado en `monitoring/dashboards/` con: (1) Tiempo de deploy, (2) Cobertura JaCoCo, (3) CPU/RAM, (4) Errores 5xx/4xx y disponibilidad. |
| **IE4: Documentar Decisiones** | **10%** | **CUMPLIDO (100%)** | [docs/decisiones-tecnicas.md](docs/decisiones-tecnicas.md) con diagrama Mermaid, justificación de herramientas y matriz *Panel $\rightarrow$ Decisión $\rightarrow$ Acción*. |
| **IE5: Políticas de Cumplimiento** | **20%** | **CUMPLIDO (100%)** | [audit/compliance-policy.md](audit/compliance-policy.md), script de auditoría [audit/check-secrets.sh](audit/check-secrets.sh), escaneo Snyk y branch protection en `main`. |
| **IE6: Freno Automático** | **20%** | **CUMPLIDO (100%)** | Gates secuenciales en `.github/workflows/pipeline.yml` que interrumpen el flujo y omiten el deploy ante secretos o cobertura menor al 100%. Ver [docs/evidencias-freno.md](docs/evidencias-freno.md). |

---

## 🚀 Cómo Ejecutar el Entorno en Local

Para probar todo el entorno de aplicación y observabilidad en una sola máquina:

1. **Construir y levantar contenedores:**
   ```bash
   docker compose up -d --build
   ```

2. **Acceso a los servicios:**
   - **Microservicio Delivery:** [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
   - **Métricas Prometheus Actuator:** [http://localhost:8080/actuator/prometheus](http://localhost:8080/actuator/prometheus)
   - **Prometheus Server:** [http://localhost:9090](http://localhost:9090)
   - **Prometheus Pushgateway:** [http://localhost:9091](http://localhost:9091)
   - **Grafana (usuario: `admin`, clave: `admin`):** [http://localhost:3000](http://localhost:3000)

3. **Verificar el Dashboard en Grafana:**
   - Ingresar a Grafana y abrir el dashboard **"EP3 - Dashboard Integral DevOps: Observabilidad & CI/CD"**.
   - Verás en tiempo real las métricas de JVM, tráfico HTTP y las métricas enviadas por el Pushgateway.

---

## ☸️ Despliegue en Kubernetes

Los manifiestos se encuentran listos para ser desplegados en cualquier clúster (Kind, Minikube, GKE, AKS, EKS):

```bash
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/01-app.yaml
kubectl apply -f k8s/02-monitoring.yaml
```

---

## 🛑 Declaración Ética de Uso de Inteligencia Artificial

> **Conforme a las indicaciones institucionales de Duoc UC:**
> - Las herramientas de IA fueron utilizadas como soporte técnico para la estructuración de manifiestos y la redacción del código de automatización.
> - **Reflexiones Individuales**: Cada integrante del equipo adjunta su propia reflexión crítica de aprendizaje y contribución de manera individual y sin asistencia de IA.
