#!/usr/bin/env node
// - - - - - - = = = - - - - - - .
//= ./node_run_example.mjs
const mod_name = "node_run_example.mjs";
//
const func_name = `${mod_name}.global`; // <== default, needs to be locally overwritten
console.log(`# \n# ${func_name}: started.`);

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

import * as fs from "node:fs";

// const readline = require("readline")
import readline from "node:readline/promises";

// import moment_js from 'moment'; // npm i moment
// import moment_js from 'moment-timezone'; // npm i moment-timezone
// const moment_js = require("moment"); // npm i moment --save
// https://momentjs.com/

// https://lodash.com/docs/4.17.15#get
// import _ from 'lodash'; // npm i lodash

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

// https://nodejs.org/en/knowledge/command-line/how-to-parse-command-line-arguments/
// console.log(process.argv);
// [ 'node',
//   '/home/avian/argvdemo/argv.js',
//   'one',
//   'two',
//   'three',
//   'four',
//   'five' ]
// if (process.argv[2] === "one") {}

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

function f_date_to_nicetime_str(date) {
  // return moment_js(date).format("YYYY-MMM-DD/HH:mm:ss")
}

function f_get_date_now() {
  const date_now = new Date();
  return date_now;
}

function f_get_epoch_now() {
  const date_now = new Date();
  const epoch_now = Math.round(date_now / 1000);
  return epoch_now;
}

function f_is_object(val) {
  if (val === null) {
    return false;
  }
  return typeof val === "function" || typeof val === "object";
}

function f_pretty_json_stringify(obj) {
  return JSON.stringify(obj, null, 2);
}

function f_js(obj) {
  return JSON.stringify(obj);
}

function f_sanitize_str_or_default_str({ str, default_str }) {
  const san_default =
    default_str &&
    typeof default_str === "string" &&
    default_str.trim().length > 0
      ? default_str.trim()
      : "";
  const san_str =
    str && typeof str === "string" && str.trim().length > 0
      ? str.trim()
      : san_default;
  return san_str;
}

// eslint-disable-next-line
const regex_ascii_all = /^[\x00-\x7f]*$/; // reference: https://en.wikipedia.org/wiki/ASCII
const regex_hexstring = new RegExp("^[a-zA-Z0-9]*$");

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

async function fa_main() {
  const func_name = `${mod_name}.fa_main`;
  //
  try {
    //
    // do somethin terrible...
    //
    // // async-readline (line-by-line):
    // // https://stackoverflow.com/questions/20086849/how-to-read-from-stdin-line-by-line-in-node
    // for await (const line of readline.createInterface({
    //   input: process.stdin,
    // })) {
    //   console.log(line);
    // }
    // // test: > (echo echo1; sleep 2; echo echo2; sleep 2; echo echo3) | ./node_run_example.mjs
    //
    // sync-readline (whole file):
    const input = fs.readFileSync(process.stdin.fd).toString();
    //
  } catch (ex) {
    console.log(`# ${func_name}: try-catch error=`, ex);
  }
}
fa_main();

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// - - - - - - = = = - - - - - - .
//-eof
