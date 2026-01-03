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
CONTAINER_NAME="${CONTAINER_NAME:-IMAGE_NAME}"

docker run \
  --rm \
  --platform "$PLATFORM" \
  --name "$CONTAINER_NAME" \
  -v rift:/home/fabo/rift \
  -it "$IMAGE_NAME"
