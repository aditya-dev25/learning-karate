@debug
Feature: Hooks

    Background: Hooks
        # Before Hooks
        # * def callFeature = callonce read('classpath:helpers/dummy.feature')
        # * def username = callFeature.username

        #  After Hooks
        * configure afterScenario = function() {karate.call('classpath:helpers/dummy.feature')}

        # Custom JS Code AfterHook using Embedded Expression
        * configure afterFeature =
        """
            function(){
                karate.log("After Feature text")
            }        
        """
    
    Scenario: First Scenario
        # * print username
        * print 'First Scenario'

    Scenario: Second Scenario
        # * print username
        * print 'Second Scenario'