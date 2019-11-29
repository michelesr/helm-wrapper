FROM alpine

RUN apk add --no-cache git curl bash ca-certificates && \
    curl -L 'https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz' > helm.tar.gz && \
    echo '7eebaaa2da4734242bbcdced62cc32ba8c7164a18792c8acdf16c77abffce202  helm.tar.gz' | sha256sum -c && \
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
