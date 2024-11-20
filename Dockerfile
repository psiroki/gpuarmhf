FROM debian:buster-slim
# FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Europe/Budapest
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg --add-architecture armhf && \
  apt-get -y update  \
  && apt-get -y install \
    build-essential \
	scons \
	sudo \
	crossbuild-essential-armhf \
	libvpx-dev:armhf \
	libsdl1.2-dev:armhf \
	libsdl2-dev:armhf \
	libsdl2-image-dev:armhf \
	libsdl2-mixer-dev:armhf \
	libsdl2-ttf-dev:armhf \
	libsdl2-net-dev:armhf \
	libcurl4-openssl-dev:armhf \
	libgles2:armhf \
	libopenal-dev:armhf \
	libpng-dev:armhf \
        libfreetype6-dev:armhf \
	nano vim git curl wget unzip cmake \
  && rm -rf /var/lib/apt/lists/*

#	and libgles-dev:arm64 someday

RUN mkdir -p /workspace; ln -s /usr/local/include /usr/include/sdkdir
WORKDIR /root

# COPY my283/include /usr/local/include/
# COPY my283/include /usr/include/
# COPY my283/lib /usr/lib/
COPY cross-compile-ldd /usr/bin/aarch64-linux-gnu-ldd
COPY freetype-config /usr/bin/freetype-config
COPY setup-env.sh .
RUN cat setup-env.sh >> .bashrc

VOLUME /workspace
WORKDIR /workspace

ENV CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
ENV PREFIX=/usr
ENV PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig/:/usr/local/lib/pkgconfig/
ENV CC="arm-linux-gnueabihf-gcc"
ENV CXX="arm-linux-gnueabihf-g++"

CMD ["/bin/bash"]
