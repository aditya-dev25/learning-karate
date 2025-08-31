package conduitApp.performance;

import com.intuit.karate.gatling.javaapi.KarateProtocolBuilder;
import io.gatling.javaapi.core.ScenarioBuilder;
import io.gatling.javaapi.core.Simulation;
import static io.gatling.javaapi.core.CoreDsl.*;
import static com.intuit.karate.gatling.javaapi.KarateDsl.*;


public class PerfTest extends Simulation {

    public PerfTest() {      
        KarateProtocolBuilder protocol = karateProtocol();

        ScenarioBuilder createArticle = scenario("Create & Delete Article")
            .exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"));

        {
            setUp(
                createArticle.injectOpen(atOnceUsers(1)).protocols(protocol)
            );
        }
    }
}
