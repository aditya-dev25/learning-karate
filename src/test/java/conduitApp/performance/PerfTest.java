package conduitApp.performance;

import conduitApp.performance.create_tokens.createTokens;
import com.intuit.karate.gatling.javaapi.KarateProtocolBuilder;
import io.gatling.javaapi.core.FeederBuilder;
import io.gatling.javaapi.core.ScenarioBuilder;
import io.gatling.javaapi.core.Simulation;
import static io.gatling.javaapi.core.CoreDsl.*;
import static com.intuit.karate.gatling.javaapi.KarateDsl.*;
import java.util.Iterator;
import java.util.Map;
import java.util.function.Supplier;
import java.util.stream.Stream;

public class PerfTest extends Simulation {

    public PerfTest() {      

        createTokens.createAccessTokens();

        KarateProtocolBuilder protocol = karateProtocol(
            uri("/api/articles/{articleId}").nil()
        );

        protocol.nameResolver = (req, ctx) -> req.getHeader("karate-name");
        protocol.runner.karateEnv("qa");

        Iterator<Map<String, Object>> tokenFeeder =
            Stream.generate((Supplier<Map<String, Object>>) () -> {
            String token = createTokens.getNextToken();
            return Map.of("token", token);
        }).iterator();

        FeederBuilder.FileBased csvFeeder = csv("performance/data/articles.csv").circular();

        ScenarioBuilder createArticle = scenario("Create & Delete Article")
            .feed(csvFeeder)
            .feed(tokenFeeder)
            .exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"));

        {
            setUp(
                createArticle.injectOpen(
                    atOnceUsers(1),
                    nothingFor(4),
                    constantUsersPerSec(2).during(10),
                    constantUsersPerSec(2).during(10),
                    rampUsersPerSec(2).to(10).during(20),
                    nothingFor(5),
                    constantUsersPerSec(1).during(5)
                    )
                .protocols(protocol)
            );
        }
    }
}
