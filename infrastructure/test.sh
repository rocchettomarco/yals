#! /bin/bash

echo -e "\nRoot CA - key"
openssl ecparam -name prime256v1 -genkey -outform pem -out ./cakey.pem

echo -e "\nRoot CA - cert"
openssl req -new -x509 -days 365 -addext "subjectAltName=DNS:ca.yals.com" -addext "certificatePolicies=2.5.29.32.0" -key ./cakey.pem -out ./cacert.crt -outform pem
