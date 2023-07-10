# syntax=docker/dockerfile:1.2

# Copyright 2021 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

# BUILDPLATFORM is an automatic platform ARG enabled by Docker BuildKit.
# Represents the plataform where the build is happening, do not mix with
# TARGETARCH
FROM --platform=${BUILDPLATFORM} docker.io/library/node:20-alpine3.16@sha256:f9b54b46639a9017b39eba677cf44c8cb96760ca69dadcc1d4cbd1daea753225 as stage1
RUN apk add bash
WORKDIR /app

COPY package.json package.json
COPY package-lock.json package-lock.json
COPY scripts/ scripts/
COPY patches/ patches/

# TARGETOS is an automatic platform ARG enabled by Docker BuildKit.
ARG TARGETOS
# TARGETARCH is an automatic platform ARG enabled by Docker BuildKit.
ARG TARGETARCH
RUN npm --target_arch=${TARGETARCH} install

COPY . .

ARG NODE_ENV=production
RUN npm run build

FROM docker.io/nginxinc/nginx-unprivileged:1.23-alpine@sha256:a8bb5c0c34e1acff7e2c282d6a4f3982f1f6e0fb692d07755c0cd7c1d0139c62
COPY --from=stage1 /app/server/public /app
