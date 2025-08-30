@parallel=false
Feature: Tests for the Home Page

    Background: Define URL
        Given url apiUrl
    
    
    Scenario: Get all Tags
        Given path 'tags'
        When method Get
        Then status 200

        # {"tags":["Test","Git","testTag-12","Zoom","Blog","Bondar Academy","YouTube","Exam","Enroll","GitHub"]}
        And match response.tags contains ["Zoom", "YouTube"]
        And match response.tags !contains "GitHub1"
        And match response.tags contains any ["Exam", "Blog1"]
        And match response.tags contains only ["Test","Git","testTag-12","Zoom","Blog","Bondar Academy","YouTube","Exam","Enroll","GitHub"]
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 Articles from the page.
        Given path 'articles'
        Given params {limit: 100, offset: 0}
        When method Get
        Then status 200
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

    Scenario: Conditional Logic
        Given path 'articles'
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200

        * def countFavourite = response.articles[0].favoritesCount
        * def articleObject = response.articles[0]

        # * if (countFavourite == 0) karate.call('classpath:helpers/addLikes.feature', articleObject)

        # If we want to use the result from the helper feature
        * def result = countFavourite == 0 ? karate.call('classpath:helpers/addLikes.feature', articleObject).likesCount : countFavourite

        Given path 'articles'
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200

        # And match response.articles[0].favoritesCount == 1
        And match response.articles[0].favoritesCount == result

    Scenario: Retry Logic
        * configure retry = {count: 10, interval: 5000}

        Given path 'articles'
        And params {limit: 10, offset: 0}
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        Then status 200

    Scenario: Sleep Logic
        * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

        Given path 'articles'
        And params {limit: 10, offset: 0}
        When method Get
        * eval sleep(5000)
        Then status 200

    Scenario: Type Conversion - NUMBER TO STRING
        * def foo = 10
        # Before : * def json = {"bar": #(foo)} 
        # Concatenant the '' to the variable to convert it to String
        * def json = {"bar": #(foo + '')}  
        * match json == {"bar": '10'}

    @debug
    Scenario: Type Conversion - STRING TO NUMBER
        * def foo = '10'
        # Before : * def json1 = {"bar": #(foo)}
        # Do the arithmetic to the variable to convert it to Number
        * def json = {"bar": #(foo * 1)}  
        * match json == {"bar": 10}

        # Using JavaScript - Remove ~~ for float
        * def json2 = {"bar": #(~~parseInt(foo))}
        * match json == {"bar": 10}
