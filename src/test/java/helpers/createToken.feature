Feature: Create token

    Scenario: Create a token
        Given url 'https://conduit-api.bondaracademy.com/api/'

        # Generate Token
        Given path 'users/login'
        # And request {"user":{"email":"aditya123@gmail.com","password":"karate123"}}
        # And request {"user":{"email":"#(email)","password":"#(password)"}}
        And request {"user":{"email":#(userEmail),"password":#(userPassword)}}
        When method Post
        Then status 200
        * def authToken = response.user.token




       