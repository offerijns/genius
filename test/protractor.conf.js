require('coffee-script');

exports.config = {
  allScriptsTimeout: 11000,

  specs: [
    'e2e/**/*_spec.coffee'
  ],

  capabilities: {
    'browserName': 'chrome'
  },

  chromeOnly: true,

  baseUrl: 'http://localhost:8000/',

  framework: 'jasmine',

  jasmineNodeOpts: {
    defaultTimeoutInterval: 30000
  }
};
