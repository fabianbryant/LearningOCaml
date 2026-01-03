#!/usr/bin/env bash

set -eux

ROOT_DIR="$(realpath $(dirname $0))"
ENV="$ROOT_DIR/.env"
TMPL_ENV="$ROOT_DIR/templates/.env"

if ! test -f "$ENV"; then
  cp "$TMPL_ENV" "$ROOT_DIR"
fi

source "$ENV"

PLATFORM="${PLATFORM:-linux/amd64}"
IMAGE_NAME="${IMAGE_NAME:-learning-ocaml}"
BUILD_ROOT="${BUILD_ROOT:-ROOT_DIR}"
BUILD_FILE="${BUILD_FILE:-BUILD_ROOT/Dockerfile}"

docker build \
  --platform "$PLATFORM" \
  -t "$IMAGE_NAME" \
  -f "$BUILD_FILE" \
  "$BUILD_ROOT"
