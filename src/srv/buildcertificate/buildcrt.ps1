# This worked only for localhost
if (-not(Test-Path -Path rootca/rootCA.crt -PathType Leaf))
{
    Write-Host "Generate root CA"
    New-Item -Path "." -Name "rootca" -ItemType "directory" -Force
    #1)Created key
    openssl genpkey -algorithm RSA -out rootca/rootCA.key -aes-128-cbc      #Input password: blablabla
    #2) Created root 
    openssl req -x509 -new -key rootca/rootCA.key -sha256 -days 3650 -out rootca/rootCA.crt -config rootca.conf
    #3) For windows
    openssl pkcs12 -export -out rootca/rootCA.pfx -inkey rootca/rootCA.key -in rootca/rootCA.crt
    #https://stackoverflow.com/questions/39270992/creating-self-signed-certificates-with-open-ssl-on-windows
    "01" | Out-File -encoding ascii -NoNewline rootca/rootCA.srl
    
    Import-PfxCertificate -FilePath rootca/rootCA.pfx -CertStoreLocation 'Cert:\LocalMachine\Root'
}

if (-not(Test-Path -Path ..\nginx\certs\host.docker.internal.crt -PathType Leaf))
{
    Write-Host "Certificate host.docker.internal.crt not exists"

    openssl genpkey -algorithm RSA -out aspcertificat.key
    openssl req -new -key aspcertificat.key -config host.docker.internal.conf -reqexts v3_req -out aspcertificat.csr
    openssl x509 -req -days 730 -CA rootca/rootCA.crt -CAkey rootca/rootCA.key -extfile host.docker.internal.conf -extensions v3_req -in aspcertificat.csr -out aspcertificat.crt
    openssl pkcs12 -export -out aspcertificat.pfx -inkey aspcertificat.key -in aspcertificat.crt 

    Write-Host "Certificate host.docker.internal.crt generated"

    New-Item -Path ".." -Name "https" -ItemType "directory" -Force
    New-Item -Path "..\nginx\" -Name "certs" -ItemType "directory" -Force

    Copy-Item  -Path ./aspcertificat.pfx -Destination ..\https\host.docker.internal.pfx  -Recurse -force

    Copy-Item  -Path ./aspcertificat.crt -Destination ..\nginx\certs\host.docker.internal.crt  -Recurse -force
    Copy-Item  -Path ./aspcertificat.key -Destination ..\nginx\certs\host.docker.internal.key  -Recurse -force

} else {
    Write-Host "Certificate host.docker.internal.crt exists"
}
