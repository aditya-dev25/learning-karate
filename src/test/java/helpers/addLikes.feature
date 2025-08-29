Feature: Add Likes

    Scenario: Add Likes

        Given url apiUrl
        And path 'articles', slug, 'favorite'
        And request {}
        When method Post
        Then status 200

        * def likesCount = response.article.favoritesCount