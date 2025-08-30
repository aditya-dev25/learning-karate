Feature: Generator File

    Scenario: Dummy

        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def username = dataGenerator.getRandomUsername()

        # For workWithDB
        * def charName = dataGenerator.getRandomCharaterName()
        * def randomInt_1 = dataGenerator.getRandomInt()
        * def randomInt_2 = dataGenerator.getRandomInt()