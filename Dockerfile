FROM swift:6.2.1-jammy
WORKDIR /root

COPY Package.resolved ./
COPY Package.swift ./
COPY Sources ./Sources
COPY Tests ./Tests

RUN swift build -c release --product NIOFusion

RUN install -d /usr/local/bin && \
    install .build/release/NIOFusion /usr/local/bin/NIOFusion

EXPOSE 7878
CMD ["/usr/local/bin/NIOFusion"]
