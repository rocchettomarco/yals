#! /bin/bash

echo -e "\ntls setup"
rm -rf PKI
mkdir PKI
mkdir PKI/certs PKI/csr PKI/private PKI/db PKI/crl PKI/conf
touch PKI/db/index
touch PKI/db/serial
touch PKI/db/crlnumber
echo "01" > PKI/db/serial
cp openssl.cnf PKI/conf

#ROOT
echo -e "\nRoot CA - key"
openssl ecparam -name prime256v1 -genkey -outform pem -out PKI/private/cakey.pem
echo -e "\nRoot CA - cert"
#OID identifier: https://oidref.com/2.5.29.32
openssl req -new -x509 -days 365 -addext "subjectAltName=DNS:ca.yals.com" -addext "certificatePolicies=2.5.29.32.0" -key PKI/private/cakey.pem -out PKI/public/cacert.crt -outform pem -subj "/C=IT/ST=Italy/L=Verona/O=YALS Srl/OU=R&D/CN=ca.yals.com/emailAddress=itsec@yals.com"

#BACKEND
echo -e "\n*.backend.yals.com - key"
openssl ecparam -name prime256v1 -genkey -outform pem -out PKI/private/backendkey.key
echo -e "\n*.backend.yals.com - csr"
openssl req -new -key PKI/private/backendkey.key -out PKI/csr/backend.csr -config PKI/conf/openssl.cnf -addext "subjectAltName=DNS:*.backend.yals.com" -addext "certificatePolicies=2.5.29.32.0" -subj "/C=IT/ST=Italy/L=Verona/O=YALS Srl/OU=R&D/CN=*.backend.yals.com/emailAddress=itsec@yals.com"
echo -e "\n*.backend.yals.com - cert"
openssl ca -in PKI/csr/backend.csr -out PKI/certs/backendcert.crt -config PKI/conf/openssl.cnf -batch

#WWW 
echo -e "www.yals.com - key"
openssl ecparam -name prime256v1 -genkey -outform pem -out PKI/private/privkey1.pem
echo -e "www.yals.com - csr"
openssl req -new -key PKI/private/privkey1.pem -out PKI/csr/www-yals-com.csr -config PKI/conf/openssl.cnf -addext "subjectAltName=DNS:www.yals.com" -addext "certificatePolicies=2.5.29.32.0" -subj "/C=IT/ST=Italy/L=Verona/O=YALS Srl/OU=R&D/CN=www.yals.com/emailAddress=itsec@yals.com"
echo -e "www.yals.com - cert"
openssl ca -in PKI/csr/www-yals-com.csr -out PKI/certs/fullchain1.pem -config PKI/conf/openssl.cnf -batch

cat PKI/db/index
rm -rf tls
mkdir tls
cp PKI/certs/cacert.crt	tls 
cp PKI/certs/cacert.crt tls/chain1.pem
cp PKI/certs/backendcert.crt tls
cp PKI/certs/fullchain1.pem tls 
cp PKI/certs/fullchain1.pem tls/cert1.pem
cp PKI/private/backendkey.key tls 
cp PKI/private/privkey1.pem tls 
rm -rf PKI 

chmod 400 tls/*
