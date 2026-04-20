#!/usr/bin/env bash
set -euo pipefail

ARCH="$1"
CUDA_VERSION_SHORT="$2"
CUDA_VERSION="$3"
RELEASE_TAG="$4"
RELEASE_HASH="$5"

cd /workspace/llama.cpp

export LIBRARY_PATH="/usr/local/cuda/lib64/stubs${LIBRARY_PATH:+:$LIBRARY_PATH}"
ln -sf /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

BUILD_DIR="build-${ARCH}"

cmake -B "${BUILD_DIR}" -S . -G Ninja \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES="${ARCH}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DGGML_NATIVE=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath-link,/usr/local/cuda/lib64/stubs" \
  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath-link,/usr/local/cuda/lib64/stubs"

cmake --build "${BUILD_DIR}" --config Release -j"$(nproc)"

OUT_DIR="/workspace/binaries/cuda-${CUDA_VERSION_SHORT}/${ARCH}"
mkdir -p "${OUT_DIR}"

cp -r "${BUILD_DIR}/bin/"* "${OUT_DIR}/" || true

find "${OUT_DIR}/" -type f -executable ! -name "*.so*" -exec strip {} \; 2>/dev/null || true

{
  echo "llama.cpp version: ${RELEASE_TAG}"
  echo "CUDA version: ${CUDA_VERSION}"
  echo "Architecture: ${ARCH}"
  echo "Build date: $(date -u +%Y-%m-%d)"
  echo "Build hash: ${RELEASE_HASH}"
} > "${OUT_DIR}/VERSION.txt"

echo "=== Done: ${ARCH} ==="
ls -lh "${OUT_DIR}/"
