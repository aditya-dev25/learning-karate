Feature: Tests for Articles component.

    Background:
        Given url apiUrl

    Scenario: Create a new Article
        Given path 'articles'
        Given request {"article":{"title":"Title67","description":"Test1","body":"abcd","tagList":["testTag-12"]}}
        When method Post
        Then status 201
        And match response.article.title == "Title67"