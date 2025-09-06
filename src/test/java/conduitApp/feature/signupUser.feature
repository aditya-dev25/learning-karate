Feature: SignUp Users

    Background:

        # From Faker package
        * def dataGenerator = Java.type('helpers.DataGenerator')

        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUserName = dataGenerator.getRandomUsername()
        * def randomPassword = dataGenerator.getRandonPassword()


        Given url apiUrl
    
    @debug
    Scenario: Create a new User

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

    Scenario Outline: Validated the Negative scenarios

        Given path 'users'

        # Can use Multiline expressions
        And request
        """
        {
            "user": {
                "email": '<email>',
                "password": '<password>',
                "username": '<username>'
            }
        }
        """

        When method Post
        Then status 422
        And match response == <errorResponse>

        Examples:

        | email             | password          | username                     | errorResponse                                                      |
        | deedee72@test.com | #(randomPassword) | #(randomUserName)            | {"errors":{"email":["has already been taken"]}}                    |
        | #(randomEmail)    | #(randomPassword) | rosalinda.littel             | {"errors":{"username":["has already been taken"]}}                 |
        | eejefunwiendnk    | #(randomPassword) | #(randomUserName)            | {"errors":{"email":["is invalid"]}}                                |
        | #(randomEmail)    | #(randomPassword) | adiefef3f3r3e3frf3ftya78239  | {"errors":{"username":["is too long (maximum is 20 characters)"]}} |
        | #(randomEmail)    | kar               | #(randomUserName)            | {"errors":{"password":["is too short (minimum is 8 characters)"]}} |
        |                   | #(randomPassword) | #(randomUserName)            | {"errors":{"email":["can't be blank"]}}                            |
        | #(randomEmail)    |                   | #(randomUserName)            | {"errors":{"password":["can't be blank"]}}                         |
        | #(randomEmail)    | #(randomPassword) |                              | {"errors":{"username":["can't be blank"]}}                         |
