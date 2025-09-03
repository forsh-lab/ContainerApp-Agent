FROM alpine:3.22.1
ENV TARGETARCH=linux-x64
ENV USER_ASSIGNED_CLIENT_ID=c83c31d2-488e-4a63-94b6-79b116d6047e

RUN apk add --no-cache python3 python3-dev musl-dev linux-headers py3-pip wget unzip bash curl gcc jq tar icu-libs icu-data-full && \
    apk add --no-cache gcompat

RUN adduser -D agentuser

RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install azure-cli

ENV PATH="/opt/venv/bin:$PATH"

ARG TERRAFORM_VERSION=1.12.1
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /azp
RUN chown -R agentuser:agentuser /azp
RUN chmod 755 /azp

COPY ./start.sh .
RUN chmod +x start.sh

USER agentuser

CMD ["./start.sh"]