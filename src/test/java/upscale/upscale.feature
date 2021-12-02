Feature: web 1


@cnn
Scenario: testingEnvVars
  Given driver "https://www.cnn.com"
  * delay(1000)


@login
Scenario: testingEnvVars
  Given driver MY_UPSCALE_WORKBENCH
  Then print "MY_UPSCALE_WORKBENCH is "+MY_UPSCALE_WORKBENCH
  Then print "MY_UPSCALE_EMAIL is "+MY_UPSCALE_EMAIL
  Then print "MY_HOME_DIRECTORY is "+MY_HOME_DIRECTORY
  Then print "MY_HOME_DIRECTORY is "+MY_HOME_DIRECTORY
  Then print "MY_GITHUB_TOKEN is "+MY_GITHUB_TOKEN
  Then print "MY_GITHUB_USERNAME is "+MY_GITHUB_USERNAME
  Then print "NOW is "+NOW 

  * input('input[id=email]', MY_UPSCALE_EMAIL)
  * input('input[id=password]', MY_UPSCALE_PASSWORD)
  When click('input[type=submit]')
  * delay(5000)

