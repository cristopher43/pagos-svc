# Evidencia de Freno Automático en el Pipeline (IE6)

Este documento registra el funcionamiento de los mecanismos de detención automática implementados en el pipeline de GitHub Actions ante incidentes de seguridad o incumplimiento de calidad.

---

## 1. Diseño de Gates en GitHub Actions

El flujo de trabajo define dependencias estrictas entre etapas:

```
[test] -> [security-audit] -> [security-snyk] -> [build] -> [deploy]
```

Si cualquiera de los jobs previos emite un código de salida de error (`exit 1`), los jobs dependientes no se ejecutan y quedan en estado **SKIPPED**.

---

## 2. Prueba de Concepto: Detección de Fuga de Credenciales

Para evidenciar el freno automático, se preparó una rama específica de prueba:

* **Rama:** `demo/falla-critica-seguridad`
* **Commit:** Inyección intencional de un archivo de variables (`audit/test-secret-fail.env`) con un patrón de clave AWS de prueba (`AKIAIOSFODNN7EXAMPLE`).

### Resultado en Pipeline:
1. El job `test` compila y pasa las pruebas unitarias.
2. El job `security-audit` ejecuta `./audit/check-secrets.sh`.
3. El script identifica el patrón de credencial y finaliza con error:
   ```
   [1/3] Auditando código en busca de credenciales, JWT y tokens...
   ::error title=Falla Crítica de Seguridad::Se detectaron posibles secretos hardcodeados
   ❌ [AUDIT GATE FAILED] Falla crítica de cumplimiento detectada.
   Process completed with exit code 1.
   ```
4. Los jobs `build` y `deploy` son cancelados inmediatamente sin ejecutarse.
5. El contenedor nunca es generado ni desplegado en Kubernetes.

---

## 3. Prueba de Concepto: Falla en Cobertura de Código

* **Regla:** El plugin JaCoCo en `pom.xml` exige un mínimo de cobertura de líneas del 100%.
* **Comportamiento:** Si un cambio en el código no incluye su respectiva suite de pruebas unitarias o escenarios Cucumber, la fase `test` (`mvn clean verify`) termina en falla, deteniendo el flujo completo en el primer paso.
