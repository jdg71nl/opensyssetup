//= ./lib-under-test

const mail = require('./mail-semi-mock');

module.exports.notifyCustomers = function () {
  mail.send('some', 'thing');
};

// - - - - - - = = = - - - - - -
//-eof
