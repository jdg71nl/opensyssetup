#!/usr/local/bin/node
//= 

// import { createInterface } from "node:readline"
const { createInterface} = require("node:readline");
//const readline , { createInterface} = require("node:readline");
//const { stdin: input, stdout: output } = require('node:process');

// https://nodejs.org/en/knowledge/command-line/how-to-parse-command-line-arguments/
//
// > cat argv.js
// console.log(process.argv);
//
// > node argv.js one two three four five
// [ 'node','/home/avian/argvdemo/argv.js','one','two','three','four','five' ]

const sort_field = process.argv[2] || "";
const allowed_sort_fields = [
  "bssid",
  "freq",
  "level",
  "flags",
  "ssid",
];
//const allowed_sort_fields = ["bssid","freq","level","flags","ssid",];

// # bssid / frequency / signal level / flags / ssid
// # 74:da:38:67:a2:f6     2437    -75     [WPA2-PSK-CCMP][ESS]    kz44-direct-2G

let list = [];

function f_hash_to_string_list(hash) {
  let string_list = [];
  hash.forEach((entry) => {
    const string_line = `${entry.bssid} - ${entry.freq} - ${entry.level} - ${entry.flags} - ${entry.ssid}`;
    string_list.push(string_line);
  });
  return string_list;
}

async function fa_main() {
  //
  for await (const line of createInterface({ input: process.stdin })) {
    //console.log(`# ${line}`)
    const fields = line.split('\t');
    //console.log(`# `, fields)
    const hash = {
      bssid: fields[0],
      freq:  fields[1],
      level: fields[2],
      flags: fields[3],
      ssid:  fields[4],
    };
    list.push(hash);
  }
  //
  //console.log(`# list=`, list)
  //
  //const string_list = f_hash_to_string_list(list);
  //console.log(`# string_list=`, string_list)
  //
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort
  const sorted = list.sort((a,b) => {
    const a_key = a[sort_field] || 0;
    const b_key = b[sort_field] || 0;
    if (a_key < b_key) {
      return -1;
    } else if (b_key < a_key) {
      return 1;
    }
    return 0;
  });
  //
  //console.log(`# sorted=`, sorted)
  const sorted_string_list = f_hash_to_string_list(sorted);
  console.log(`# sorted_string_list=`, sorted_string_list)
  //
}
fa_main();

//-eof


