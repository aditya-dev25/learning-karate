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
        And match response.tags contains only ["Test","testTag","Git","testTag-12","YouTube","Zoom","Blog","Bondar Academy","Exam","GitHub"]
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 Articles from the page.
        Given path 'articles'
        Given params {limit: 100, offset: 0}
        When method Get
        Then status 200
        And match response.articles == '#[27]'
        And match response.articlesCount == 27
        And match response.articlesCount != 10
        And match response == {articles: '#array', articlesCount: '#number'}
        And match response.articles[0].createdAt contains '2025'

        # Check each array item
        And match response.articles[*].favoritesCount contains 21
        And match response.articles[*].author.bio contains null

        # If response is too long, can use wildcard -> ..
        And match response..username contains "Artem Bondar"
        
        # Match each key value
        And match each response..following == false
        And match each response..following == '#boolean'
        And match each response..favoritesCount == '#number'

        # Double "##" indicates data_type or null - both are acceptable (including absence of key)
        And match each response..bio == '##string' 


