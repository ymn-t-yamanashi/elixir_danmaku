FROM node:22.22.3-bookworm-slim AS node

FROM elixir:1.19.5-otp-28

ARG LOCAL_UID=1000
ARG LOCAL_GID=1000

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    gosu \
    inotify-tools \
    chromium \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/include/node /usr/local/include/node

RUN ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -sf /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN groupadd -g "${LOCAL_GID}" app \
  && useradd -m -u "${LOCAL_UID}" -g "${LOCAL_GID}" app

USER app

RUN mix local.hex --force \
  && mix local.rebar --force

WORKDIR /app

COPY --chmod=755 scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY --chmod=755 scripts/browser_check.sh /usr/local/bin/browser-check.sh

USER root

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["bash"]
