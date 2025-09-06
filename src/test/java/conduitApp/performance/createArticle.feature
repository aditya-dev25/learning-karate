Feature: Tests for Articles component.

    Background:

        * def articleBody = read('classpath:conduitApp/json/articleBody.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def callArticleFunc = dataGenerator.getRandomArticleValues()

        * set articleBody.article.title = callArticleFunc.title
        * set articleBody.article.description = callArticleFunc.description
        * print __gatling
        # * set articleBody.article.title = __gatling.Title
        # * set articleBody.article.description = __gatling.Description
        * set articleBody.article.body = callArticleFunc.body

        Given url apiUrl

    Scenario: Create & Verify followed by Delete & Verify an Article

        # Creating the Article
        Given path 'articles/'
        * configure headers = {"Authorization": #('Token ' + __gatling.token)}
        And request articleBody
        And header karate-name = 'Create Article'
        When method Post
        Then status 201

        * def articleId = response.article.slug
        * karate.pause(5000)
        # =======================================

        # # Delete the Article
        # Given path 'articles', articleId
        # # Authorization from karate-config.js
        # When method Delete
        # Then status 204
