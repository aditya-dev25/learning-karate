package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {
    
    public static String getRandomEmail(){
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return email;
    }

    public static String getRandomUsername(){
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

    public static String getRandonPassword(){
        Faker faker = new Faker();
        String password = faker.howIMetYourMother().catchPhrase();
        return password;
    }

    public static String getRandomString(){
        Faker faker = new Faker();
        String string = faker.friends().quote();
        return string;
    }

    public static JSONObject getRandomArticleValues(){
        Faker faker = new Faker();
        String title = faker.friends().character();
        String description = faker.friends().location();
        String body = faker.friends().quote();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;
    }

}