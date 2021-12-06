package upscale;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.function.Consumer;
import java.nio.file.Paths;
import org.junit.jupiter.api.Test;

class UpscaleTest {

    @Test
    public void runThruTutorial() throws Exception{

        // mvn test -Dtest=UpscaleTest#runThruTutorial -DPath=${PWD} -DRunningOnMac=${RUNNING_ON_MAC}
        // mvn clean test -Dkarate.options="--tags @github" -Dtest=\!UpscaleTest#runThruTutorial 
        // or
        // mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @DownloadPWA"' -Dtest=\!UpscaleTest#runThruTutorial -Dtest=WebRunner
        // docker exec -it -w /src karate mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @login"' -Dtest=\!UpscaleTest#runThruTutorial  -Dtest=WebRunner
        // mvn test -DargLine='-Dkarate.env=docker'  -Dtest=\!UpscaleTest#runThruTutorial -Dkarate.options="--tags @login"
        // Good examples at https://github.com/karatelabs/karate/blob/master/karate-demo/src/test/java/driver/core/test-01.feature
       
      
     
       String path = String.valueOf(System.getProperty("Path"));
        System.out.println("Path is "+path);
        Boolean runningOnMac = Boolean.valueOf(System.getProperty("RunningOnMac"));
        System.out.println("runningOnMac is "+runningOnMac);
        readMeToScript( path+"/README.md", path+"/commands.sh", runningOnMac);
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
        script.append("export TESTING_HOME=$PWD ; ");
  
        for (String l:lines){
            if  (l.startsWith("```commands"))
                commands = true;
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
                
                String c = "mvn test  -Dtest=\\!UpscaleTest#runThruTutorial -DargLine='-Dkarate.env=docker -Dkarate.options=\"--tags @"+clickPathName+ "\"' -Dtest=WebRunner; ";             
                if (runningOnMac)
                     c =  "mvn clean test -Dkarate.options='--tags @"+clickPathName+"' -Dtest=\\!UpscaleTest#runThruTutorial;  ";
                script.append("echo \"\u001b[31m"+c+"\u001b[0m\"; ");
                script.append(c);
                
                script.append("popd; ");
                script.append("pwd; \u001b[0m");
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
        Process process = builder.start();
        StreamGobbler streamGobbler = new StreamGobbler(process.getInputStream(), System.out::println);
        Executors.newSingleThreadExecutor().submit(streamGobbler);
        int exitCode = process.waitFor();
        assert exitCode == 0;
    }
}

class StreamGobbler implements Runnable {
    private InputStream inputStream;
    private Consumer<String> consumer;

    public StreamGobbler(InputStream inputStream, Consumer<String> consumer) {
        this.inputStream = inputStream;
        this.consumer = consumer;
    }

    @Override
    public void run() {
        new BufferedReader(new InputStreamReader(inputStream)).lines()
          .forEach(s ->{
              System.out.println(s);
              if (s.contains("[ERROR]")){
                System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!\n" );
              }              
     } );
    }
}
