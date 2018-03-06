param
(
    [Parameter(Mandatory=$true)]
    [string]$url,
    [Parameter(Mandatory=$true)]
    [string]$user,
    [Parameter(Mandatory=$true)]
    [string]$pass,
    [Parameter(Mandatory=$true)]
    [string]$dir,
	[Parameter(Mandatory=$true)]
    [string]$userTJ,
    [Parameter(Mandatory=$true)]
    [string]$passTJ
)

if( -Not (Test-Path -Path $dir ) )
{
    New-Item -ItemType directory -Path $dir
}

$protocol = $url.Substring(0,$url.IndexOf(":"))
$repo = $url.Replace($protocol+"://","")

Set-Location -Path $dir
#Get-ChildItem -Path $dir -Force -Recurse | Remove-Item -Recurse -Force

Write-Output $env:BUILD_REPOSITORY_URI
Write-Output $dir"\"$env:BUILD_REPOSITORY_NAME

Write-Output "Iniciando git clone"

$protocolTJ = $env:BUILD_REPOSITORY_URI.Substring(0,$env:BUILD_REPOSITORY_URI.IndexOf(":"))
$repoTJ = $env:BUILD_REPOSITORY_URI.Replace($protocolTJ+"://","")

$commandTJ = $protocolTJ+"://"+$userTJ+":"+"'$passTJ'"+"@"+$repoTJ


#$commando = "git clone $env:BUILD_REPOSITORY_URI --quiet" 
$commando = "git clone $commandTJ --quiet" 
Invoke-Expression $commando

Write-Output "Git clone Finalizado"

Set-Location -Path $dir"\"$env:BUILD_REPOSITORY_NAME
Invoke-Expression "git checkout master --quiet"

$commando = "powershell .\PowerShell\Comando.ps1"
Invoke-Expression $commando

$command = $protocol+"://"+$user+":"+$pass+"@"+$repo

$commando = "git push --mirror $command --quiet" 
Invoke-Expression $commando