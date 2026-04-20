ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      git cmake ninja-build build-essential libssl-dev ca-certificates jq binutils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
