# Demostración del Freno Automático del Pipeline (IE6)

Este documento evidencia que ante una falla crítica de seguridad o calidad, **el pipeline de CI/CD se detiene de forma inmediata**, evitando que artefactos comprometidos o defectuosos lleguen a producción.

---

## 1. Arquitectura de Gates Secuenciales

El flujo de GitHub Actions utiliza dependencias estrictas (`needs: [...]`):
- `build` depende de `[test, security-audit, security-snyk]`.
- `deploy` depende exclusivamente de `build` y solo se activa en la rama `main` tras superar todos los análisis previos.

Si cualquiera de las fases falla con código de salida distinto de cero (`exit 1`), los jobs subsiguientes se marcan como **SKIPPED / CANCELLED**.

---

## 2. Escenarios de Prueba de Freno Automático

### Escenario A: Inyección de Secreto en Código (Falla de Seguridad Crítica)
- **Acción**: Se simula un commit en una rama de prueba (`demo-fail-secret`) agregando una variable de credencial simulada en código:
  ```properties
  aws.access.key=AKIAIOSFODNN7EXAMPLE
  ```
- **Comportamiento Esperado del Pipeline**:
  1. Job `test`: Pasa (tests unitarios en verde).
  2. Job `security-audit`: Ejecuta `audit/check-secrets.sh`. Detecta patrón `AKIA[0-9A-Z]{16}` y emite:
     ```
     ::error title=Falla Crítica de Seguridad::Se detectaron posibles secretos hardcodeados
     ❌ [AUDIT GATE FAILED] Falla crítica de cumplimiento detectada.
     Process exited with code 1.
     ```
  3. Jobs `build` y `deploy`: **SKIPPED (Cancelados automáticamente)**.
  4. Ningún contenedor es creado ni desplegado en el clúster.

### Escenario B: Caída de Cobertura de Pruebas (Falla de Calidad)
- **Acción**: Se agrega un método en `EntregaService` sin test unitario asociado.
- **Comportamiento Esperado**:
  1. Job `test`: JaCoCo evalúa la cobertura de líneas. Al estar fijada en `1.00` (100%), el plugin de Maven falla (`Rule violated for bundle delivery-svc: lines covered ratio is 0.96, minimum is 1.00`).
  2. El job `test` se pone en **ROJO**.
  3. Toda la ejecución posterior se detiene de inmediato.
