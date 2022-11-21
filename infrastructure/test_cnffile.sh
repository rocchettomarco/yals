#! /bin/bash

echo -e "\nRoot CA - key"
openssl ecparam -name prime256v1 -genkey -outform pem -out ./cakey.pem

echo -e "\nRoot CA - cert"
openssl req -new -x509 -days 365 -addext "subjectAltName=DNS:ca.yals.com" -addext "certificatePolicies=2.5.29.32.0" -key ./cakey.pem -out ./cacert.pem -outform pem 
#-subj "/C=IT/ST=Italy/L=Verona/O=YALS Srl/OU=R&D/CN=ca.yals.com/emailAddress=itsec@yals.com"

#BACKEND
echo -e "\n*.backend.yals.com - key"
openssl ecparam -name prime256v1 -genkey -outform pem -out ./backendkey.key
echo -e "\n*.backend.yals.com - csr"
openssl req -new -key ./backendkey.key -out ./backend.csr -addext "subjectAltName=DNS:*.backend.yals.com" -addext "certificatePolicies=2.5.29.32.0" -config ./openssl.cnf
echo -e "\n*.backend.yals.com - cert"
openssl ca -in ./backend.csr -out ./backendcert.crt -key ./cakey.pem -config ./openssl.cnf -batch
