FROM node:24.15.0-bookworm-slim

RUN sed -i 's/Components: main/Components: main contrib/g' /etc/apt/sources.list.d/debian.sources && \
    apt update && \
    apt install -y \
                    curl \
                    fd-find \
                    gh \
                    git \
                    git-lfs \
                    jq \
                    less \
                    procps \
                    ripgrep \
                    && \
    curl -fsSLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.53.2/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    apt install -y --no-install-recommends \
        fonts-dejavu-core \
        fonts-dejavu-extra \
        fonts-freefont-ttf \
        fonts-ipafont-gothic \
        fonts-kacst \
        fonts-noto-cjk \
        fonts-noto-cjk-extra \
        fonts-thai-tlwg \
        fonts-wqy-microhei \
        fonts-wqy-zenhei \
        ttf-mscorefonts-installer \
        && \
    fc-cache -f -v && \
    npx -y playwright@latest install-deps && \
    npx -y playwright@latest install chrome && \
    npm i -g paperclipai@2026.720.0 && \
# quick patch for https://github.com/paperclipai/paperclip/issues/7771
    sed -i 's/PAPERCLIP_API_URL = apiUrl/PAPERCLIP_API_URL = process.env.PAPERCLIP_API_URL2 ?? apiUrl/g' /usr/local/lib/node_modules/paperclipai/node_modules/@paperclipai/adapter-utils/dist/server-utils.js && \
    npm i -g opencode-ai && \
# change log level
    sed -i 's/level: "debug"/level: process.env.PAPERCLIP_LOG_LEVEL || "debug"/g' /usr/local/lib/node_modules/paperclipai/node_modules/@paperclipai/server/dist/middleware/logger.js && \
    sed -i 's/return "info"/return process.env.PAPERCLIP_LOG_LEVEL || "debug"/g' /usr/local/lib/node_modules/paperclipai/node_modules/@paperclipai/server/dist/middleware/logger.js && \
    rm -rf /tmp/*

USER node

