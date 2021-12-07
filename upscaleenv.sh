# Personlize these to your environment
export MY_UPSCALE_WORKBENCH=https://software-academy-test.approuter.stage-use1.js-stage.shoot.live.k8s-hana.ondemand.com
export MY_UPSCALE_EMAIL=ken.lomax@sap.com
export MY_UPSCALE_PASSWORD=Upscale4Me123!
export MY_GITHUB_USERNAME=kennylomax
export MY_GITHUB_TOKEN=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
export MY_DOWNLOAD_FOLDER=/Users/d061192/Downloads
export MY_HOME_DIRECTORY_PREFIX=/Users/d061192/SoftwareAcademy/SandBox/Upscale

#Leave these alone
export NOW=$( date '+%s000' )
export MY_HOME_DIRECTORY=${MY_HOME_DIRECTORY_PREFIX}/${NOW}


if [[ "$OSTYPE" == *"darwin"* ]]; then
  export RUNNING_ON_MAC=true
  brew update
  brew install node
  npm install -g @angular/cli@12.2.10
  ng analytics off
else 
  # Linux for Docker
  export RUNNING_ON_MAC=false
  apt-get update    
  # See https://linuxize.com/post/how-to-install-node-js-on-debian-10/
  curl -sL https://deb.nodesource.com/setup_12.x |  bash -
  apt-get install -y nodejs
  git config --global user.email $MY_GITHUB_USERNAME
  git config --global user.name $MY_GITHUB_TOKEN
fi
