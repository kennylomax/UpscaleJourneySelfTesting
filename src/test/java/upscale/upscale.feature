Feature: UpscaleNativeExtension

Background:
  * driver MY_UPSCALE_WORKBENCH
  * def delays = 5

@github
Scenario: github
  * call read('upscale.feature@logvariables')
  * driver "https://github.com"
  * delay(delays)


@logvariables
Scenario: logvariables
  * print "MY_UPSCALE_WORKBENCH is "+MY_UPSCALE_WORKBENCH
  * print "MY_UPSCALE_EMAIL is "+MY_UPSCALE_EMAIL
  * print "MY_HOME_DIRECTORY is "+MY_HOME_DIRECTORY
  * print "MY_UPSCALE_PASSWORD is "+MY_UPSCALE_PASSWORD
  * print "MY_GITHUB_TOKEN is "+MY_GITHUB_TOKEN
  * print "MY_GITHUB_USERNAME is "+MY_GITHUB_USERNAME
  * print "NOW is "+NOW 
  * assert  MY_UPSCALE_WORKBENCH != "" 

@login
Scenario: login
  * call read('upscale.feature@logvariables')
  * input('input[id=email]', MY_UPSCALE_EMAIL)
  * input('input[id=password]', MY_UPSCALE_PASSWORD)
  * click('input[type=submit]')
  * delay(delays)
  
@DownloadPWA
Scenario: DownloadPWA
  * call read('upscale.feature@login')
  * waitFor('{}Consumer Applications').click()
  * waitFor('{}PWA')
  * rightOf('{}PWA').find('button').click()
  * waitFor('{}Edit application configuration').click()
  * highlight('{}Save & download project')
  * mouse('{}Save & download project').down().up()
  * delay(delays)

@CreateExtensionAndExperience
Scenario: CreateExtensionAndExperience
  * call read('upscale.feature@login')
  * waitFor('{}Advanced Settings').click()
  * waitFor('a[id=side-navigation-subitem-extensions]').click()
  * delay(delays)
  * waitFor('div[class=new-button]').click()
  * waitFor('{}PWA Native Extension (beta)').click()
  * delay(delays)
  * input("input[placeholder='Extension name']", 'my-first-native-extension'+NOW)
  # this value must match the name from package.json
  * input('input[placeholder=Key]', 'hello-world'+NOW)
  # this must be the github location of the tgz file
  * input('input[placeholder=Location]', 'https://raw.githubusercontent.com/'+MY_GITHUB_USERNAME+'/my-first-native-extension'+NOW+'/main/my-first-native-extension-0.0.1.tgz')
  * delay(delays)
  * click('{}Save')
  * delay(delays)
  * def extensionID = locate('{label}Extension ID').nextSibling.text.trim()
  * print 'extensionID is '+extensionID
  * waitFor('{span}Experiences').click()
  * waitFor('{div}Coffeefy Mobile Commerce Experience').click()
  * waitFor('{}Account').click()
  * waitFor('{}Component').click()
  * waitFor('{}Custom').click()
  * script('input[id=extensionId]', "_.value = ''")
  * input('input[id=extensionId]', extensionID )
  * script('input[id=nativeComponentIdentifier]', "_.value = ''")
  * input('input[id=nativeComponentIdentifier]', 'hello-world')
  * waitFor('{button}Save').click()
  * delay(delays)

@DownloadNewPWA
Scenario: DownloadNewPWA
  * call read('upscale.feature@login')
  * waitFor('{}Consumer Applications').click()
  * waitFor('{}PWA')
  * rightOf('{}PWA').find('button').click()
  * waitFor('{}Edit application configuration').click()
  * highlight('{^}NG Coffeefy styling')
  * waitFor('{^}NG Coffeefy styling').click()
  * waitFor('{span}my-first-native-extension'+NOW).click()
  * input('body', Key.ESCAPE)
  * delay(delays)
  * waitFor('{}Save').click()
  * delay(delays)
  * highlight('{}Save & download project')
  * delay(delays)
  * mouse('{}Save & download project').down().up()
  * delay(delays)

@ConfirmLittleStickman
Scenario: ConfirmLittleStickman
  * karate.waitForHttp('http://localhost:4200')
  * configure driver = { type: 'chrome', showDriverLog: false, showBrowserLog: false }
  * driver 'http://localhost:4200'
  * waitFor('{button}I Agree').click()
  * waitFor('{a}Account').click()
  * waitFor("{p}my-first-native-extension works!" ).click()
  * print("Success!")
