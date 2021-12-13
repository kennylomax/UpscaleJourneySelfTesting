function fn() {

    var config = {
        MY_UPSCALE_WORKBENCH: java.lang.System.getenv('MY_UPSCALE_WORKBENCH'), 
        MY_UPSCALE_EMAIL: java.lang.System.getenv('MY_UPSCALE_EMAIL'), 
        MY_UPSCALE_PASSWORD: java.lang.System.getenv('MY_UPSCALE_PASSWORD'), 
        MY_GITHUB_USERNAME: java.lang.System.getenv('MY_GITHUB_USERNAME'), 
        MY_GITHUB_TOKEN: java.lang.System.getenv('MY_GITHUB_TOKEN'), 
        MY_DOWNLOAD_FOLDER: java.lang.System.getenv('MY_DOWNLOAD_FOLDER'), 
        MY_HOME_DIRECTORY: java.lang.System.getenv('MY_HOME_DIRECTORY'), 
        NOW: java.lang.System.getenv('NOW')  
      }
    if (karate.env === 'docker') {
        var driverConfig = {
            type: 'chrome',
            showDriverLog: true,
            start: false,
            beforeStart: 'supervisorctl start ffmpeg',
            afterStop: 'supervisorctl stop ffmpeg',
            videoFile: 'ls /tmp/karate.mp4'
            , webDriverSession: { prefs: { 'xx':'yy', 'download.prompt_for_download': 'false' , 'download.default_directory': '/home/chrome/Downloads' } } 
        };
        karate.configure('driver', driverConfig);
    } else if (karate.env === 'jobserver') {
        karate.configure('driver', {type: 'chrome', showDriverLog: true, start: false});
    } else {
        karate.configure('driver', {type: 'chrome', showDriverLog: true});
    }
    return config;
}