function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env
  }
  if (env == 'dev') {
  config.baseUrl= 'http://localhost:8080/api';
  
   config.dbConfig= {
      username: 'sa',
      password: '',
      url: 'jdbc:h2:tcp://localhost/~/test',
      driverClassName: 'org.h2.Driver'
    }
   
   var authDetails = karate.call('classpath:eventsapi/events/authentication.feature', {apiUrl:config.baseUrl, username: 'johns@pocisoft.com', password: 'password'});
   
   karate.configure('headers', {Authorization: 'Bearer ' + authDetails.access_token});
   
   karate.configure('url', config.baseUrl)
   
   config.authDetails=authDetails

  } else if (env == 'e2e') {
    // customize
  }
  return config;
}