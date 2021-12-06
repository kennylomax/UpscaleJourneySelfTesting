package upscale;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;

/**
 *
 * Used if running in docker
 */
public class WebRunner {
    @Test
    void test() {
        Results results = Runner.path("classpath:upscale").parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }     
   
}
