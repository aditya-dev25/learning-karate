function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
    apiUrl : 'https://conduit-api.bondaracademy.com/api/'
  }

  if (env == 'dev') {
    config.userEmail = 'aditya123@gmail.com';
    config.userPassword = 'karate123';

  } else if (env == 'qa') {
    config.userEmail = 'aditya456@gmail.com';
    config.userPassword = 'karate456';
  }

  // Getting the Access Token - This will run once and set the value for accessToken. Use karate.call() for short-life tokens.
  var accessToken = karate.callSingle('classpath:helpers/createToken.feature', config).authToken;

  // This will set the accessToken as Authorization header for entire suite.
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  
  return config;
}