FROM alpine

RUN apk add --no-cache git curl py-pip bash ca-certificates && \
    pip install --no-cache-dir awscli && \
    curl -L 'https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz' > helm.tar.gz && \
    echo '38614a665859c0f01c9c1d84fa9a5027364f936814d1e47839b05327e400bf55  helm.tar.gz' | sha256sum -c && \
    tar xf helm.tar.gz && \
    mv linux-amd64/helm linux-amd64/tiller /bin/ && \
    rm -r helm.tar.gz linux-amd64/ && \
    apk del curl

COPY ./helm-wrapper /bin/helm-wrapper
RUN adduser -h /home/app -D app
USER app
RUN mkdir -p ~/.helm/plugins && helm plugin install https://github.com/databus23/helm-diff --version master
WORKDIR /home/app
ENTRYPOINT ["/bin/helm-wrapper"]
