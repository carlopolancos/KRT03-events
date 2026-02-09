@events
Feature: Test Event


 Background:
  
  * def tokenDetails = authDetails.tokenDetails
  
  
  Scenario: Get list of events for current user
  
  
  Given path 'events'
  When method get
  Then status 200
  * def userIds = karate.map(response.data, function(x){ return x.userId })
  
  * match karate.distinct(userIds) contains only tokenDetails.uid
  
  * def config =   karate.get('dbConfig')
  * def DbUtils = Java.type('eventsapi.DBUtility')
  * def db = new DbUtils(config)
  * def eventsFromDB = db.readRows('select * from events where UserId = ' + tokenDetails.uid)
  * print eventsFromDB
  * print response.data
  
  #* match karate.map(eventsFromDB,function(x) {return x.ID}) contains only karate.map(response.data,function(x) {return x.id})
  
  Scenario: Filter Events
  * def eventName = 'Fitness'
  Given path 'events'
  And params { eventName: '#(eventName)'}
  When method get
  Then status 200
  
  * match each response.data[*].name == '#regex .*' + eventName + '.*'
  
  
  
  Scenario: Delete Lock
  Given path 'events', 1
  When method delete
  Then status 403
  * assert response.errorMessage == 'User not allowed to delete this event'

  
  Scenario Outline: Create Event  - <name>
  Given path 'events' 
  And request 
      """
      {
      "date":<date>,
       "description":<description>,
      "location":<location>,
      "maxCapacity":<maxCapacity>,
      "name":<name>,
      "numberOfHours":<numberOfHours>,
      "organizer":<organizer>,
      "startTime":<startTime>
      }
      """
  When method post
  Then status 201
  Then match response.data == 
    """
      {
    'userId': '#(tokenDetails.uid)',
    'date': '#ignore',
    'description': <description>,
    'location': <location>,
    'maxCapacity': <maxCapacity>,
    'name': <name>,
    'numberOfHours': <numberOfHours>,
    'organizer': <organizer>,
    'startTime': <startTime>,
    'id': '#present',
    'currentCapacity':0
      }
     """
    Examples:
     | read('newevents.json') |