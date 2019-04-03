FROM alpine

RUN apk update && \
    apk add curl bash ca-certificates && \
    curl -L 'https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz' > helm.tar.gz && \
    echo 'c1967c1dfcd6c921694b80ededdb9bd1beb27cb076864e58957b1568bc98925a  helm.tar.gz' | sha256sum -c && \
    curl -L 'https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64' > /bin/aws-iam-authenticator && \
    echo '4b8ecce88f4749338e361baf1fba9f8970efed0ac3f58cc40b4979bc0d86eb7b  /bin/aws-iam-authenticator' | sha256sum -c && \
    chmod +x /bin/aws-iam-authenticator && \
    tar xf helm.tar.gz && \
    mv linux-amd64/helm linux-amd64/tiller /bin/ && \
    rm -r helm.tar.gz linux-amd64/ && \
    apk del curl && \
    rm -rf /var/cache/apk/*

COPY ./helm-wrapper /bin/helm-wrapper
RUN adduser -h /home/app -D app
USER app
WORKDIR /home/app
ENTRYPOINT ["/bin/helm-wrapper"]
