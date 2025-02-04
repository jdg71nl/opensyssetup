#!/usr/bin/env node
//= ./project/javascript-node-hints-jdg.js
// - - - - - - = = = - - - - - -
//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// generic web info

// https://developer.mozilla.org/en-US/docs/Web/JavaScript
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// top-level require:

const mongoose = require("mongoose"); // npm i mongoose

const express = require("express");
const app = express();

const helmet = require("helmet");
app.use(helmet());

const Joi = require("joi"); // npm i joi
Joi.objectId = require("joi-objectid")(Joi); // npm i joi-objectid

const _ = require("lodash"); // npm i lodash // https://lodash.com/docs/4.17.15

const bcrypt = require("bcryptjs"); // npm i bcryptjs // https://www.npmjs.com/package/bcryptjs // Optimized bcrypt in JavaScript with zero dependencies. Compatible to the C++ bcrypt binding on node.js (!!)

const jwt = require("jsonwebtoken"); // npm install jsonwebtoken

const winston = require("winston"); // npm i winston

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// JDG-TOP generic problems-solved by experience

// (*) forget to wrap a (ALL) function-call(s) in a SEPARATE (!) Try-Catch block
// (*) forget to await a 'async function call' even when this func does not return an explicit Promise (so, when in doubt ALWAYS use 'await')
// (*) don't use async-await in a Array.map() or Array.forEach() function, better use: 'for (let item of Array)' or '  for (let index in Array) { const item = Array[index]; }
// (*) the 'converting-circular-structure-to-json' problem, using the Axios property 'response' directly, e.g. console.log(`response=${JSON.stringify(response)}`); -- instead of using: response.data
// (*)
// (*)

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: tests from: TCNC-The-Complete-Node-js-Course

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-02-Global-Object.mp4
// console.log();         // = global object (function)
// window.console.log     // = can write as (only in browser)
// var message = '';      // = global object
// window.message         // = global object (only in browser)
// global.message         // = global object (only in Node), but still no: 'message' is var in file/module-scope

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-03-Modules.mp4
// console.log(module);
//
// > node project/playground/some_tests.js
// Module {
//   id: '.',
//   path: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground',
//   exports: {},
//   parent: null,
//   filename: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/some_tests.js',
//   loaded: false,
//   children: [],
//   paths: [
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/node_modules',
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/node_modules',
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/node_modules',
//     '/mnt/vdb1/home/jdg/dev/node_modules',
//     '/mnt/vdb1/home/jdg/node_modules',
//     '/mnt/vdb1/home/node_modules',
//     '/mnt/vdb1/node_modules',
//     '/mnt/node_modules',
//     '/node_modules'
//   ]
// }

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-04-Creating-a-Module.mp4
//
//: logger.js
// var url = 'http://,ylogger.io/log';
// function log(message) {
//   // Send an HTTP request
//   console.log(message);
// }
// module.exports.log = log;
//
//: app.js
// var logger = require('./logger');
// console.log(logger);
// > node project/playground/some_tests.js
// { log: [Function: log] }
// logger.log('a message');
// > node project/playground/some_tests.js
// a message
//
//: logger.js
// var url = 'http://,ylogger.io/log';
// function log(message) {
//   // Send an HTTP request
//   console.log(message);
// }
// module.exports = log;        // <== export a func directly and not in an object

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-05-Loading-a-Module.mp4
//: app.js
// var log = require("./logger");
// log("a message");
// > node project/playground/some_tests.js
// a message
//
// var log = require("./logger");
// console.log(module);
// > node project/playground/some_tests.js
// <ref *1> Module {
//   id: '.',
//   path: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground',
//   exports: {},
//   parent: null,
//   filename: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/some_tests.js',
//   loaded: false,
//   children: [
//     Module {
//       id: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/logger.js',
//       path: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground',
//       exports: [Function: log],
//       parent: [Circular *1],
//       filename: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/logger.js',
//       loaded: true,
//       children: [],
//       paths: [Array]
//     }
//   ],
//   paths: [
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/node_modules',
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/node_modules',
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/node_modules',
//     '/mnt/vdb1/home/jdg/dev/node_modules',
//     '/mnt/vdb1/home/jdg/node_modules',
//     '/mnt/vdb1/home/node_modules',
//     '/mnt/vdb1/node_modules',
//     '/mnt/node_modules',
//     '/node_modules'
//   ]
// }
//
//: logger.js
// var url = 'http://,ylogger.io/log';
// function log(message) {
//   // Send an HTTP request
//   console.log(message);
// }
// // module.exports.log = log;
// module.exports = log;
// console.log(module);
// //-eof
//
// var log = require("./logger");
// > node project/playground/some_tests.js
// <ref *1> Module {
//   id: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/logger.js',
//   path: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground',
//   exports: [Function: log],
//   parent: Module {
//     id: '.',
//     path: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground',
//     exports: {},
//     parent: null,
//     filename: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/some_tests.js',
//     loaded: false,
//     children: [ [Circular *1] ],
//     paths: [
//       '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/node_modules',
//       '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/node_modules',
//       '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/node_modules',
//       '/mnt/vdb1/home/jdg/dev/node_modules',
//       '/mnt/vdb1/home/jdg/node_modules',
//       '/mnt/vdb1/home/node_modules',
//       '/mnt/vdb1/node_modules',
//       '/mnt/node_modules',
//       '/node_modules'
//     ]
//   },
//   filename: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/logger.js',
//   loaded: false,
//   children: [],
//   paths: [
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/node_modules',
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/node_modules',
//     '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/node_modules',
//     '/mnt/vdb1/home/jdg/dev/node_modules',
//     '/mnt/vdb1/home/jdg/node_modules',
//     '/mnt/vdb1/home/node_modules',
//     '/mnt/vdb1/node_modules',
//     '/mnt/node_modules',
//     '/node_modules'
//   ]
// }

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-06-Module-Wrapper-Function.mp4
// //= logger.js
// var x =;
// var url = 'http://,ylogger.io/log';
// function log(message) {
//   // Send an HTTP request
//   console.log(message);
// }
// // module.exports.log = log;
// module.exports = log;
// console.log(module);
// //-eof
//
// var log = require('./logger');
// > node project/playground/some_tests.js
// /mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/logger.js:2
// from MP4:
// (function (exports, require, module, __filename, __dirname) { var x =;
// var x =;
//        ^
// SyntaxError: Unexpected token ';'
//     at wrapSafe (internal/modules/cjs/loader.js:1001:16)
//     at Module._compile (internal/modules/cjs/loader.js:1049:27)
//     at Object.Module._extensions..js (internal/modules/cjs/loader.js:1114:10)
//     at Module.load (internal/modules/cjs/loader.js:950:32)
//     at Function.Module._load (internal/modules/cjs/loader.js:790:12)
//     at Module.require (internal/modules/cjs/loader.js:974:19)
//     at require (internal/modules/cjs/helpers.js:101:18)
//     at Object.<anonymous> (/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground/some_tests.js:172:11)
//     at Module._compile (internal/modules/cjs/loader.js:1085:14)
//     at Object.Module._extensions..js (internal/modules/cjs/loader.js:1114:10)
// #( bash[PROMPT_COMMAND]: prev.cmd returned non-zero code: 1 )
//
//: so each module is really a Module Wrapper Function:
//
// (function (exports, require, module, __filename, __dirname) {
//   var url = "http://,ylogger.io/log";
//   function log(message) {
//     // Send an HTTP request
//     console.log(message);
//   }
//   // module.exports.log = log;
//   module.exports = log;
//   console.log(module);
// });

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-07-Path-Module.mp4
//
// > node --version
// v14.19.1
// https://nodejs.org/docs/latest-v14.x/api/
//
// https://nodejs.org/docs/latest-v14.x/api/path.html
if (false) {
  const path = require("path");
  var pathObj = path.parse(__filename);
  console.log(pathObj);
}
// > node project/playground/some_tests.js
// {
//   root: '/',
//   dir: '/mnt/vdb1/home/jdg/dev/TokenMe-Cloud-Server/project/playground',
//   base: 'some_tests.js',
//   ext: '.js',
//   name: 'some_tests'
// }

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-08-OS-Module.mp4
// https://nodejs.org/docs/latest-v14.x/api/os.html
if (false) {
  const os = require("os");
  var totalMemory = os.totalmem();
  var freeMemory = os.freemem();
  console.log(`Total Memory: ${totalMemory}, Free Memory: ${freeMemory}`);
}
// > node project/playground/some_tests.js
// Total Memory: 12594167808, Free Memory: 7048085504

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-09-File-System-Module.mp4
// https://nodejs.org/docs/latest-v14.x/api/fs.html
if (false) {
  const fs = require("fs");
  //
  // import { unlink } from 'fs/promises';
  const { unlink } = require("fs/promises");
  try {
    await unlink("/tmp/hello");
    console.log("successfully deleted /tmp/hello");
  } catch (error) {
    console.error("there was an error:", error.message);
  }
}
//: "always use async methods.."

if (false) {
  // read JSON file (async):
  // import { readFile } from "fs/promises";
  const json = JSON.parse(
    await readFile(new URL("./some-file.json", import.meta.url))
  );
  //
  // read JSON file (sync)
  // import * as fs from "node:fs";
  const text = fs.readFileSync("./input.txt", { encoding: "utf8", flag: "r" });
  try {
    obj = JSON.parse(text);
  } catch (e) {
    return console.error(e);
  }
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-10-Events-Module.mp4
// https://nodejs.org/docs/latest-v14.x/api/events.html
//
if (false) {
  const EventEmitter = require("events"); // first letter uppercase: is Class
  const emitter = new EventEmitter(); // this is a object
  //
  // emitter.addListener(); ==same-as== emitter.on();
  emitter.on("messageLogged", function () {
    console.log("Listener called");
  });
  emitter.emit("messageLogged");
}
// > node project/playground/some_tests.js
// Listener called

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-11-Event-Arguments.mp4
if (false) {
  emitter.on("messageLogged", function (arg) {
    // typical: arg, e, eventArg
    console.log("Listener called", arg);
  });
  emitter.emit("messageLogged", { id: 1, url: "http://" });
}
// > node project/playground/some_tests.js
// Listener called { id: 1, url: 'http://' }

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L02-12-Extending-EventEmitter.mp4
//
//: logger.js
// const EventEmitter = require("events");
// var url = "http://,ylogger.io/log";
// class Logger extends EventEmitter {
//   log(message) {
//     console.log(message);
//     this.emit("messageLogged", { id: 1, url: "http://" });
//   }
// }
// module.exports = Logger;
//
if (false) {
  const { appendFile } = require("fs");
  const Logger = require("./logger");
  const logger = new Logger();
  logger.on("messageLogged", function (arg) {
    console.log("Listener called", arg);
  });
  logger.log("message");
}
// > node project/playground/some_tests.js
// message
// Listener called { id: 1, url: 'http://' }

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L03-05-Package-Dependencies.mp4

// "_comment_0": " // SemVer: Major.Minor.Patch ",
// "_comment_1": " // carot^ like in '^6.Minor.Patch' is same as '6.x'   and means => I want latest version with fixed Major==6         ",
// "_comment_2": " // tilde~ like in '~1.9.Patch'     is same as '1.9.x' and means => I want latest version with fixed Major.Minor==1.9 ",
// "_comment_3": " // > npm outdated                      <== show Current, Wanted and Latest ",
// "_comment_4": " // > npm update                        <== to update to Wanted versions",
// "_comment_5": " // > sudo npm i npm-check-updates -g   <== then run:    > ncu   <== to see any newer version (beyond carot^ and tilde~) ",

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L05-04-Built-in-Middleware.mp4
//
if (false) {
  // const express = require("express");
  // const app = express();
  // built-in middleware function express.json() scans for JSON in the request, and sets the data in object req.body
  app.use(express.json());
  // built-in middleware function express.urlencoded() scans for URL-Encoded data in the request, and sets the data in object req.body (e.g. key=value&key=value)
  app.use(express.urlencoded());
  app.use(express.urlencoded({ extended: true }));
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L05-05-Third-party-Middleware.mp4

// http://expressjs.com/en/resources/middleware.html

if (false) {
  // Helmet -- Help secure Express apps with various HTTP headers
  // https://github.com/helmetjs/helmet
  // https://www.npmjs.com/package/helmet
  // const express = require("express");
  // const app = express();
  // const helmet = require("helmet"); // npm i helmet
  // app.use(helmet());
}
if (false) {
  // Morgan -- HTTP request logger middleware for node.js
  // http://expressjs.com/en/resources/middleware/morgan.html
  // const express = require("express");
  // const app = express();
  // const morgan = require('morgan') // npm i morgan
}
if (false) {
  // compression -- Node.js compression middleware.
  // http://expressjs.com/en/resources/middleware/compression.html
  // const express = require("express");
  // const app = express();
  // const compression = require('compression') // npm i compression
  // app.use(compression()); // compress all responses
}
if (false) {
  // Passport -- Simple, unobtrusive authentication for Node.js.
  // https://github.com/jaredhanson/passport
  // https://www.passportjs.org/
  // https://www.passportjs.org/packages/
  // npm i passport
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L05-06-Environments.mp4

// 2 ways to read 'NODE_ENV' environment variable:
if (false) {
  const node_env = process.env.NODE_ENV; // undefined if undefined ;-) , use on Linux: > NODE_ENV=development node program.js
  app.get("env"); // 'development' if not defined
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// L05-07-Configuration.mp4

if (false) {
  // https://www.npmjs.com/package/config
  // https://github.com/lorenwest/node-config/wiki/Common-Usage
  // > npm install config
  // > mkdir config
  // > touch config/default.json
  // > touch config/development.json
  // > touch config/production.json
  // > touch config/custom-environment-variables
  const config = require("config"); // npm install --save config
  // console.log("app name: "    + config.get("name") );
  // console.log("mail server: " + config.get("mail.host") );
  //
  const config_defaults = require("root-require")("/config/default.json");
  const test_env = Object.keys(config_defaults);
  test_env.forEach((env_var) => {
    const config_var = config.get(env_var) || "";
    console.log(`# config/env variable: ${env_var}=${config_var}`);
  });
}

// if error: (from npm-config.js): "WARNING: No configurations found in configuration directory"
// then include: NODE_CONFIG_DIR="../../../config"
// like:
// cat run_debug.sh
// NODE_ENV=development NODE_CONFIG_DIR="../../../config" node --trace-warnings ./data_proc_daemon.js

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// L05-08-Debugging.mp4
// better to replace 'console.log()' with 'debug()' because of ENV control and Namespaces
// https://www.npmjs.com/package/debug
if (false) {
  // first install: > npm i debug --save
  const debug_startup = require("debug")("app:startup"); // "app:startup" is a namespace that is auto-color-coded and controlled in DEBUG env var
  const debug_db = require("debug")("app:db");

  // // usage in Node on console:
  // export DEBUG=app:startup
  // export DEBUG=app:startup,app:db
  // export DEBUG=app:*
  // export DEBUG=
  // node | nodemon ...
  // export DEBUG=app:startup node ...

  // npm i debug // https://www.npmjs.com/package/debug
  // # also install: npm install supports-color // https://www.npmjs.com/package/supports-color
  // let debug = require("debug")("dashboard:server");
  // import require_debug from "debug";
  const debug = require_debug("api:api_server.js");
  // debug("print object multi-line: %O", { key: "val" }); // %O = Pretty-print an Object on multiple lines.
  // debug("print object single-line: %o", { key: "val" }); // %o = Pretty-print an Object all on a single line.
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L05-10-Database-Integration.mp4
// http://expressjs.com/en/guide/database-integration.html
//
// https://github.com/vitaly-t/pg-promise
// "Built on top of node-postgres, this library adds the following:"

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L06-06-Promises.mp4

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises
// Chaining
// A common need is to execute two or more asynchronous operations back to back, where each subsequent operation starts when the previous operation succeeds, with the result from the previous step.
// .
// With promises, we accomplish this by creating a promise chain. The API design of promises makes this great, because callbacks are attached to the returned promise object, instead of being passed into a function.
// .
// Here's the magic: the then() function returns a new promise, different from the original:
// const promise = doSomething();
// const promise2 = promise.then(successCallback, failureCallback);

if (false) {
  // from Mosh:
  const p = new Promise((resolve, reject) => {
    setTimeout(() => {
      // Kick off some async work
      const result = { result: 1 };
      // resolve(result);
      reject(new Error("Error-message"));
    }, 2000);
  });
  p.then((result) => console.log("Result", result)).catch((err) =>
    console.log("Error", err.message)
  );

  // - - -
  // from Mozilla:
  function doSomething() {
    return new Promise((resolve) => {
      setTimeout(() => {
        // Other things to do before completion of the promise
        console.log("Did something");
        // The fulfillment value of the promise
        resolve("https://example.com/");
      }, 200);
    });
  }
  //
  doSomething()
    .then(function (result) {
      return doSomethingElse(result);
    })
    .then(function (newResult) {
      return doThirdThing(newResult);
    })
    .then(function (finalResult) {
      console.log(`Got the final result: ${finalResult}`);
    })
    .catch(failureCallback);
  //
  doSomething()
    .then((result) => doSomethingElse(result))
    .then((newResult) => doThirdThing(newResult))
    .then((finalResult) => {
      console.log(`Got the final result: ${finalResult}`);
    })
    .catch(failureCallback);
  //

  // Floating promises could be worse if you have race conditions — if the promise from the last handler is not returned, the next then handler will be called early, and any value it reads may be incomplete.
  // Therefore, as a rule of thumb, whenever your operation encounters a promise, return it and defer its handling to the next then handler.
  const listOfIngredients = [];
  doSomething()
    .then((url) => {
      // `return` keyword now included in front of fetch call.
      return fetch(url)
        .then((res) => res.json())
        .then((data) => {
          listOfIngredients.push(data);
        });
    })
    .then(() => {
      console.log(listOfIngredients);
      // listOfIngredients will now contain data from fetch call.
    });

  //
}

function f_demo_func_returning_a_promise() {
  return new Promise(async (resolve, reject) => {
    try {
      // do async work here ...
      const result = await new Promise();
      //
      // next, return normally:
      resolve(result);
      //
    } catch (err) {
      reject(err);
    }
  });
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L06-08-Consuming-Promises.mp4
// in words: every call to function that is doing something and returning data, that function returns a Promise, and in the .then() consumption you can call another Promise-Returning Function (PRF), then you get a .then "chaining" with one shared .catch
if (false) {
  getUser(1)
    .then((user) => getRepositories(user.gitHubUsername))
    .then((repos) => getCommits(repos[0]))
    .then((commits) => console.log("Commits", commits))
    .catch((err) => console.log("Error", err.message));
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L06-10-Running-Promises-in-Parallel.mp4
if (false) {
  const p1 = new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Async operation 1...");
      resolve(1);
      // reject(new Error("p1 failed"));
    }, 2000);
  });
  const p2 = new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Async operation 2...");
      resolve(2);
    }, 2000);
  });
  //
  Promise.all([p1, p2]) // .all([]) returns a new Promise that resolves when ALL contributing promises are resolved
    .then((result) => console.log("Result", result))
    .catch((err) => console.log("Error", err.message));
  //
  Promise.race([p1, p2]) // .race([]) returns a new Promise that resolves when the FIRST contributing promise is resolved, returnin not an Array but the first P-result
    .then((result) => console.log("Result", result))
    .catch((err) => console.log("Error", err.message));
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L06-11-Async-and-Await.mp4

// . . .

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// more info on Promise/async-await

// https://javascript.info/async-await
// Summary
// The ASYNC keyword before a function has two effects:
// -  Makes it ALWAYS return a PROMISE.                   <==== !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// -  Allows await to be used in it.
// The await keyword before a promise makes JavaScript wait until that promise settles, ...

// Topic: Call async from non-async
if (false) {
  //
  // Question: We have a “regular” function called f. How can you call the async function wait() and use its result inside of f?
  async function wait1() {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    return 10;
  }
  function f1() {
    // ...what should you write here?
    // we need to call async wait() and wait to get 10
    // remember, we can't use "await"
  }
  // P.S. The task is technically very simple, but the question is quite common for developers new to async/await.

  // That’s the case when knowing how it works inside is helpful.
  // Just treat async call as promise and attach .then to it:
  async function wait2() {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    return 10;
  }
  function f2() {
    // shows 10 after 1 second
    wait2().then((result) => alert(result));
  }
  f();
}

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function
// Return value
// A Promise which will be resolved with the value returned by the async function, or rejected with an exception thrown from, or uncaught within, the async function.
//
// Async functions always return a promise. If the return value of an async function is not explicitly a promise, it will be implicitly wrapped in a promise.
//
if (false) {
  //
  // For example, consider the following code:
  async function foo1() {
    return 1;
  }
  // It is similar to:
  function foo2() {
    return Promise.resolve(1);
  }
}

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await
// Conversion to promise
// If the value is not a Promise, it converts the value to a resolved Promise, and waits for it. The awaited value's identity doesn't change as long as it doesn't have a then property that's callable.

if (false) {
  async function f3() {
    //
    const y = await 20;
    console.log(y); // 20
    //
    const obj = {};
    console.log((await obj) === obj); // true
  }
  f3();
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L??-??----Mongoose ??

if (false) {
  mongoose_schema.set("toJSON", {
    virtuals: true,
    versionKey: false,
    transform: function (doc, ret) {
      delete ret._id;
    },
  });
  const to_lean_mongo_obj = {
    virtuals: true,
    versionKey: false,
    transform: function (doc, ret) {
      delete ret._id;
    },
  };
  mongoose_schema.set("toJSON", to_lean_mongo_obj); // ALSO can use it in: .toObject(to_lean_mongo_obj)
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L09-09-ObjectID.mp4

// _id: 5a724953ab83547957541e6a
// _id: 63821140821510bc21e5e723
// 12 bytes:
// 4 bytes: timestamp
// 3 bytes: machine identifier
// 2 bytes: process identifier
// 3 bytes: counter

if (false) {
  // const mongoose = require("mongoose"); // npm i mongoose
  const id = new mongoose.Types.ObjectId();
  console.log(id);
  // new ObjectId("63821140821510bc21e5e723")
  console.log(id.getTimestamp());
  // 2022-11-26T13:15:46.000Z
  const isValid = mongoose.Types.ObjectId.isValid("1234");
  console.log(isValid);
  // false
  const isValid2 = mongoose.Types.ObjectId.isValid(id);
  console.log(isValid2);
  // true
  //
  // const Joi = require("joi"); // npm i joi
  // Joi.objectid = require("joi-objectid")(Joi); // npm i joi-objectid // NOTE: do this ONLY ONCE, e.g. in index.js or ./startup/validation.js
  const joi_schema = {
    customerId: Joi.objectId().required(),
  };
  //
  const passwordComplexity = require("joi-password-complexity"); // npm install joi-password-complexity // https://www.npmjs.com/package/joi-password-complexity
  passwordComplexity().validate("aPassword123!");
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L10-04-Using-Lodash.mp4

if (false) {
  //
  // const _ = require("lodash"); // npm i lodash // https://lodash.com/docs/4.17.15
  const ori_obj = {
    _id: "sadasdsa",
    name: "my name",
    email: "some@bull.shit",
    password: "this better be secret",
  };
  console.log(ori_obj);
  // { _id: 'sadasdsa', name: 'my name', email: 'some@bull.shit', password: 'this better be secret' }
  //
  const new_object = _.pick(ori_obj, ["name", "email"]);
  console.log(new_object);
  // { name: 'my name', email: 'some@bull.shit' }
  //
  // preferred:
  const lodash = require("lodash"); // npm i lodash // https://lodash.com/docs/4.17.15
  const picked_object = lodash.pick(ori_obj, ["name", "email"]);
  const omit_object = lodash.omit(ori_obj, ["_id", "password"]);
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L10-05-Hashing-Passwords.mp4

if (false) {
  //
  // const bcrypt = require('bcrypt'); // https://www.npmjs.com/package/bcrypt // PROBLEM: relies on troublesome (certainly on Mac) https://www.npmjs.com/package/node-pre-gyp or https://www.npmjs.com/package/node-gyp
  // const bcrypt = require("bcryptjs"); // npm i bcryptjs // https://www.npmjs.com/package/bcryptjs // Optimized bcrypt in JavaScript with zero dependencies. Compatible to the C++ bcrypt binding on node.js (!!)
  //
  async function async_wrapper() {
    const salt = await bcrypt.genSalt(10);
    console.log(salt);
    const my_password = "1234";
    const hashed_pwd = await bcrypt.hash(my_password, salt);
    console.log(hashed_pwd);
    // $2a$10$ICYxEeXJ.yxxLcAseGDycO
    // $2a$10$ICYxEeXJ.yxxLcAseGDycOEFQ4DEfuC6YMU7Rcm4XDpfoF0NZHL9O
    const validPassword = await bcrypt.compare(my_password, hashed_pwd);
    console.log(validPassword);
    // $2a$10$kZZbTy/s70vohDxw5SqxC.
    // $2a$10$kZZbTy/s70vohDxw5SqxC.6oHg7fkafbTKrr1.Ge0IurDzHroa4Pi
    // true
  }
  async_wrapper();
  // $2a$10$FwMhRtYxPm8G.CrWOvIPeO
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L10-08-JSON-Web-Tokens.mp4

// test: https://jwt.io/

if (false) {
  // const jwt = require("jsonwebtoken"); // npm install jsonwebtoken
  const jwtPrivateKey = "jwtPrivateKey";
  const token = jwt.sign({ _id: "some ID" }, jwtPrivateKey);
  console.log(token);
  // eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiJzb21lIElEIiwiaWF0IjoxNjY5NDczMzcxfQ.t0ko8htTbU5_ADl34r5esiU8tb2fZNelGFxk2lkNHko
  // payload: { "_id": "some ID", "iat": 1669473371 }
  // use iat (time created) to calculate the age of the token
  //
  const my_response = {};
  const res = {
    header: () => {
      return { send: () => {} };
    },
  }; // from middleware func(req, res)
  res.header("x-auth-token", token).send(my_response);

  //
  // const jwt = require("jsonwebtoken"); // npm i jsonwebtoken // https://www.npmjs.com/package/jsonwebtoken
  // .verify() ==> "(Synchronous) If a callback is not supplied, function acts synchronously. Returns the payload decoded if the signature is valid and optional expiration, audience, or issuer are valid. If not, it will throw the error."
  let decoded;
  try {
    decoded = jwt.verify(token, jwtPrivateKey);
  } catch (err) {
    //
  }
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L11-01-___-Handling-and-Logging-Errors-Introduction.mp4
//: Why Error Handling? 1) send a friendly error, 2) Log the exception
//
//: L11-02-Handling-Rejected-Promises.mp4
// so, just catch rejected Promises ...
if (false) {
  function await_some_func_returning_promise() {
    return new Promise();
  }
  try {
    const result = await_some_func_returning_promise();
  } catch (ex) {
    console.log("Something failed.");
  }
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L11-03-Express-Error-Middleware.mp4
//
if (false) {
  function genres() {}
  // const express = require("express");
  // const app = express();
  //
  app.use(express.json());
  app.use("/api/genres", genres);
  //
  // add "Error Middleware Function" as LAST in .use list:
  app.use(function (err, req, res, next) {
    // NOTE: first arg is ERROR:err
    console.log("Something failed.");
  });
  //
  // in router do:
  router.get("/", async (req, res, next) => {
    try {
      // do some
    } catch (ex) {
      next(ex); // NOTE: pass the Exception:ex as first arg
    }
  });
  //
  // or better: move to a seperate middleware module/file:
  //: error_mw.js
  module.exports = function (err, req, res, next) {
    console.log("Something failed.");
  };
  //
  const error_mw = require("./middleware/error_mw");
  app.use(error_mw); // dont CALL the function, just pass the func ..
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L11-04-Removing-Try-Catch-Blocks.mp4
//: we want to move the try-catch structure to central place..
//: definition: a FACTORY FUNCTION is a function that returns a function
//
//: ./middleware/async.js
// NOTE: outer func needs no async keyword because we are not awaiting anything
if (false) {
  module.exports = function (handler) {
    // NOTE: we don't need to define args req,res,next in handler arg-list, as they are matches at runtime
    return async (req, res, next) => {
      try {
        await handler(req, res);
      } catch (ex) {
        next(ex);
      }
    };
  };
  //
  //: in route.js do:
  const asyncMiddleware = require("../middleware/async");
  router.get(
    "/",
    asyncMiddleware(async (req, res) => {
      // do some that can reject
    })
  );
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L11-05-Express-Async-Errors.mp4
//: https://www.npmjs.com/package/express-async-errors
//: this NPM module will monkey-patch the route-function at run-time
//
if (false) {
  //: NOTE: that we do not need to save the require, just import it:
  require("express-async-errors"); // npm install express-async-errors --save
  //
  //: we still need this though:
  app.use((err, req, res, next) => {
    console.log("Something failed.");
  });
  //
  //: sample use from https://www.npmjs.com/package/express-async-errors
  app.use(async (req, res) => {
    const user = await User.findByToken(req.get("authorization"));
    if (!user) throw Error("access denied");
  });
  app.use((err, req, res, next) => {
    if (err.message === "access denied") {
      res.status(403);
      res.json({ error: err.message });
    }
    next(err);
  });
  // NOTE: above was only to centrally handle async-errors in express route-handlers ..
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: L11-06-Logging-Errors.mp4

if (false) {
  // https://www.npmjs.com/package/winston
  // https://github.com/winstonjs/winston
  // https://github.com/winstonjs/winston/blob/master/UPGRADE-3.0.md
  // const winston = require("winston"); // npm i winston
}

if (false) {
  // Loggly - enterprise Full-stack logging over HTTP (SolarWinds)
  // https://www.loggly.com/
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: object destructering
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment

if (false) {
  const a = { b: { c: "Hi!" } };
  const {
    b: new_name_for_b,
    b: { c },
  } = a;
  console.log(new_name_for_b); // { c: 'Hi!' }
  console.log(c); // // 'Hi!'
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Array

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array#relationship_between_length_and_numerical_properties
if (false) {
  const array1 = [1, 2, 3, 4];
  console.log(array1.length); // so .length is a property (not a function), and it works similar to string.length (not called .size)
  //
  // test whether a value is contained / included in a Array (contains):
  ["joe", "jane", "mary"].includes("jane"); // true
  //
  // NOTE: .includes() also works for: String
  if ("abc".includes("b")) {
    // do something terrible
  }
  //
}

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/push
// "The push() method adds the specified elements to the end of an array and returns the new length of the array. "
if (false) {
  const animals = ["pigs", "goats", "sheep"];
  const newLength = animals.push("cows");
}

// generate an Array -- idea from: https://stackoverflow.com/questions/3746725/how-to-create-an-array-containing-1-n
if (false) {
  //
  console.log(JSON.stringify(Array(10)));
  // [null,null,null,null,null,null,null,null,null,null]
  //
  console.log(JSON.stringify(Array.from(Array(10).keys())));
  // [0,1,2,3,4,5,6,7,8,9]
  //
  console.log(JSON.stringify([...Array(10).keys()].map((x) => x + 1)));
  // [1,2,3,4,5,6,7,8,9,10]
  //
  const gen_arr_1 = Array.from(Array(10).keys());
  //=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  // start from 1:
  const gen_arr_2 = [...Array(10).keys()].map((x) => x++);
  //
  var N = 10;
  const gen_arr_3 = Array.apply(null, { length: N }).map(Number.call, Number);
  // result: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  //
  // https://www.geeksforgeeks.org/how-to-create-an-array-containing-1-n-numbers-in-javascript/
  function createArray(N) {
    return [...Array(N).keys()].map((i) => i + 1);
  }
  let N = 12;
  let arr = createArray(N);
  console.log(arr);
  // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  //
}

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/pop
// "The pop() method removes the last element from an array and returns that element. This method changes the length of the array."

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce
if (false) {
  const array1 = [1, 2, 3, 4];
  // 0 + 1 + 2 + 3 + 4 = 10
  const initialValue = 0;
  const sumWithInitial = array1.reduce(
    (accumulator, currentValue) => accumulator + currentValue,
    initialValue
  );
}

// https://stackoverflow.com/questions/24806772/how-to-skip-over-an-element-in-map
if (false) {
  const someArray = [];
  const transform = function () {};
  // You can generally express .map() in terms of .reduce:
  someArray.map(function (element) {
    return transform(element);
  });
  // can be written as:
  someArray.reduce(function (result, element) {
    result.push(transform(element));
    return result;
  }, []);
  //
  // (JDG) or:
  someArray.reduce((accumulator, element) => {
    accumulator.push(transform(element));
    return accumulator;
  }, []);
  //
  // So if you need to skip elements, you can do that easily with .reduce():
  let newArray = someArray.reduce(function (result, img) {
    if (img.src.split(".").pop() !== "json") {
      result.push(img.src);
    }
    return result;
  }, []);
}

// find item in Array:
if (false) {
  //
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find
  // The find() method of Array instances returns the first element in the provided array that satisfies the provided testing function. If no values satisfy the testing function, undefined is returned.
  const find_array1 = [5, 12, 8, 130, 44];
  const found = find_array1.find((element) => element > 10);
  console.log(found);
  // Expected output: 12
  //
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex
  const find_array2 = [5, 12, 8, 130, 44];
  const isLargeNumber = (element) => element > 13;
  console.log(find_array2.findIndex(isLargeNumber));
  // Expected output: 3
}

// insert (splice) item in array:
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
// Array.prototype.splice()
//
// The splice() method changes the contents of an array by removing or replacing existing elements and/or adding new elements in place.
//
// To create a new array with a segment removed and/or replaced without mutating the original array, use toSpliced(). To access part of an array without modifying it, see slice().
//
// splice(start)
// splice(start, deleteCount)
// splice(start, deleteCount, item0)
// splice(start, deleteCount, item0, item1)
//
if (false) {
  const months = ["Jan", "March", "April", "June"];
  months.splice(1, 0, "Feb");
  // Inserts at index 1
  console.log(months);
  // Expected output: Array ["Jan", "Feb", "March", "April", "June"]

  months.splice(4, 1, "May");
  // Replaces 1 element at index 4
  console.log(months);
  // Expected output: Array ["Jan", "Feb", "March", "April", "May"]

  // find index, then replace it:
  const index = new_list.findIndex((el) => el.tpid === tpid);
  new_list.splice(index, 1, update_obj);
}

// remove value-item from Array
// https://stackoverflow.com/questions/3954438/how-to-remove-item-from-array-by-value
if (false) {
  const months = ["Jan", "Feb", "March", "April"];
  const spring = months.filter((element) => element !== "April");
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: truthy / falsy

// # Truthy
// - https://developer.mozilla.org/en-US/docs/Glossary/Truthy
// "In JavaScript, a truthy value is a value that is considered true when encountered in a Boolean context. All values are truthy unless they are defined as falsy. That is, all values are truthy except false, 0, -0, 0n, "", null, undefined, and NaN."

// # Falsy
// - https://developer.mozilla.org/en-US/docs/Glossary/Falsy
// "A falsy (sometimes written falsey) value is a value that is considered false when encountered in a Boolean context."
// The following table provides a COMPLETE list of JavaScript falsy values:
// false       The keyword false.
// 0           The Number zero (so, also 0.0, etc., and 0x0).
// -0          The Number negative zero (so, also -0.0, etc., and -0x0).
// 0n          The BigInt zero (so, also 0x0n). Note that there is no BigInt negative zero — the negation of 0n is 0n.
// "", '', ``  Empty string value.
// null        null — the absence of any value.
// undefined   undefined — the primitive value.
// NaN         NaN — not a number.

// # jdg-NOTE-!!: empty Object {} or Array [] are TRUTHY !!   ==>   so DON'T do: let my_list = [] ; if (!my_list) { # do if empty ..}

// about: Logical NOT

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_NOT#double_not_!!
// "Double NOT (!!) -- It is possible to use a couple of NOT operators in series to explicitly force the conversion of any value to the corresponding boolean primitive. The conversion is based on the "truthyness" or "falsyness" of the value (see truthy and falsy)."

if (false) {
  const my_bool = !!unknown_var_truthy_falsey;
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Primitive Types

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures
// All primitive types, except null and undefined, have their corresponding object wrapper types, which provide useful methods for working with the primitive values. For example, the Number object provides methods like toExponential().

// https://developer.mozilla.org/en-US/docs/Glossary/Primitive
// In JavaScript, a primitive (primitive value, primitive data type) is data that is not an object and has no methods or properties.
// There are 7 primitive data types:
//     string
//     number
//     bigint
//     boolean
//     undefined
//     symbol
//     null

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/undefined

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: typeof

// https://www.w3schools.com/js/js_typeof.asp
// A complex data type can store multiple values and/or different data types together.
// JavaScript has one complex data type:
//     object
// All other complex types like arrays, functions, sets, and maps are just different types of objects.
//
// The typeof operator returns only two types:
//     object
//     function
// Example
// typeof {name:'John'}   // Returns object
// typeof [1,2,3,4]       // Returns object
// typeof new Map()       // Returns object
// typeof new Set()       // Returns object
// typeof function (){}   // Returns function

if (false) {
  if (typeof input === "number") {
    //
  }
  if (typeof input === "string") {
    //
  }
  //
  function f_is_object(val) {
    if (val === null || val === undefined) {
      return false;
    }
    // return typeof val === "function" || typeof val === "object";
    return val === Object(val);
  }
  //
  function f_is_primitive_scalar(test) {
    // https://stackoverflow.com/questions/31538010/test-if-a-variable-is-a-primitive-rather-than-an-object
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/Object
    return test !== Object(test);
  }
  //
  function f_is_empty_object(obj) {
    // idea from: https://stackoverflow.com/questions/679915/how-do-i-test-for-an-empty-javascript-object
    return f_is_object(obj) && Object.keys(obj).length === 0;
  }
  //
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: String

if (false) {
  //
  // # string.toLowerCase()
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/toLowerCase
  const lc = some_str.toLowerCase();

  // # string.toUpperCase()
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/toUpperCase
  const uc = some_str.toUpperCase();

  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes
  // includes(searchString)
  // includes(searchString, position)
  // searchString
  // A string to be searched for within str. Cannot be a regex. All values that are not regexes are coerced to strings, so omitting it or passing undefined causes includes() to search for the string "undefined", which is rarely what you want.
  // position
  // The position within the string at which to begin searching for searchString. (Defaults to 0.)
  "FooBar".includes("oo"); // true
  "FooBar".includes("foo"); // false
  "FooBar".includes("oo", 2); // false

  function f_get_substring_length({ str, length }) {
    let my_str =
      str && typeof str === "string" && str.trim().length > 0 ? str.trim() : "";
    if (my_str.length > length - 3) {
      // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substring
      my_str = my_str.substring(0, length - 3) + "...";
    }
    return my_str;
  }

  function f_sanitize_str_or_default_str(str, default_str) {
    const san_default =
      default_str && typeof default_str === "string" ? default_str.trim() : "";
    const san_str =
      str && typeof str === "string" && str.trim().length > 0
        ? str.trim()
        : san_default;
    return san_str;
  }

  function f_check_sanitize_string(str) {
    return typeof str === "string" ? str.trim() : null;
  }
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: optional chaining (?.) operator

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining
// The optional chaining (?.) operator accesses an object's property or calls a function. If the object accessed or function called using this operator is undefined or null, the expression short circuits and evaluates to undefined instead of throwing an error.
if (false) {
  const obj = undefined;
  // OLD METHOD:
  const nestedProp1 = obj.first && obj.first.second;
  // NEW METHOD:
  const nestedProp2 = obj.first?.second;
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: package.json

// # SemVer package.json
// {
//   "engines": {
//     "node": "16.15.1"           # no ^ or ~ means: exact version
//   },
//   "dependencies": {
//     "bcrypt": "^5.0.1",         # ^ (Caret) means: we require MAJOR version, alternative syntax: "5.x"
//     "compression": "~1.7.4",    # ~ (Tilde) means: we require MAJOR.MINOR version, alternative syntax: "1.7.x"
//   },
// }

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:
// # Node Command-line Arguments

// https://nodejs.org/en/knowledge/command-line/how-to-parse-command-line-arguments/

// $ cat argv.js
// console.log("process.argv = ", process.argv);
//
// $ node argv.js one two three four five
//
// process.argv = [
//   'node',
//   '/home/avian/argvdemo/argv.js',
//   'one',
//   'two',
//   'three',
//   'four',
//   'five'
// ]

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:
// - - - - - - = = = - - - - - -
// # Named and Default exports (ES5-in-browser, or in Node.js 'ES-module'):

// https://nodejs.org/dist/latest-v16.x/docs/api/packages.html
// "
// Node.js will treat the following as ES modules: Files with an .mjs extension, package.json contains {"type":"module"}
// Node.js will treat as CommonJS all other forms of input
// "

// # file: my_exports_module.js
//
// export function my_function() {
//   // <=== NAMED EXPORT, import this using its name within { braces }
//   console.log('# running: my_function() ');
// }
// export default class MyClass {
//   // <=== DEFAULT EXPORT, import this using its name without { braces }
//   constructor(arg1) {
//     this.my_property = arg1;
//   }
//   my_method1() {
//     console.log(`# my_property = ${this.my_property} `);
//   }
// }

// # file: my_imports_demo.js
//
// import MyClass, { my_function } from './my_exports_module.mjs'; // <=== HOW-TO-IMPORT
// my_function();
// const my_class = new MyClass('some_argument_here');
// my_class.my_method1();

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// About ES-Module style 'import':

// just import, no need for variable:
import "express-async-errors";

// import external module (nmp):
import morgan from "morgan";

// if importing default object, then you can assign any name:
import require_express from "express";

// import local/internal module:
import { f_specific_func } from "../../lib_glob/functions.js";
import * as lib_funcs from "../../lib_glob/functions.js";

// import default object:
import lib_meta from "../../lib_glob/meta.js";

// special case: import from CommonJS module:
//
// CJS==>  const { Pool } = require("pg"); // npm i pg
//
// import { Pool } from "pg";
//          ^^^^
// SyntaxError: Named export 'Pool' not found. The requested module 'pg' is a CommonJS module, which may not support all module.exports as named exports.
// CommonJS modules can always be imported via the default export, for example using:
// import pkg from 'pg';
// const { Pool } = pkg;
//
import import__pg from "pg";
const { Pool } = import__pg;

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// About 'async import':

// -- INSTEAD normal 'import':
// import "../../jdbl/jdbl-pouchdb.lib.js";
// import f_build_router_for_model_name_singleton from "./routes/model_name__singleton_router.js";
// -- WE DO async 'import' func:
// await import("../../jdbl/jdbl-pouchdb.lib.js");
// const f_build_router_for_model_name_singleton = await import("./routes/model_name__singleton_router.js");
//
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import
// "The import() syntax, commonly called dynamic import, is a function-like expression that allows loading an ECMAScript module asynchronously and dynamically into a potentially non-module environment."
// "Unlike the declaration-style counterpart, dynamic imports are only evaluated when needed, and permit greater syntactic flexibility."
// "Return value:"
// "Returns a promise which fulfills to a module namespace object: an object containing all exports from moduleName."

// do all async work here in this 'top-level-await', including 'await import()' :
// https://www.stefanjudis.com/today-i-learned/top-level-await-is-available-in-node-js-modules/
//
async function fa_main() {
  const func_name = `${mod_name}.fa_main()`;
  console.log(`# ${func_name}: started.`);
  // ...
  await import("some");
  // ...
}
// call async-func from top-level:
fa_main();

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:
// - - - - - - = = = - - - - - -
// # about: Error() and try-catch and new-operator

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
if (false) {
  try {
    // throw "unknown action"; // <== gives error in ESlint: "Expected an error object to be thrown  no-throw-literal"
    throw new Error("Whoops!");
  } catch (err) {
    console.error(`${err.name}: ${err.message}`); // [gives:] Error: Whoops!
  }
}

// # jdg:
// # ==> with the "throw my_expression" statement, control goes to the nearest try-catch(e) block with e = my_expression (can be string or object)

// seen on: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/throw
// (Node, ed.) "Runtime errors result in new Error objects being created and thrown."
//
if (false) {
  function UserException(message) {
    this.message = message;
    this.name = "UserException";
  }
  const my_obj = new UserException("InvalidMonthNo"); // JDG: <=== apparently the 'new' statement turns a function call into an object ?!?
  //
  console.info(`${JSON.stringify(my_obj)}`); // [gives:] {"message":"InvalidMonthNo","name":"UserException"}
}

// seen on: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new
if (false) {
  function Car(make, model, year) {
    this.make = make;
    this.model = model;
    this.year = year;
  }
  const car1 = new Car("Eagle", "Talon TSi", 1993);
  console.log(car1.make);
  // expected output: "Eagle"
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:
// - - - - - - = = = - - - - - -
// about: Promise and .then() .catch()

if (false) {
  const my_promise_based_func = function (props) {
    return new Promise((resolve, reject) => {
      if (props.a == props.b) {
        resolve("my_resolve_expression_can_be_string");
      } else {
        reject(new Error("my_reject_string_as_part_of_Error")); // jdg-note: creating an Error does not mean we throw anything (Error is just an object!)
      }
    });
  };
  //
  const result_promise = my_promise_based_func({ a: 1, b: 2 });
  //
  result_promise
    .then((result) => console.log("Result", result))
    .catch((err) => console.log("Error", err.message));
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Math div remainer (modulo, mod)

// https://stackoverflow.com/questions/4228356/how-to-perform-an-integer-division-and-separately-get-the-remainder-in-javascr
if (false) {
  const quotient = Math.floor(y / x);
  const remainder = y % x;
  //
  // ~ operator ==> https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_NOT
  // use: ~~ to make sure the result is a number or 0 is anything else
  // note: ~~ is the only convertion that gives 0 when string is NaN
  var num = ~~(a / b);
  //
  var div = Math.trunc(y / x);
  var rem = y % x;
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: IIFE

// https://developer.mozilla.org/en-US/docs/Glossary/IIFE
// An IIFE (Immediately Invoked Function Expression) is a JavaScript function that runs as soon as it is defined.

if (false) {
  (function () {
    // …
  })();

  (() => {
    // …
  })();

  (async () => {
    // …
  })();
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// About: setInterval

// https://developer.mozilla.org/en-US/docs/Web/API/setInterval

if (false) {
  setInterval(func, delay, arg1, arg2);
  //
  // Vue.js
  // define an async-func first, that is executed synchroniously later in setInterval:
  const fa_body_set_interval = async () => {
    await fa_update_api();
  };
  //
  let interval = undefined;
  onMounted(async () => {
    // save the return_value in variable 'interval' so we can do: clearInterval(interval)
    interval = setInterval(() => {
      fa_body_set_interval();
    }, 3 * 1000);
  });
  onUnmounted(async () => {
    clearInterval(interval);
  });
}

//: - - - - - - = = = - - - - - - .
// About: setTimeout

// similar regarding async:
// https://developer.mozilla.org/en-US/docs/Web/API/setTimeout
// "The setTimeout() method of the Window interface sets a timer which executes a function or specified piece of code once the timer expires."

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURI
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURI

// in console web browser:
if (false) {
  console.log(decodeURI(window.location.href));
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: RegExp Regular Expressions
// tags: regex

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp
if (true) {
  // The following three expressions create the same regular expression object:
  const re1 = /ab+c/i; // literal notation
  // OR
  const re2 = new RegExp("ab+c", "i"); // constructor with string pattern as first argument
  // OR
  const re3 = new RegExp(/ab+c/, "i"); // constructor with regular expression literal as first argument
  //
  // When using the constructor function, the normal string escape rules (preceding special characters with \ when included in a string) are necessary.
  // For example, the following are equivalent:
  const re_a = /\w+/;
  // OR
  const re_b = new RegExp("\\w+");
  //
  const str = "table football";
  const regex = new RegExp("foo*");
  const globalRegex = new RegExp("foo*", "g");
  console.log(regex.test(str));
  // expected output: true
  //
  if (/\.sh$/.test(file_name)) {
    // do something
  }
  //
  const query_duration = "4W";
  const m = query_duration.match(/^(\d+)([smhDWMY])$/);
  // [ '4W', '4', 'W', index: 0, input: '4W', groups: undefined ]
  const entire_match = m[0];
  const duration_nr = m[1] || 0;
  const duration_unit = m[2] || "";
  //
  const a = rep_str.toLowerCase().match(/[0-9a-f]{2}/g);
  rep_str_colons = `${a[0]}:${a[1]}:${a[2]}${a[3]}:${a[4]}::${rep_str.substr(
    5 * 2
  )}.`;
  //
  // replace using RE:
  const reg_exp = new RegExp(`{{${v_key}}}`, "g");
  output_string = output_string.replace(reg_exp, v_val);
  // or replace with backreferences:
  const reg_exp2 = new RegExp(`^(<[^>]*>,[0-9]+,...).*?(...)$`);
  const hex_file_short = hex_file.replace(reg_exp2, "$1...$2");
  //
  // replace/substitution:
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace
  const regex_replace = "(some)".replace(/[\(\)]/g, "");
  // gives: some
  const regex_replace2 = '"some"'.replace(/["]/g, "");
  //
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:
// about: deleting a key from an Object

if (false) {
  let person = { name: "John" };
  // do this:
  delete person.name;
  //
  // this is NOT THE SAME as deleting:
  person.name = undefined;
  //
}
// see: https://thisthat.dev/delete-object-property-vs-set-object-property-to-undefined/

// delete ==> https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/delete
// "If the property which you are trying to delete does not exist, delete will not have any effect and will return true."

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:
// Number types & Bitwise operators:

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Numbers_and_dates
// literal octal number:       077
// literal binary number:      0b01010101
// literal hexadecimal number: 0x99
// literal exponentiation:     0.1e2 // =10
// BigInt (beyond 64-bit int)  1234567890987654321n

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Expressions_and_Operators#bitwise_operators
// Operator     Usage   Description
// Bitwise AND  a & b   Returns a one in each bit position for which the corresponding bits of both operands are ones.
// Bitwise OR   a | b   Returns a zero in each bit position for which the corresponding bits of both operands are zeros.
// Bitwise XOR  a ^ b   Returns a zero in each bit position for which the corresponding bits are the same. [Returns a one in each bit position for which the corresponding bits are different.]
// Bitwise NOT  ~ a     Inverts the bits of its operand.
// Left shift   a << b  Shifts a in binary representation b bits to the left, shifting in zeros from the right.
// Sign-propagating right shift  a >> b  Shifts a in binary representation b bits to the right, discarding bits shifted off.
// Zero-fill right shift         a >>> b  Shifts a in binary representation b bits to the right, discarding bits shifted off, and shifting in zeros from the left.

// convert bits in string to number, and back:
function f_nr_to_byte_string(nr) {
  if (nr < 0 || nr > 255 || nr % 1 !== 0) {
    return "";
  }
  return ("000000000" + nr.toString(2)).substr(-8);
  // Usage: const byte_string = f_nr_to_byte_string(nr);
  // Note: reverse function is: const nr = parseInt(byte_string, 2)
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - -
// about: hexadecimal

// example from: https://www.npmjs.com/package/debug
if (false) {
  const createDebug = require("debug");
  createDebug.formatters.h = (v) => {
    return v.toString("hex");
  };
  const debug = createDebug("foo");
  debug("this is hex: %h", new Buffer("hello world"));
  //   foo this is hex: 68656c6c6f20776f726c6421 +0ms
}
//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Loop methods:

if (false) {
  // *) forEach  // <== use this if you need the index (and then update an element in the array)
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach
  //
  array1.forEach((element) => console.log(element));
  //
  ArrayToLog.forEach((element, index /*, array */) => {
    console.log(`a[${index}] = ${element}`);
  });

  // *) for..of
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...of
  for (const element of array1) {
    console.log(element);
  }

  // *) for..in
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...in
  // note: this for...in is designed for objects not arrays -- adviced to use for-loop
  // "It is better to use a for loop with a numeric index, Array.prototype.forEach(), or the for...of loop, because they will return the index as a number instead of a string, and also avoid non-index properties."
  for (let index in array1) {
    const element = array1[index];
    console.log(`array1[${index}] = ${element} `);
  }

  // *) for
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for
  for (let i = 0; i < 9; i++) {
    str = str + i;
  }
  //
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: URL

if (false) {
  const api_url_limit = 100;
  //
  let url_obj = new URL("http://some.org/api");
  let params = new URLSearchParams(url_obj.search); // <== initiate with current .search
  params.append("limit", api_url_limit);
  url_obj.search = params;
  //
  const response = await http_svc.get(
    url_obj,
    {},
    { timeout: model.api_timeout_ms }
  );
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Set unique Array

if (false) {
  var myArray = ["a", 1, "a", 2, "1"];
  // ... is spread_operator
  let unique = [...new Set(myArray)];
  console.log(unique); // unique is ['a', 1, 2, '1']
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: spread operator

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax#spread_in_function_calls
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax#spread_in_array_literals
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax#spread_in_object_literals
// "When one object is spread into another object, or when multiple objects are spread into one object, and properties with identical names are encountered, the property takes the last value assigned while remaining in the position it was originally set."

if (false) {
  const obj1 = { a: 1, b: 2, c: 3 };
  const obj2 = { b: "two", d: 4 };
  const obj3 = { ...obj1, ...obj2 };
  //  obj3 = { a: 1, b: "two", c: 3, d: 4 }

  // also used in: object destructering
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
  const a = { b: { c: "Hi!" } }; // <== construct object
  const {
    b: new_name_for_b,
    b: { c },
  } = a; // <== destruct object
  console.log(new_name_for_b); // { c: 'Hi!' }
  console.log(c); // // 'Hi!'
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Axios

// https://github.com/axios/axios
// https://axios-http.com/docs/intro
// https://axios-http.com/docs/interceptors
// const axios = require("axios"); // import axios from "axios";   // npm i axios --save // https://axios-http.com/docs/intro

// https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
// 1xx informational response
// 2xx success
//    200 OK
//    Standard response for successful HTTP requests.
// 3xx redirection
//    304 Not Modified (RFC 7232)
// 4xx client errors
//    400 Bad Request
//    401 Unauthorized (RFC 7235)
//    402 Payment Required
//    403 Forbidden
//    404 Not Found
//    405 Method Not Allowed
// 5xx server errors
//    500 Internal Server Error
//    501 Not Implemented
//    502 Bad Gateway
//    503 Service Unavailable
//    504 Gateway Timeout

// https://axios-http.com/docs/handling_errors
//
if (false) {
  //
  // Handling Errors
  //
  axios.get("/user/12345").catch(function (error) {
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      console.log(error.response.data);
      console.log(error.response.status);
      console.log(error.response.headers);
    } else if (error.request) {
      // The request was made but no response was received
      // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
      // http.ClientRequest in node.js
      console.log(error.request);
    } else {
      // Something happened in setting up the request that triggered an Error
      console.log("Error", error.message);
    }
    console.log(error.config);
  });
  //
  // Using the validateStatus config option, you can define HTTP code(s) that should throw an error.
  //
  axios.get("/user/12345", {
    validateStatus: function (status) {
      return status < 500; // Resolve only if the status code is less than 500
    },
  });
  //
  // Using toJSON you get an object with more information about the HTTP error.
  axios.get("/user/12345").catch(function (error) {
    console.log(error.toJSON());
  });
}

// About: the 'converting-circular-structure-to-json' problem
//
// from Axios I get this error:
// "Unknown error, error.message=Converting circular structure to JSON --> starting at object with constructor 'ClientRequest' | property 'socket' -> object with constructor 'TLSSocket' --- property '_httpMessage' closes the circle"
//
// https://stackoverflow.com/questions/45319090/axios-gives-me-converting-circular-structure-to-json-error-while-sending-the-dat
// "This happens many a time with axios because sometimes we directly return the response from the endpoint. For example, this error will occur if we pass the response directly, rather than passing the response.data"

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Object.entries()

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries
if (false) {
  const obj = { foo: "bar", baz: 42 };
  console.log(Object.entries(obj)); // [ ['foo', 'bar'], ['baz', 42] ]
  //
  for (let [key, val] of Object.entries(mqtt_obj)) {
    //
  }
}
// NOTE:
// reverse of Object.entries() is Object.fromEntries()
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/fromEntries

// sort an Object by keys:
if (false) {
  //
  // https://stackoverflow.com/questions/5467129/sort-javascript-object-by-key
  var data = {
    zIndex: 99,
    name: "sravan",
    age: 25,
    position: "architect",
    amount: "100k",
    manager: "mammu",
  };
  console.log(
    Object.entries(data)
      .sort()
      .reduce((o, [k, v]) => ((o[k] = v), o), {})
  );
  // gives:
  // {
  //   age: 25,
  //   amount: '100k',
  //   manager: 'mammu',
  //   name: 'sravan',
  //   position: 'architect',
  //   zIndex: 99
  // }
  //
  // same as:
  Object.fromEntries(Object.entries(data).sort());
  //
  // sort by specific key:
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort
  // "The sort() method of Array instances sorts the elements of an array in place and returns the reference to the same array, now sorted."
  //
  // compareFn(a, b) return value -- sort order
  // > 0 	                        -- sort a after b     , e.g. [b, a]
  // < 0 	                        -- sort a before b    , e.g. [a, b]
  // === 0 	                      -- keep original order of a and b
  //
  // about sorting 'strings'
  // - ASCII is sorted by:          (a, b) => b - a
  // - non-ASCI can be sorted by:   (a, b) => a.localeCompare(b)
  //
  Object.fromEntries(Object.entries(data).sort((a, b) => a.tpid - b.tpid));
  Object.fromEntries(
    Object.entries(data).sort((a, b) => a.tpid.localeCompare(b.tpid))
  );
  //
  let parent_obj = {
    a: 1,
    c: 2,
    b: 3,
    z: 26,
    arr: [1, 2, 3],
    obj: { k1: 1, k2: 2 },
  };
  Object.entries(parent_obj).forEach(([key, value], index) =>
    console.log(
      `# key='${key}' typeof:value='${typeof value}' index='${index}'`
    )
  );
  // # key='a' typeof:value='number' index='0'
  // # key='c' typeof:value='number' index='1'
  // # key='b' typeof:value='number' index='2'
  // # key='z' typeof:value='number' index='3'
  // # key='arr' typeof:value='object' index='4'
  // # key='obj' typeof:value='object' index='5'
  //
  parent_obj = Object.fromEntries(Object.entries(parent_obj).sort());
  // { a: 1, arr: [ 1, 2, 3 ], b: 3, c: 2, obj: { k1: 1, k2: 2 }, z: 26 }
  //
  Object.entries(parent_obj).forEach(([key, value], index) =>
    console.log(
      `# key='${key}' typeof:value='${typeof value}' index='${index}'`
    )
  );
  // # key='a' typeof:value='number' index='0'
  // # key='arr' typeof:value='object' index='1'
  // # key='b' typeof:value='number' index='2'
  // # key='c' typeof:value='number' index='3'
  // # key='obj' typeof:value='object' index='4'
  // # key='z' typeof:value='number' index='5'
  //
  parent_obj = Object.fromEntries(
    Object.entries(parent_obj).sort(([k1, v1], [k2, v2]) => {
      console.log(`# k1='${k1}' k2='${k2}'`);
      return k1.localeCompare(k2);
    })
  );
  // # k1='obj' k2='z'
  // # k1='c' k2='obj'
  // # k1='b' k2='c'
  // # k1='arr' k2='b'
  // # k1='a' k2='arr'
  // { a: 1, arr: [ 1, 2, 3 ], b: 3, c: 2, obj: { k1: 1, k2: 2 }, z: 26 }
  //
  parent_obj = Object.fromEntries(
    Object.entries(parent_obj).sort(([k1, v1], [k2, v2]) => {
      console.log(`# k1='${k1}' k2='${k2}'`);
      return k2.localeCompare(k1);
    })
  );
  // # k1='arr' k2='a'
  // # k1='b' k2='arr'
  // # k1='c' k2='b'
  // # k1='obj' k2='c'
  // # k1='z' k2='obj'
  // { z: 26, obj: { k1: 1, k2: 2 }, c: 2, b: 3, arr: [ 1, 2, 3 ], a: 1 }
  //
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Array.filter()

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter
// "The filter() method of Array instances creates a shallow copy of a portion of a given array, filtered down to just the elements from the given array that pass the test implemented by the provided function."

if (false) {
  const words = ["spray", "elite", "exuberant", "destruction", "present"];
  const result = words.filter((word) => word.length > 6);
  console.log(result);
  // Expected output: Array ["exuberant", "destruction", "present"]
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Array intersecion

// https://stackoverflow.com/questions/1885557/simplest-code-for-array-intersection-in-javascript

if (false) {
  const array_intersection = array_1.filter((element) =>
    array_2.includes(element)
  );
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Number conversion

https: if (false) {
  const nr = parseInt(number_string, 10);

  // ~ operator ==> https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_NOT
  // Use: ~~ is a shortcut for Math.floor(), but it also gives 0 for string or NaN.
  // Note: ~~ is the only convertion that gives 0 when string is NaN
  // ~~5.5 === 5
  // ~~"5.5" === 5
  // ~~"a_string" === 0
  // ~~{} === 0
  // ~~(1/0) === 0
  this.dev_major = ("000" + ~~this.dev_major).slice(-3);
}

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: Process exit handler

async function fa_on_exit() {
  // ...
  process.exit(1);
}
// https://nodejs.org/api/process.html#event-exit
process.on("exit", fa_on_exit);
// https://nodejs.org/api/process.html#signal-events
process.on("SIGHUP", fa_on_exit);
process.on("SIGINT", fa_on_exit);
//
// https://stackoverflow.com/questions/14031763/doing-a-cleanup-action-just-before-node-js-exits
// [`exit`, `SIGINT`, `SIGUSR1`, `SIGUSR2`, `uncaughtException`, `SIGTERM`].forEach((eventType) => {
//   process.on(eventType, cleanUpServer.bind(null, eventType));
// })

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about: (Node) CommonJS modules vs. ECMAScript modules (ESM)

// https://nodejs.org/api/esm.html#introduction

// https://nodejs.org/api/modules.html#modules-commonjs-modules

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// about:

//: - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// - - - - - - = = = - - - - - -
//-eof
