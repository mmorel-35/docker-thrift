FROM ubuntu@sha256:77906da86b60585ce12215807090eb327e7386c8fafb5402369e421f44eff17e

ENV THRIFT_VERSION v0.19.0

ENV BUILD_DEPS "automake bison curl flex g++ libboost-all-dev libevent-dev libssl-dev libtool make pkg-config"
  
RUN	apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${BUILD_DEPS} \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -k -sSL "https://github.com/apache/thrift/archive/${THRIFT_VERSION}.tar.gz" -o thrift.tar.gz \
	&& mkdir -p /usr/src/thrift \
	&& tar zxf thrift.tar.gz -C /usr/src/thrift --strip-components=1 \
	&& rm thrift.tar.gz

WORKDIR /usr/src/thrift

RUN     ./bootstrap.sh \
	&& ./configure --disable-libs \
	&& make \
	&& make install

WORKDIR /

RUN	rm -rf /usr/src/thrift \
	&& apt-get purge -y --auto-remove ${BUILD_DEPS} \
	&& rm -rf /var/cache/apt/* \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* \
	&& rm -rf /var/tmp/*

CMD [ "thrift" ]
