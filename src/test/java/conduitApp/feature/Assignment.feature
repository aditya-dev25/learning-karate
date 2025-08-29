Feature: Home Work

    Background: Preconditions
        * url apiUrl 

        * def tempTokenFeature = call read('classpath:helpers/createToken.feature')
        * def tempToken = tempTokenFeature.authToken

        * def validateTime = read('classpath:helpers/timeValidator.js')
        * def dataGenerator = Java.type('helpers.DataGenerator')

    @ignore
    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        * configure headers = {}
        Given path 'articles'
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200

        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def firstArticleFavouriteCount = response.articles[0].favoritesCount
        * print firstArticleFavouriteCount
        * def firstArticleSlug = response.articles[0].slug

        # Step 3: Make POST request to increse favorites count for the first article
        Given header Authorization = 'Token ' + tempToken
        And path 'articles', firstArticleSlug, 'favorite'
        And request {}
        When method Post
        Then status 200


        # Step 4: Verify response schema
        And match response.article == 
        """
            {
                "id": '#number',
                "slug": '#string',
                "title": '#string',
                "description": '#string',
                "body":  '#string',
                "createdAt": "#? validateTime(_)",
                "updatedAt": "#? validateTime(_)",
                "authorId": '#number',
                "tagList": '#array',
                "author": {
                    "username": '#string',
                    "bio": '##string',
                    "image": '#string',
                    "following": '#boolean'
                },
                "favoritedBy": '#array',
                "favorited": '#boolean',
                "favoritesCount": '#number'
            }
        """

        # # Step 5: Verify that favorites article incremented by 1
        * print firstArticleFavouriteCount, response.article.favoritesCount
        And match response.article.favoritesCount == firstArticleFavouriteCount + 1

        # Step 6: Get all favorite articles
        Given header Authorization = 'Token ' + tempToken
        And path 'articles'
        And params { favorited: "aditya456", limit: 10, offset: 0}
        When method Get
        Then status 200

        # Step 7: Verify response schema
        And match response == {articles: '#array', articlesCount: '#number'}
        And match each response.articles ==
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "#array",
                "createdAt": "#? validateTime(_)",
                "updatedAt": "#? validateTime(_)",
                "favorited": "#boolean",
                "favoritesCount": "#number",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """

        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response..slug contains firstArticleSlug

    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        * configure headers = {}
        Given path 'articles'
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200

        # Step 2: Get the slug ID for the first arice, save it to variable
        * def firstArticleSlug = response.articles[0].slug

        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given header Authorization = 'Token ' + tempToken
        And path 'articles', firstArticleSlug, 'comments'
        When method Get
        Then status 200

        # Step 4: Verify response schema
        And match each response.comments ==
        """
            {
                "id": "#number",
                "createdAt": "#? validateTime(_)",
                "updatedAt": "#? validateTime(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """

        # Step 5: Get the count of the comments array lentgh and save to variable
        * def articlesCount = response.comments.length

        # Step 6: Make a POST request to publish a new comment
        * def randomComment = dataGenerator.getRandomString()

        Given header Authorization = 'Token ' + tempToken
        And path 'articles', firstArticleSlug, 'comments'
        And request {"comment":{"body": '#(randomComment)'}}
        When method Post
        Then status 200

        * def commentId = response.comment.id

        # Step 7: Verify response schema that should contain posted comment text
        And match response.comment.body == randomComment

        # Step 8: Get the list of all comments for this article one more time
        Given header Authorization = 'Token ' + tempToken
        And path 'articles', firstArticleSlug, 'comments'
        When method Get
        Then status 200

        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def newArticlesCount = response.comments.length
        And match newArticlesCount == articlesCount + 1
        
        # Step 10: Make a DELETE request to delete comment
        Given header Authorization = 'Token ' + tempToken
        And path 'articles', firstArticleSlug, 'comments', commentId
        When method Delete
        Then status 200

        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given header Authorization = 'Token ' + tempToken
        And path 'articles', firstArticleSlug, 'comments'
        When method Get
        Then status 200

        * def postDeleteCount = response.comments.length
        And match postDeleteCount == newArticlesCount - 1
