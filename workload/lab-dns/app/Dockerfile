FROM docker.io/library/rust:1.83-alpine3.21 as base
RUN apk add musl-dev libressl-dev libcrypto3 --no-cache
RUN cargo install sccache --version 0.9.0
RUN cargo install cargo-chef --version 0.1.68
ENV RUSTC_WRAPPER=sccache SCCACHE_DIR=/sccache
 
FROM base AS planner
WORKDIR /app
COPY . .
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=$SCCACHE_DIR,sharing=locked \
    cargo chef prepare --recipe-path recipe.json
 
FROM base as builder
WORKDIR /app
COPY --from=planner /app/recipe.json recipe.json
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=$SCCACHE_DIR,sharing=locked \
    cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=$SCCACHE_DIR,sharing=locked \
    cargo build --release

FROM docker.io/library/alpine:3.21 as runtime

USER 9000:9000

ARG APP_NAME
ENV APP_NAME=$APP_NAME

WORKDIR /app
COPY --from=builder /app/target/release/$APP_NAME /app/$APP_NAME

ENTRYPOINT /app/$APP_NAME


