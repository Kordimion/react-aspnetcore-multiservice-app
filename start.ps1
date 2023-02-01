
Param
(
	[parameter(Mandatory=$false)][string]$Mode="up"
)

$Projectpath = Convert-Path .

try{
	$res =Get-Process 'com.docker.proxy' -ErrorAction SilentlyContinue
	if([string]::IsNullOrEmpty($res)){
		Write-Host "DOCKER is not running. Visit and download https://docs.docker.com/docker-for-windows/install/ " -fore red
		Set-Location -Path $Projectpath
		exit -1
	}
	Set-Location -Path ./src
	$ResultSearch = docker ps | Select-String -Pattern "identityapy"
	if(-Not [string]::IsNullOrEmpty($ResultSearch)){
		Write-Host "Stoped container: docker-compose  down"
		docker-compose down
		docker-compose -f docker-compose.elk.yml down

	}
    if($Mode -eq "down"){
		docker-compose -f docker-compose.misc.yml down
		docker-compose -f docker-compose.elk.yml down
		Set-Location -Path $Projectpath
		exit 0
	}
	


	#Check docker folder sharing
	$PostgresFolder = $Projectpath +"\src"
	$Opts = "-v ${PostgresFolder}:/prj "
	Write-Host "Check shared project folder: "$PostgresFolder
	Write-Host "cmd: docker run --rm ${Opts} alpine ls /prj"

	$IsFolderSharing = $false
	Invoke-Expression -Command "docker run --rm ${Opts} alpine ls /prj" | ForEach-Object {
		Write-Host $_
		IF ($_.Contains("ShopManager.sln")){
			$IsFolderSharing = $true
		}
	}
	Write-Host $IsFolderSharing
	if(-Not $IsFolderSharing){
		Write-Host "Alpine container haven't access to the solution file Shop Manager.sln. Please check docker folder sharing setup."
		Set-Location -Path $Projectpath
		exit
	}
	Write-Host $Mode

	if($Mode -eq "build"){
		docker-compose --env-file ./.env.win build  	
	}
	#Clean log folder
	$LogPath=$Projectpath+"/src/logs"
	if (Test-Path -Path $LogPath) {
		Write-Host "Remove old log"
		Remove-Item -Recurse -Path $LogPath -Force
	}

	New-Item -ItemType Directory -Force -Path $LogPath
	$LogPath=$Projectpath+"/src/logs/nginx"
	New-Item -ItemType Directory -Force -Path $LogPath
	Write-Host "docker-compose  start"
	docker-compose -f docker-compose.misc.yml up -d
	docker-compose -f docker-compose.elk.yml up -d
	docker-compose --env-file ./.env.win up 
	
}
catch {
  
  Write-Host "An error occurred:" -fore red
  Write-Host $_ -fore red
  Write-Host "Stack:"
  Write-Host $_.ScriptStackTrace
  $ExitCode = -1
}

Set-Location -Path $Projectpath
exit $ExitCode