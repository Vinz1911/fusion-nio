FROM swift:6.2.1-jammy
WORKDIR /root

# Copy nio server files
COPY Package.resolved ./
COPY Package.swift ./
COPY Sources ./Sources
COPY Tests ./Tests

# Build NIOMeasure server
RUN swift build -c release --product NIOMeasure

# Run server on exposed port
EXPOSE 7878
CMD [".build/release/NIOMeasure"]
