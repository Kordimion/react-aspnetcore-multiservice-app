# IdentityServer4 AspNetCore React Docker application

this is a sample development environment for microservice application

## Used technologies/tools:
- IdentityServer4
- C# 10.0 with ASP.NET CORE 7.0 
- create-react-app with typescript
- Nginx proxy
- GitLab CI/CD
- PostgreSQL DB
- Powershell

## Start project localy
for Windows
Prerequisites:
- install [openssl](https://thesecmaster.com/procedure-to-install-openssl-on-the-windows-platform/)
  used version: OpenSSL 3.0.7 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)
```
./start.ps1

or

cd src
docker-compose -f docker-compose.misc.yml up -d
docker-compose --env-file ./.env.win up
docker-compose -f docker-compose.elk.yml up -d
```

For Linux from local gitlab
```
sudo rm -rf nevashop
git clone --branch feature/add_HTTPS git@gitlab.neva.loc:shop/nevashop.git

#Create self signet sertificate
cd ~/nevashop/src/srv/buildcertificate/
sudo chmod +x buildcrt.sh 
sudo ./buildcrt.sh docker.neva.loc
mkdir -p ./rootca
sudo cp -R docker.neva.loc.* ./rootca
ls /rootca
sudo cp -R docker.neva.loc.* /usr/local/share/ca-certificates/
sudo update-ca-certificates -f


docker-compose -f docker-compose.misc.yml up -d --force-recreate
docker-compose --env-file ./.env.linux -f docker-compose.yml -f docker-compose.override.yml up --force-recreate
docker-compose -f docker-compose.elk.yml up -d --force-recreate


```
## Project URL
http://host.docker.internal

http://host.docker.internal/ref

<p align="center">
  <img src="./doc/img/screens.jpg" width="1000" alt="accessibility text">
</p>

## GitLab CI/CD compose files in folder ./deployment/.gitLabci/
Build machine: https://docker.neva.loc

GitLab Docker Runner setup
```
  [runners.docker]
  ...
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache", "/srv/rootca:/rootca:ro"]
```

## reset chrome cache
```
chrome://net-internals/#hsts
chrome:restart
```

Check Self signet certificate for domain
```
cd deployment/TestSSL
docker-compose --env-file ./.env_linux -f docker-compose.sslnginx.yml up
```

## Build frontend only
```
docker-compose --env-file ./.env.win build --force-rm --no-cache --progress plain frontendssl
```
