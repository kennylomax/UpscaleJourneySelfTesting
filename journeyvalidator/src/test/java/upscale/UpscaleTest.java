package upscale;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.util.List;
import java.nio.file.Paths;
import org.junit.jupiter.api.Test;
import java.util.logging.Logger;
import static org.junit.jupiter.api.Assertions.*;

class UpscaleTest {
    final static Logger LOGGER = Logger.getLogger(UpscaleTest.class.getName());


    @Test
    public void runThruTutorial() throws Exception{

        // OSX: 
        // mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD} -DRunningOnMac=true
        // mvn clean test -Dkarate.options="--tags @login" -Dtest=\!UpscaleTest#runThruTutorial 
        // Debian:    
        // mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD} -DRunningOnMac=false  -DargLine='-Dkarate.env=docker'
        // mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @ConfirmLittleStickman"' -Dtest=\!UpscaleTest#runThruTutorial -Dtest=WebRunner
        
        // docker exec -it -w /src karate mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @login"' -Dtest=\!UpscaleTest#runThruTutorial  -Dtest=WebRunner
        // mvn test -DargLine='-Dkarate.env=docker'  -Dtest=\!UpscaleTest#runThruTutorial -Dkarate.options="--tags @login"
        // Good examples at https://github.com/karatelabs/karate/blob/master/karate-demo/src/test/java/driver/core/test-01.feature
       
      
     
        String path = String.valueOf(System.getProperty("Path"));
        System.out.println("Path is "+path);
        Boolean runningOnMac = Boolean.valueOf(System.getProperty("RunningOnMac"));
        System.out.println("runningOnMac is "+runningOnMac);
        readMeToScript( path+"/../README.md", path+"/commands.sh", runningOnMac);
        runCommand("chmod 700 commands.sh");
        runCommand("./commands.sh");
    }

    public void readMeToScript(String fileFrom, String fileTo, boolean runningOnMac)throws Exception{
        StringBuffer script = new StringBuffer();
        List<String> lines = Files.readAllLines(Paths.get(fileFrom));
        boolean commands = false;
        boolean clickpath = false;
        String clickPathName="";
        boolean addedClickpath=false;
        if (!runningOnMac)
            script.append("#!/bin/bash\n "); 
        script.append("export TESTING_HOME=$PWD ; ");
    
        for (String l:lines){
            if  (  l.startsWith("```commands" )){
                if (    runningOnMac && l.startsWith("```commandsDebianOnly" ) ||
                        !runningOnMac && l.startsWith("```commandsOsxOnly" ))
                    ;
                else
                    commands = true;
            }
            else if (l.startsWith("```clickpath"))
                clickpath = true;
            else if (l.startsWith("```")){
                commands=false;
                clickpath=false;
            }
            if ( commands &&  !l.startsWith("```commands")){
                if (l.length()>0){
                    script.append("echo \"\u001b[31mIn $PWD and running \u001b[32m"+l+"\u001b[0m\"; ");
                    script.append(l+"; ");
                }
            }
            else if  ( clickpath &&  l.startsWith("```clickpath:")){
                addedClickpath=false;
                clickPathName=l.substring("```clickpath:".length());
            }
            else if  ( clickpath &&  !l.startsWith("```clickpath") && !addedClickpath){
                addedClickpath=true;

                script.append("echo \"\u001b***[34mRunning clickpath "+l+"***\"; ");
                script.append("pushd ${TESTING_HOME}; ");
                script.append("pwd; ");
                
                if (runningOnMac){
                    String c =  "mvn clean test -Dkarate.options='--tags @"+clickPathName+"' -Dtest=\\!UpscaleTest#runThruTutorial;  ";
                    script.append("echo \"\u001b[31m"+c+"\u001b[0m\"; ");
                    script.append(c);
                }else {
                    String c = "mvn test  -Dtest=\\!UpscaleTest#runThruTutorial -DargLine='-Dkarate.env=docker -Dkarate.options=\"--tags @"+clickPathName+ "\"' -Dtest=WebRunner; ";             
                    script.append("echo \"\u001b[31m"+c+"\u001b[0m\"; ");
                    script.append(c);
                    script.append("mkdir -p /src/journey/$NOW;  cp /tmp/karate.mp4 /src/journey/$NOW/karate_"+clickPathName+".mp4; ");
                }
                
                script.append("popd; ");
                script.append("pwd; ");
            }
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(fileTo));
        writer.write(script.toString());
        writer.close();
    }

    public void runCommand(String s) throws IOException, InterruptedException {
        System.out.println("\u001b[34m"+s+"\u001b[0m" );
        ProcessBuilder builder = new ProcessBuilder();
        builder.command(s.split(" "));   
        builder.redirectErrorStream(true);
        Process process = builder.start();
        BufferedReader reader =  new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
            assertFalse( line.toLowerCase().contains("err!") || 
                line.toLowerCase().contains("[error]") || 
                line.toLowerCase().contains("not found: npm") ||
                line.toLowerCase().contains("fatal: authentication failed") ||
                line.toLowerCase().contains("no such file")
            );
         }
        int exitCode = process.waitFor();
        assert exitCode == 0;
    }
}

