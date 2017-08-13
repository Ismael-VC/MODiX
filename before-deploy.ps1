$ErrorActionPreference = 'Continue';

if(-not [System.String]::IsNullOrWhitespace($env:APPVEYOR_PULL_REQUEST_NUMBER)) {
	return;
}

$tag = $env:APPVEYOR_REPO_BRANCH
if([System.String]::IsNullOrWhitespace($tag)) {
    $tag = "untagged"
}
if (Enter-OncePerDeployment "install_docker_image")
{
	docker stop Modix
	docker rm Modix
	docker pull "cisien/modix:$tag"
	docker run -d -e "Token=$env:ModixToken" -e "ReplToken=$env:ReplServiceToken" -e "StackoverflowToken=$env:SOToken" -e "MODIX_DB_CONNECTION=$env:ConnectionString" --name=Modix -v modix:c:\app\config --restart=always --link=CSDiscord --net=nat "cisien/modix:$tag"
}