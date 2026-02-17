userPwd=$1

echo "Generating certificate with openssl, press enter to continue"
read check1
openssl genrsa -des3 -passout pass:$userPwd -out server.pass.key 2048
openssl rsa -passin pass:$userPwd -in server.pass.key -out server.key
rm server.pass.key

echo "Generating server key, when promoted for a password, press enter to skip"
echo "press enter to skip"
read check2
openssl req -new -key server.key -out server.csr

echo "Generating the certificates, press enter to continue"
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

echo "Key will now be encoded in base64 and displayed, use the output for the value of SFDC_SERVER_KEY enviornment variable"
echo "press enter to continue"
read check4
base64 server.key

echo "Deleting keys from local directory, ensure you have copied the base64 encoded key before proceeding"
echo "press enter to continue"
read check4
rm server.csr
rm server.key

echo "Certificate and key generation complete, add server.crt to your connected app in salesforce"