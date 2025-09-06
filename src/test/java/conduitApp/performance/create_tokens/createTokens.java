package conduitApp.performance.create_tokens;
import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.HashMap;
import java.util.Map;

import com.intuit.karate.Runner;

public class createTokens {

    private static final ArrayList<String> tokens = new ArrayList<>();
    private static final AtomicInteger counter = new AtomicInteger(0);

    private static String[] emails = {
        "darrick.zemlak@yahoo.com",
        "bret.krajcik@gmail.com",
        "landon.gerlach@hotmail.com",
        "randell.kreiger@hotmail.com"
    };

    private static String[] passwords = {
        "utc4vv27v85e93gf",
        "t24231dxqcmq",
        "oyoaxbg72h7hkqx",
        "7d5wxmdnlo58"
    };

    public static String getNextToken(){
        return tokens.get(counter.getAndIncrement() % tokens.size());
    }

    public static void createAccessTokens() {
        for (int i = 0; i < emails.length; i++) {
            String email = emails[i];
            String password = passwords[i];

            Map<String, Object> accountInfo = new HashMap<>();
            accountInfo.put("userEmail", email);
            accountInfo.put("userPassword", password);

            Map<String, Object> result = Runner.runFeature("classpath:helpers/createToken.feature",
            accountInfo,true);
            tokens.add(result.get("authToken").toString());
        }
    }
}
