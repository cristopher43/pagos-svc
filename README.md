g# Delivery — Microservicio de riesgo delivery

Microservicio correspondiente al **caso caso05 — FoodGo** (Delivery de comida) de la Evaluación Parcial N°1.

| | |
|---|---|
| Asignatura | JVY0101 — Java: Diseño y Construcción de Soluciones Nativas en Nube |
| Stack | Spring Boot 3.3 · Java 21 · Maven · Spring Data JPA · H2 · springdoc-openapi |
| Calidad | JaCoCo cobertura LINE 100% · Cucumber (BDD) alineado a endpoints REST |
| Entrega | Docker / Docker Compose |

## Responsabilidad (SRP)

administra los datos y la lógica del dominio de Delivery del caso caso05 (FoodGo). Su base de datos es una **H2 en memoria** (un solo microservicio por base), cumpliendo aislamiento de datos por dominio.

## Página de presentación

Al ejecutar el servicio, `http://localhost:8080/` muestra la página de presentación del microservicio con documentación y enlaces a:

- **Swagger UI**: `/swagger-ui/index.html`
- **OpenAPI (yaml)**: `/v3/api-docs.yaml`
- **ReDoc**: `/redoc.html`
- **H2 Console**: `/h2-console`

## Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/entregas` | Lista todos los recursos |
| GET | `/api/entregas/{id}` | Obtiene un recurso por id |
| POST | `/api/entregas` | Crea un recurso |
| PUT | `/api/entregas/{id}` | Actualiza un recurso |
| DELETE | `/api/entregas/{id}` | Elimina un recurso |

## Documentación del proyecto

La documentación completa está en la carpeta [`docs/`](docs/):

- [`docs/00_Resumen.md`](docs/00_Resumen.md) — propósito, responsabilidad y tecnologías
- [`docs/01_Arquitectura.md`](docs/01_Arquitectura.md) — componentes, arquitectura y patrones
- [`docs/02_API.md`](docs/02_API.md) — contrato REST y ejemplos curl
- [`docs/03_Pruebas.md`](docs/03_Pruebas.md) — tests unitarios, cobertura y Cucumber
- [`docs/04_Despliegue.md`](docs/04_Despliegue.md)
- [`docs/05_Justificacion.md`](docs/05_Justificacion.md) — justificación del servicio: RF/RNF/seguridad cubiertos, stack y por qué cada tecnología AWS
- [`docs/diagramas/`](docs/diagramas/) — C4 (contexto, contenedores, componentes), secuencia e infraestructura AWS — Docker, Docker Compose e integración

## Cómo ejecutar locmente

```bash
mvn spring-boot:run
```

## Cómo ejecutar con Docker

```bash
docker compose up --build
# http://localhost:8080
```

## Cómo ejecutar las pruebas

```bash
mvn test      # unit tests + Cucumber
mvn verify    # + verificación de cobertura JaCoCo (100% LINE, falla si baja)
```

## Modelo de ramificación
Modelo elegido: GitFlow.
Elegimos GitFlow porque el curso se desarrolla durante todo el semestre y cada entrega (EP01, EP02, EP03) es un hito estable. La rama develop nos permite integrar features de ambos integrantes sin ensuciar main, y la rama hotfix/ nos deja corregir un bug en producción sin interrumpir el trabajo en desarrollo. Además, GitFlow separa explícitamente el código estable (main) del código en integración (develop), lo que da trazabilidad clara del código frente a lo que se pide en las rúbricas del curso.


## Guía de Buenas Prácticas

### Convención de Commits
Formato: `tipo(alcance): descripcion-corta` (en minúsculas y sin tildes).
- **feat**: Nueva funcionalidad (ej. `feat(ui): agregar pie de pagina`)
- **fix**: Corrección de bug (ej. `fix(home): corregir titulo`)
- **docs**: Documentación (ej. `docs: agregar changelog`)
- **chore**: Tareas / CI (ej. `chore(ci): agregar workflow hola mundo`)

### Naming de Ramas
- `feature/<nombre>`: Para nuevas funcionalidades (en minúsculas y con guiones).
- `hotfix/<nombre>`: Para correcciones urgentes en producción.

### Flujo de Merge y Revisión
- Las features y hotfixes siempre entran por Pull Request (PR). Nunca push directo a main o develop.
- Se necesita al menos 1 aprobación del compañero antes de fusionar.
- El revisor debe confirmar los cambios; nunca se fusiona sin revisión. Al finalizar, se borra la rama.

## Conclusiones y Reflexiones

**Reflexión Cristopher Candia:** 
En este trabajo logré entender cómo armar un repositorio desde cero usando comandos en la terminal, lo que hizo el proceso mucho más rápido y directo. Aplicar GitFlow y Docker me dejó claro por qué nunca se debe programar directo en la rama main y la importancia de levantar el microservicio en local antes de subir cambios. Trabajar con Pull Requests y ramas aisladas (features) al principio parece tener muchos pasos, pero asegura que no rompamos el código del equipo. Me quedo con la buena práctica de entender qué hace exactamente cada comando en vez de solo copiarlos, lo que me da mucha más seguridad para las próximas entregas.

**Reflexion Matias Reyes**
Durante este encargo, mi principal contribución fue revisar, aprobar y fusionar los Pull Requests de mi compañero, además de crear y gestionar la rama para el archivo Changelog. Lo que más aprendí en este proceso fue cómo autenticarme y utilizar la herramienta GitHub CLI (gh) directamente desde la terminal, y la importancia de revisar el código paso a paso antes de fusionarlo. Me di cuenta de que el modelo GitFlow ayuda mucho a mantener el orden cuando trabajamos en equipo, ya que nos permite integrar cambios de forma segura sin afectar el trabajo del otro.

**Declaración de IA:** 
Para este encargo utilicé IA (Gemini) asumiendo un rol de tutor técnico. Se utilizó para guiar la ejecución de comandos en PowerShell, explicar la lógica detrás de cada paso de GitFlow y estructurar las convenciones de este documento de forma ordenada.

**Declaración de uso de IA (Matías Reyes):**
Para mi parte del trabajo, utilicé IA (Gemini) como apoyo técnico únicamente para guiarme con la ejecución de comandos de configuración, gestión de Pull Requests y creación de ramas en la terminal, acatando la norma de no usarla para generar esta reflexión.