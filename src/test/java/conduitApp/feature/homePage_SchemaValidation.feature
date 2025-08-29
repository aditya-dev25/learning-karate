@debug
Feature: Tests for the Home Page

    Background: Define URL
        Given url apiUrl

    Scenario: Get all Tags
        Given path 'tags'
        When method Get
        Then status 200

        # {"tags":["Test","testTag","Git","testTag-12","YouTube","Zoom","Blog","Bondar Academy","Exam","GitHub"]}
        And match response.tags contains ["Zoom", "YouTube"]
        And match response.tags !contains "GitHub1"
        And match response.tags contains any ["Exam", "Blog1"]
        And match response.tags contains only ["Test","Git","testTag-12","Zoom","Blog","Bondar Academy","YouTube","Exam","Enroll","GitHub"]
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 Articles from the page.

        * def validateTime = read('classpath:helpers/timeValidator.js')

        Given path 'articles'
        Given params {limit: 100, offset: 0}
        When method Get
        Then status 200

        And match response == {articles: '#[]', articlesCount: '#number'}
        And match each response.articles == 
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "#[] #string",
                "createdAt": "#? validateTime(_)",
                "updatedAt": "#? validateTime(_)",
                "favorited": "#boolean",
                "favoritesCount": '#number',
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """

