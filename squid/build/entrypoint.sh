#!/bin/sh

# Check myCA.pem exists 
if [ ! -f /etc/squid/ssl_cert/myCA.pem ]; then
    # Create self-signed certificate
    openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 \
    -subj "/CN=Squid/O=Squid/OU=Squid/C=SQ" \
    -extensions v3_ca \
    -keyout /etc/squid/ssl_cert/myCA.pem \
    -out /etc/squid/ssl_cert/myCA.pem
    echo "created myCA.pem";
    # Create a DER-encoded certificate to import into users' browsers
    openssl x509 -in /etc/squid/ssl_cert/myCA.pem -outform DER -out /etc/squid/ssl_cert/myCA.der;
    echo "created myCA.der";
else
    echo "myCA.pem already exists...";
    # Check myCA.der exists 
    if [ ! -f /etc/squid/ssl_cert/myCA.der ]; then
    # Create a DER-encoded certificate to import into users' browsers
    openssl x509 -in /etc/squid/ssl_cert/myCA.pem -outform DER -out /etc/squid/ssl_cert/myCA.der;
    echo "created myCA.der";
    else
        echo "myCA.der already exists...";
    fi;
fi;

# Start squid
squid -N -D -d1;