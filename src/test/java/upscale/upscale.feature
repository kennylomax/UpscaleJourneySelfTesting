Feature: UpscaleNativeExtension

Background:
  * def delays = 5000
  * def watchInput = function(loc, v) { waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def watchSubmit = function() { waitFor('input[type=submit]').highlight(); click('input[type=submit]') }
  * def watchFor =  function(loc) {  waitFor(loc).highlight().click()  

@github
Scenario: github
  * driver "https://nodejs.org/en/download/"
  * watchFor( '{a}64-bit')
  * driver "https://github.com/login"
  * watchInput( 'input[name=login]','kennylomax')
  * watchInput( 'input[name=password]','xx!')
  * watchSubmit( )
  * delay(delays)

@logvariables
Scenario: logvariables
  * print "MY_UPSCALE_WORKBENCH is "+MY_UPSCALE_WORKBENCH
  * print "MY_UPSCALE_EMAIL is "+MY_UPSCALE_EMAIL
  * print "MY_HOME_DIRECTORY is "+MY_HOME_DIRECTORY
  * print "MY_UPSCALE_PASSWORD is "+MY_UPSCALE_PASSWORD
  * print "MY_GITHUB_TOKEN is "+MY_GITHUB_TOKEN
  * print "MY_GITHUB_USERNAME is "+MY_GITHUB_USERNAME
  * print "MY_DOWNLOAD_FOLDER is "+MY_DOWNLOAD_FOLDER
  * print "NOW is "+NOW 
  * assert  MY_UPSCALE_WORKBENCH != "" 

@login
Scenario: login
  * driver MY_UPSCALE_WORKBENCH
  * call read('upscale.feature@logvariables')
  * watchInput('input[id=email]', MY_UPSCALE_EMAIL)
  * watchInput('input[id=password]', MY_UPSCALE_PASSWORD)
  * watchSubmit()
  * delay(delays)
  
@download_PWA
Scenario: download_PWA
  * call read('upscale.feature@login')
  * watchFor('{^*:2}Settings')
  * watchFor('{}Consumer Applications')
  * waitFor('{}PWA')
  * rightOf('{}PWA').find('button').click()
  * watchFor('{}Edit application configuration')
  * delay(delays)
  * highlight('{}Save & download project')
  * delay(delays)
  * mouse('{}Save & download project').click()
  * delay(delays)
  * mouse('{}Save & download project').down().up()
  * delay(delays)
  * delay(delays)

@CreateExtensionAndExperience
Scenario: CreateExtensionAndExperience
  * call read('upscale.feature@login')
  * watchFor('{}Advanced Settings')
  * watchFor('a[id=side-navigation-subitem-extensions]')
  * delay(delays)
  * watchFor('div[class=new-button]')
  * watchFor('{}PWA Native Extension (beta)')
  * delay(delays)
  * watchInput("input[placeholder='Extension name']", 'my-first-native-extension'+NOW)
  # this value must match the name from package.json
  * watchInput('input[placeholder=Key]', 'hello-world'+NOW)
  # this must be the github location of the tgz file
  * watchInput('input[placeholder=Location]', 'https://raw.githubusercontent.com/'+MY_GITHUB_USERNAME+'/my-first-native-extension'+NOW+'/main/my-first-native-extension-0.0.1.tgz')
  * delay(delays)
  * watchFor('{}Save')
  * delay(delays)
  * def extensionID = locate('{label}Extension ID').nextSibling.text.trim()
  * print 'extensionID is '+extensionID
  * watchFor('{span}Experiences')
  * watchFor('{div}Coffeefy Mobile Commerce Experience')
  * watchFor('{}Account')
  * watchFor('{}Component')
  * watchFor('{}Custom')
  * watchInput('input[id=extensionId]', extensionID )
  * watchInput('input[id=nativeComponentIdentifier]', 'hello-world')
  * waitFor('{button}Save').click()
  * delay(delays)

@DownloadNewPWA
Scenario: DownloadNewPWA
  * call read('upscale.feature@login')
  * watchFor('{^*:2}Settings')
  * watchFor('{}Consumer Applications')
  * waitFor('{}PWA')
  * rightOf('{}PWA').find('button').click()
  * watchFor('{}Edit application configuration')
  * watchFor('{^}NG Coffeefy styling')
  * watchFor('{span}my-first-native-extension'+NOW)
  * watchInput('body', Key.ESCAPE)
  * delay(delays)
  * watchFor('{}Save')
  * delay(delays)
  * highlight('{}Save & download project')
  * delay(delays)
  * mouse('{}Save & download project').click()
  * delay(delays)
  * delay(delays)
  * mouse('{}Save & download project').down().up()
  * delay(delays)
  * delay(delays)
  * delay(delays)

@ConfirmLittleStickman
Scenario: ConfirmLittleStickman
  * karate.waitForHttp('http://localhost:4200')
  * configure driver = { type: 'chrome', showDriverLog: false, showBrowserLog: false }
  * driver 'http://localhost:4200'
  * watchFor('{button}I Agree')
  * watchFor('{a}Account')
  * watchFor("{p}my-first-native-extension works!" )
  * print("Success!")
