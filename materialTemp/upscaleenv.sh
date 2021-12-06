# Personlize these to your environment
export MY_UPSCALE_WORKBENCH=https://xxx.approuter.stage-use1.js-stage.shoot.live.k8s-hana.ondemand.com 
export MY_UPSCALE_EMAIL=xxx.xxx@sap.com 
export MY_UPSCALE_PASSWORD=xxx 
export MY_GITHUB_USERNAME=xxx
export MY_GITHUB_TOKEN=xxx
export MY_DOWNLOAD_FOLDER=/Users/xxx/Downloads  
export MY_HOME_DIRECTORY_PREFIX=Absolute folder location where this journey should occur

#Leave these alone
export MY_HOME_DIRECTORY=${MY_HOME_DIRECTORY_PREFIX}/${NOW}
export NOW=$( date '+%s000' )
if [[ "$OSTYPE" == *"darwin"* ]]; then
  export RUNNING_ON_MAC=true
else 
  export RUNNING_ON_MAC=false
fi