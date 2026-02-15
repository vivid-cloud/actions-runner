FROM amazon/aws-cli:latest AS aws-cli

FROM ghcr.io/actions/actions-runner:latest

# Modify runner binary to retain custom ACTIONS_RESULTS_URL
RUN sed -i 's/\x41\x00\x43\x00\x54\x00\x49\x00\x4F\x00\x4E\x00\x53\x00\x5F\x00\x52\x00\x45\x00\x53\x00\x55\x00\x4C\x00\x54\x00\x53\x00\x5F\x00\x55\x00\x52\x00\x4C\x00/\x41\x00\x43\x00\x54\x00\x49\x00\x4F\x00\x4E\x00\x53\x00\x5F\x00\x52\x00\x45\x00\x53\x00\x55\x00\x4C\x00\x54\x00\x53\x00\x5F\x00\x4F\x00\x52\x00\x4C\x00/g' /home/runner/bin/Runner.Worker.dll

# Copy all binaries including Python libraries that AWS CLI depends on
COPY --from=aws-cli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=aws-cli /usr/local/bin/ /usr/local/bin/

USER root

# Install Node.js, build-essential, and zstd
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y build-essential nodejs zstd && \
    npx playwright@latest install --with-deps chromium && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R runner:runner /opt/playwright-browsers

USER runner
