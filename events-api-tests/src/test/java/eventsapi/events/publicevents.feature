@events
Feature: Test Public Events
	
	Background: 
		* url 'http://localhost:8080/api'
		
	Scenario: Get all public events and get the first event by id
		Given path 'publicevents'
		When method get
		Then status 200
		
		* def firstEvent = response.data[0]
		
		Given path 'publicevents', firstEvent.id
		When method get
		Then status 200