#!/usr/bin/env bash
set -xeuo pipefail

S2N_REPO_URL="${S2N_REPO_URL:-https://github.com/aws/s2n-tls.git}"
S2N_GIT_REF="${S2N_GIT_REF:-}"
S2N_SRC_DIR="$(mktemp -d /tmp/s2n-tls.XXXXXX)"

cleanup() {
  rm -rf "${S2N_SRC_DIR}"
}
trap cleanup EXIT

git clone --depth 1 "${S2N_REPO_URL}" "${S2N_SRC_DIR}"

if [ -n "${S2N_GIT_REF}" ]; then
  git -C "${S2N_SRC_DIR}" fetch --depth 1 origin "${S2N_GIT_REF}"
  git -C "${S2N_SRC_DIR}" checkout --detach FETCH_HEAD
fi

cmake "${S2N_SRC_DIR}" -B "${S2N_SRC_DIR}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON
cmake --build "${S2N_SRC_DIR}/build" -j "$(nproc)"
cmake --install "${S2N_SRC_DIR}/build"
ldconfig
