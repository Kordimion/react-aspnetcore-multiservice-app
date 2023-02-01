
#!/bin/bash
#sudo chmod -R 777 ./deployment/cert &&  cd ./deployment/cert && sudo chmod +x ./buildcrt.sh && ./buildcrt.sh "test1.hlhub.ru.conf"
CONF=$1
if [ "x$CONF" == "x" ]; then
    CONF="localhost.conf"
fi
echo "Config file name:$CONF"

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout aspcertificat.key -out aspcertificat.crt -config $CONF -passout pass:
#openssl pkcs12 -export -out aspcertificat.pfx -inkey aspcertificat.key -in aspcertificat.crt -passout pass:
#openssl verify -CAfile aspcertificat.crt aspcertificat.crt 


#Create root before. you needed rootCA.crt rootCA.key 
openssl genpkey -algorithm RSA -out aspcertificat.key
openssl req -new -key aspcertificat.key -config docker.neva.loc.conf -reqexts req_ext -out aspcertificat.csr
openssl x509 -req -days 730 -CA rootCA.crt -CAkey rootCA.key -extfile docker.neva.loc.conf -extensions req_ext -in aspcertificat.csr -out aspcertificat.crt

#sudo mkdir -p ../Https
#sudo chmod -R 777 ../Https
#sudo ls -la ../Https
sudo mkdir -p /srv/nginx/certs
sudo chmod -R 777 /srv/nginx/certs
#sudo ls -la ../../ui/cert

#cp -rf ./aspcertificat.pfx  ../Https/aspcertificat.pfx
cp -rf ./aspcertificat.crt  /srv/nginx/certs/docker.neva.loc.crt
cp -rf ./aspcertificat.key  /srv/nginx/certs/docker.neva.loc.key

cp -rf ../nginx/proxy.conf /srv/nginx/proxy.conf


