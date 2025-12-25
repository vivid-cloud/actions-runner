FROM amazon/aws-cli:latest AS aws-cli

FROM ghcr.io/actions/actions-runner:latest
COPY --from=aws-cli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=aws-cli /usr/local/bin/aws /usr/local/bin/aws
