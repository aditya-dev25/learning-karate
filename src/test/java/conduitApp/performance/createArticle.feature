Feature: Tests for Articles component.

    Background:

        * def articleBody = read('classpath:conduitApp/json/articleBody.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def callArticleFunc = dataGenerator.getRandomArticleValues()

        * set articleBody.article.title = callArticleFunc.title
        * set articleBody.article.description = callArticleFunc.description
        * set articleBody.article.body = callArticleFunc.body

        Given url apiUrl

    Scenario: Create & Verify followed by Delete & Verify an Article

        # Creating the Article
        Given path 'articles/'
        # Authorization from karate-config.js
        And request articleBody
        When method Post
        Then status 201

        * def articleId = response.article.slug

        # =======================================

        # Delete the Article
        Given path 'articles', articleId
        # Authorization from karate-config.js
        When method Delete
        Then status 204
