FROM alpine

RUN apk add --no-cache git curl py-pip bash ca-certificates && \
    pip install --no-cache-dir awscli && \
    curl -L 'https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz' > helm.tar.gz && \
    echo 'c1967c1dfcd6c921694b80ededdb9bd1beb27cb076864e58957b1568bc98925a  helm.tar.gz' | sha256sum -c && \
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
