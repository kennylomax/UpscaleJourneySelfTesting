Tested on Mac.

https://github.com/kennylomax/UpscaleJourneySelfTesting/blob/main/README.md

# Prerequisites

Fetch the file upscaleenv.sh:
``` 
curl https://raw.githubusercontent.com/kennylomax/UpscaleJourneySelfTesting/main/materialTemp/exampleupscaleenv.sh > ~/upscaleenv.sh 
```

# Journey

Personalize your upscalenv.sh contents before applying it to your shell.


```commandsOsxOnly
source ~/upscaleenv.sh 
``` 

```commandsDebianOnly
source /src/upscaleenvdocker.sh 
mkdir -p /home/chrome/Downloads
```

```commandsDebianOnly
curl --user "$MY_GITHUB_USERNAME:$MY_GITHUB_TOKEN" -X POST https://api.github.com/user/repos -d '{"name": "preflightCheck'"$NOW"'", "public": "true"}'
mkdir -p $MY_HOME_DIRECTORY/preflightCheck
pushd $MY_HOME_DIRECTORY/preflightCheck
rm -rf .git
echo "# preflightCheck" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://${MY_GITHUB_USERNAME}:${MY_GITHUB_TOKEN}@github.com/${MY_GITHUB_USERNAME}/preflightCheck${NOW}.git
git push -u origin main
popd

``` 


``` 

Create an Angular app and within that an Angular library:
```commands
mkdir -p $MY_HOME_DIRECTORY
cd $MY_HOME_DIRECTORY
ng new hello-world${NOW} --create-application=false
cd hello-world${NOW}
ng generate library my-first-native-extension
pushd $MY_DOWNLOAD_FOLDER
rm -f application-pwa*.zip
popd

```

Download the latest Upscale PWA Libraries:
```clickpath:download_PWA
YourUpscaleWorkbenchURL -> Consumer Applications -> PWA -> Edit application configuration -> Save & download project
```

Copy the downloaded libs into your Angular app:, which include a thin client SDK, that the PWA uses to access APIs, and the web storefront SDK.

```commands
cp $MY_DOWNLOAD_FOLDER/application-pwa.zip $MY_HOME_DIRECTORY
cd $MY_HOME_DIRECTORY 
unzip application-pwa.zip 
cp -R caas2-webapp/libs  hello-world${NOW}
cd hello-world${NOW}
npm install --save-dev ./libs/upscale-service-client-angular-0.10*.tgz 
npm install --save-dev ./libs/upscale-web-storefront-sdk-0.0.1-BETA.*.tgz 
```

Adjust the compilation rights:

```commands
sed -i -e 's/"inlineSources": true,/"inlineSources": true, "strictNullChecks":false,"noImplicitAny":false,/g' projects/my-first-native-extension/tsconfig.lib.json 
```

Adjust/Create 2 new files:
```commands 
curl https://raw.githubusercontent.com/kennylomax/UpscaleJourneySelfTesting/main/materialTemp/my-first-native-extension.component.ts > projects/my-first-native-extension/src/lib/my-first-native-extension.component.ts
curl https://raw.githubusercontent.com/kennylomax/UpscaleJourneySelfTesting/main/materialTemp/my-first-native-extension.module.ts > projects/my-first-native-extension/src/lib/my-first-native-extension.module.ts
``` 
 
Build and package - !!we should not need npm install --save form-data, but seems necessary on linux?

```commands 
npm install --save form-data
ng build --configuration production
npm pack ./dist/my-first-native-extension
``` 

Check into github

```commands 
curl --user "$MY_GITHUB_USERNAME:$MY_GITHUB_TOKEN" -X POST https://api.github.com/user/repos -d '{"name": "my-first-native-extension'"$NOW"'", "public": "true"}'
rm -rf .git
git init
git add my-first-native-extension-0.0.1.tgz README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://${MY_GITHUB_USERNAME}:${MY_GITHUB_TOKEN}@github.com/${MY_GITHUB_USERNAME}/my-first-native-extension${NOW}.git
git push -u origin main
``` 

Add an Upscale extension and then add to an experience
```clickpath:CreateExtensionAndExperience
YourUpscaleWorkbenchURL -> Advanced Settings -> Extensions -> + -> PWA Native Extension (beta) ->
  Extension name=my-first-native-extension${NOW}
  Key=<the name attribute in your hello-world${NOW}/package.json>
  Location=https://raw.githubusercontent.com/$MY_GITHUB_USERNAME/my-first-native-extension${NOW}/main/my-first-native-extension-0.0.1.tgz
  -> <Take a note of the Extension ID>
  -> Save

YourUpscaleWorkbenchURL -> Experiences -> Coffeefy Mobile Commerce Experience -> Account -> Component + -> Custom ->
  Extension ID=<the Extension ID noted in the previous click path>
  PWA Native Extension Component (beta)=<the name used in your registration hello-world${NOW}/projects/my-first-native-extension/src/lib/my-first-native-extension.module.ts>
  -> Save
``` 

Remove the previousy downloaded PWA 

```commands
pushd $MY_DOWNLOAD_FOLDER
rm -f application-pwa*.zip  
popd

```

Include your new extension in your PWA, then download it:
```clickpath:DownloadNewPWA
YourUpscaleWorkbenchURL -> Settings -> Consumer Applications -> PWA -> Edit Application Configuration -> 
Link experience=Coffeefy Mobile Commerce Experience 
Extensions=NG Coffeefy styling, MyFirstExtension${NOW} 
-> Save & download project
``` 

Compile and run your new PWA
```commands 
pushd $MY_DOWNLOAD_FOLDER
unzip -o application-pwa.zip 
cd caas2-webapp
npm install 
npm start
``` 
Access your site and confirm the stick man is there.
http://localhost:4200/

```clickpath:ConfirmLittleStickman
localhost:4200 -> Account -> confirmYouSeeYourLittleStickMan :)
``` 

# To test this journey automatically:
To verify:
- Download and then personalise upscaleenv.sh as described in prerequisites.
- ConsumerApplication Extensions should have just NG Coffeefy styling
- ConsumerApplication Link Experience should be Coffeefy Mobile Commerce Experience
- Coffeefy Mobile Commerce Experience Account should have no custom component
- remove any previously downloaded pwa zips from your download folder (as they will cause renaming of more recent downloads)
- git clone https://github.com/kennylomax/UpscaleJourneySelfTesting
- cd UpscaleJourneySelfTesting
- mvn clean
- mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD}

# Lessons Learned 
- Design UIs to be easy to use but ALSO easy to test. That means
- having unique text in the text fields, avoiding (unless good reason) fancy dropdowns and popups). 


# To run in Docker

See Docs at https://github.com/karatelabs/karate/wiki/Docker
```

cp ~/upscaleenv.sh  ./upscaleenvdocker.sh 
vi ./upscaleenvdocker.sh 
docker run --name karate --rm -p 5900:5900 --cap-add=SYS_ADMIN -v "$PWD":/src ptrthomas/karate-chrome

open vnc://localhost:5900
docker exec -it -w /src karate bash
source upscaleenvdocker.sh 
git clone https://github.com/kennylomax/UpscaleJourneySelfTesting
cd UpscaleJourneySelfTesting
mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD} -DRunningOnMac=false
or
mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @download_PWA"' -Dtest=\!UpscaleTest#runThruTutorial  -Dtest=WebRunner

mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD}
cp /tmp/karate.mp4 src

```
