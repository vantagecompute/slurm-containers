#!/usr/bin/env bash
set -xeuo pipefail

SLURM_DIR="${1:?missing slurm source directory}"
SLURM_RULES_FILE="${SLURM_DIR}/debian/rules"

if ! grep -q -- "--with-s2n=/usr/local" "${SLURM_RULES_FILE}"; then
  sed -i 's|\(dh_auto_configure --\)|\1 --with-s2n=/usr/local|' "${SLURM_RULES_FILE}"
fi

if ! grep -q -- "^override_dh_shlibdeps:" "${SLURM_RULES_FILE}"; then
  cat >> "${SLURM_RULES_FILE}" <<'EOF'

override_dh_shlibdeps:
	dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info
EOF
fi
