#!/usr/bin/env bash
# ==============================================================================
# SCRIPT DE AUDITORÍA AUTOMATIZADA DE SEGURIDAD Y SECRETOS (IE5 & IE6)
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo " [AUDIT] Iniciando Verificación de Seguridad y Compliance"
echo "=========================================================="

FAILED=0

# 1. Regla Normativa 1: Detección de Fuga de Secretos, Tokens y Claves Privadas
echo "[1/3] Auditando código en busca de credenciales, JWT y tokens..."
FORBIDDEN_PATTERNS=(
  "AKIA[0-9A-Z]{16}"                         # AWS Access Key
  "ghp_[a-zA-Z0-9]{36}"                      # GitHub Personal Token
  "glpat-[a-zA-Z0-9\-]{20}"                  # GitLab Token
  "xoxb-[0-9]{11}-[0-9]{11}-[a-zA-Z0-9]{24}" # Slack Bot Token
  "-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----"
  "password[[:space:]]*=[[:space:]]*['\"][a-zA-Z0-9!@#\$%^&*]{6,}['\"]"
)

for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
  MATCHES=$(grep -rEn --exclude-dir={.git,target,.idea,node_modules,docs} "$pattern" . || true)
  if [ -n "$MATCHES" ]; then
    echo "::error title=Falla Crítica de Seguridad::Se detectaron posibles secretos hardcodeados con el patrón '$pattern':"
    echo "$MATCHES"
    FAILED=1
  fi
done

if [ $FAILED -eq 0 ]; then
  echo "  ✔ No se detectaron secretos ni llaves privadas en el repositorio."
fi

# 2. Regla Normativa 2: Validación de Dependencias Críticas en pom.xml
echo "[2/3] Verificando integridad y ausencia de versiones vulnerables conocidas..."
if grep -q "log4j-core" pom.xml 2>/dev/null; then
  echo "::error title=CVE Crítico::Se detectó dependencia vulnerable (log4j-core). Interrumpiendo pipeline."
  FAILED=1
else
  echo "  ✔ Dependencias sin componentes no autorizados."
fi

# 3. Regla Normativa 3: Verificación de Prohibición de Contenedores 'root'
echo "[3/3] Validando buenas prácticas en Dockerfile..."
if grep -i "USER root" Dockerfile 2>/dev/null; then
  echo "::error title=Incumplimiento Normativo::El Dockerfile no debe especificar 'USER root'."
  FAILED=1
else
  echo "  ✔ Dockerfile cumple con el estándar de privilegios mínimos."
fi

echo "=========================================================="
if [ $FAILED -ne 0 ]; then
  echo "❌ [AUDIT GATE FAILED] Falla crítica de cumplimiento detectada."
  echo "El pipeline debe interrumpirse inmediatamente para proteger producción."
  exit 1
else
  echo "✅ [AUDIT GATE PASSED] Todas las políticas de seguridad fueron aprobadas."
  exit 0
fi
