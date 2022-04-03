
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
        build-essential \
        libssl-dev \
        openssl \
        ca-certificates && \
    DEBIAN_FRONTEND=noninteractive apt-get remove --purge --auto-remove -y && \
    rm -rf /var/lib/apt/lists/*;

WORKDIR /src

ARG SQUID_VERSION=${SQUID_VERSION:-5.4.1}

# Download and extract squid source files
RUN wget http://www.squid-cache.org/Versions/v${SQUID_VERSION%%.*}/squid-$SQUID_VERSION.tar.gz && \
    mkdir squid && \
    tar -C squid --strip-components=1 -xzvf squid-$SQUID_VERSION.tar.gz && \
    rm squid-$SQUID_VERSION.tar.gz;

WORKDIR /src/squid

# Configure squid build
RUN ./configure \
        # Ubuntu specific options
        --prefix=/usr \
        --localstatedir=/var \
        --libexecdir=${prefix}/lib/squid \
        --datadir=${prefix}/share/squid \
        --sysconfdir=/etc/squid \
        --with-default-user=proxy \
        --with-logdir=/var/log/squid \
        --with-pidfile=/var/run/squid.pid \
        # Additional options to enable ssl bumping 
        --enable-ssl \
        --with-openssl \
        --enable-ssl-crtd

# Build and install squid
RUN make -j$(nproc) && \
    make install

WORKDIR /var/log

# Set permissions on log directory
RUN chown -R proxy:proxy squid && \
    chmod 755 squid;

WORKDIR /etc/squid

# Create directory
RUN mkdir ssl_cert && \
    chown proxy:proxy ssl_cert && \
    chmod 700 ssl_cert;

WORKDIR /

# Create and initialize TLS certificates cache directory
RUN /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB && \
    chown proxy:proxy -R /var/lib/ssl_db;

# Specify CA attributes
COPY build/openssl.cfg /etc/ssl
RUN cat /etc/ssl/openssl.cfg >> /etc/ssl/openssl.cnf

EXPOSE 3128 3129

# Entrypoint
COPY build/entrypoint.sh /
RUN chown proxy:proxy entrypoint.sh && \
    chmod +x entrypoint.sh;
ENTRYPOINT [ "./entrypoint.sh" ]