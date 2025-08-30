package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {
    
    public static String getRandomEmail(){
        Faker faker = new Faker();
        String email = faker.internet().emailAddress();
        return email;
    }

    public static String getRandomUsername(){
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

    public static String getRandomCharaterName(){
        Faker faker = new Faker();
        String charName = faker.funnyName().name();
        return charName;
    }

    public static int getRandomInt(){
        Faker faker = new Faker();
        int randomInt  = faker.random().nextInt(1,1000);
        return randomInt;
    }

    public static String getRandonPassword(){
        Faker faker = new Faker();
        String password = faker.internet().password(8,20);
        return password;
    }

    public static String getRandomString(){
        Faker faker = new Faker();
        String string = faker.friends().quote();
        return string;
    }

    public static JSONObject getRandomArticleValues(){
        Faker faker = new Faker();
        String title = faker.artist().name();
        String description = faker.friends().location();
        String body = faker.friends().quote();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;
    }

}