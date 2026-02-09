@ignore
Feature: Get authentication token


 Background:
  * url karate.get('apiUrl')
  * def parseJwtPayload =
  """
  function(token) {
      var base64Url = token.split('.')[1];
      var base64Str = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      var Base64 = Java.type('java.util.Base64');
      var decoded = Base64.getDecoder().decode(base64Str);
      var payload = new java.lang.String(decoded, 'UTF-8');
      return JSON.parse(payload);
  }
  """
  
  Scenario: Get access token
  Given path 'token'
  And request { username: '#(username)', password: '#(password)' }
  When method post
  Then status 200
  * def access_token = response.token
  * print "Access Token: " + access_token
  * def tokenDetails = parseJwtPayload(access_token)
  * print 'Parsed JWT Token:', tokenDetails
  
