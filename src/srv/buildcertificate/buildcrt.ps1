dotnet dev-certs https --cleant
dotnet dev-certs https -ep ./aspcertificat.crt -np --trust --format pem
openssl pkcs12 -export -out aspcertificat.pfx -inkey aspcertificat.key -in aspcertificat.crt -passout pass:
#dotnet dev-certs https -ep ./aspcertificat.pfx

New-Item -Path ".." -Name "https" -ItemType "directory" -Force
New-Item -Path "..\nginx\" -Name "certs" -ItemType "directory" -Force

Copy-Item  -Path ./aspcertificat.pfx -Destination ..\https\aspcertificat.pfx  -Recurse -force

Copy-Item  -Path ./aspcertificat.crt -Destination ..\nginx\certs\localhost.crt  -Recurse -force
Copy-Item  -Path ./aspcertificat.key -Destination ..\nginx\certs\localhost.key  -Recurse -force
