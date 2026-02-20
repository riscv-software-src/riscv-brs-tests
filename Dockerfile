# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set maintainer label using ARG (can be set during build time)
ARG MAINTAINER="sunilvl@oss.qualcomm.com"
LABEL maintainer="${MAINTAINER}"

# Set working directory
WORKDIR /workspace

# Install packages in a single RUN command to reduce layers
# Clean up the cache to reduce image size
# Separate installations by their ecosystems for better readability and caching
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
    	apt-get install -y --no-install-recommends \
	acpica-tools \
	automake \
	autopoint \
	autotools-dev \
	bc \
	bison \
	bzip2 \
	cpio \
	curl \
	dosfstools \
	flex \
	gawk \
	gcc \
	gcc-riscv64-linux-gnu \
	gdisk \
	gettext \
	g++ \
	iasl \
	libglib2.0-dev \
	libpixman-1-dev \
	libssl-dev \
	libtool \
	make \
	mtools \
	ninja-build \
	openssl \
	patch \
	python3 \
	python3-venv \
	rsync \
	stgit \
	unzip \
	uuid-dev \
	vim \
	wget

SHELL ["bash", "-c"]
