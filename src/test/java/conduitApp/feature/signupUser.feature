@debug
Feature: SignUp Users

    Background:

        * def dataGenerator = Java.type('helpers.DataGenerator')
        Given url apiUrl


    Scenario: Create a User

        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUserName = dataGenerator.getRandomUsername()
        * def randomPassword = dataGenerator.getRandonPassword()

        Given path 'users'

        # Can use Multiline expressions
        And request
        """
        {
            "user": {
                "email":#(randomEmail),
                "password": #(randomPassword),
                "username":#(randomUserName)
            }
        }
        """

        When method Post
        Then status 201

        And match response.user ==
        """
            {
                "id": '#number',
                "email": #(randomEmail),
                "username": #(randomUserName),
                "bio": '##string',
                "image": '#string',
                "token": '#string'
            }
                
        """



        # Given def userData = {"email":"aditya7891@gmail.com", "username":"aditya7891"}
        # # Can use concatenation as well
        # And request {"user":{"email":#('Test'+userData.email),"password":"karate789","username":#('User'+userData.username)}}