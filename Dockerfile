FROM amazon/aws-cli:latest AS aws-cli

FROM ghcr.io/falcondev-oss/actions-runner:latest
COPY --from=aws-cli /usr/local/aws-cli/ /usr/local/aws-cli/
# Copy all binaries including Python libraries that AWS CLI depends on
COPY --from=aws-cli /usr/local/bin/ /usr/local/bin/

USER root

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

USER runner
