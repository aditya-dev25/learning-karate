@parallel=false @ignore
Feature: Work with Database

    Background: Work with Database

        * def dbConnection = Java.type('helpers.DbHandler')

        * def dataGenerator = callonce read('classpath:/helpers/dummy.feature')
        * def charName = dataGenerator.charName
        * def randomInt_1 = dataGenerator.randomInt_1
        * def randomInt_2 = dataGenerator.randomInt_2

        Scenario: Add a new item to the database

            * def insertedItem = dbConnection.addNewJobWithName(charName, randomInt_1, randomInt_2)
            * match insertedItem == 1
        
        Scenario: Get all details for a job and verify MinMaxLvl
            
            * def jobDetails = dbConnection.getJobByDescription(charName)
            * def returnedResults = ['#(jobDetails.minLvl)', '#(jobDetails.maxLvl)']
            * match returnedResults[0] == randomInt_1
            * match returnedResults[1] == randomInt_2
        
        Scenario: Update the min and max for a job
            
            * def updateMinMaxLvl = dbConnection.updateMinMaxLvlByDescription(charName, randomInt_1 + 1, randomInt_2 + 1)
            * match updateMinMaxLvl == 1

            # Verify the update
            * def jobDetails = dbConnection.getJobByDescription(charName)
            * def returnedResults = ['#(jobDetails.minLvl)', '#(jobDetails.maxLvl)']
            * match returnedResults[0] == randomInt_1 + 1
            * match returnedResults[1] == randomInt_2 + 1

        Scenario: Delete the job in DB
            
            * def deleteJob = dbConnection.deleteJobByDescription(charName)
            * match deleteJob == 1

            # Verify the deletion
            * def jobDetails = dbConnection.getJobByDescription(charName)
            * match jobDetails == {}