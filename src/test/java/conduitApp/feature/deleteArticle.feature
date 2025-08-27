Feature: Delete an Article

    Background:
        Given url apiUrl
    
    Scenario: Create & Verify followed by Delete & Verify an Article

        # Creating the Article
        Given path 'articles/'
        # Given header Authorization = token
        And request {"article":{"title":"Title72","description":"Test1","body":"abcd","tagList":["testTag-12"]}}
        When method Post
        Then status 201

        * def articleId = response.article.slug

        # Verifying the Article exists
        Given path 'articles'
        # Given header Authorization = token
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200
        And match response.articles[0].slug == articleId

        # Delete the Article
        Given path 'articles', articleId
        # Given header Authorization = token
        When method Delete
        Then status 204

        # Verifying the Article's deletion
        Given path 'articles'
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200
        And match response.articles[0].slug != articleId


