Feature: SignUp Users

    Background:

        Given url apiUrl

    Scenario: Create a User

        Given def userData = {"email":"aditya7891@gmail.com", "username":"aditya7891"}

        Given path 'users'

        # Can use concatenation as well
        # And request {"user":{"email":#('Test'+userData.email),"password":"karate789","username":#('User'+userData.username)}}

        # Can use Multiline expressions
        And request
        """
        {
            "user": {
                "email":#('Test1'+userData.email),
                "password": "karate789",
                "username":#('User1'+userData.username)
            }
        }
        """
        When method Post
        Then status 201