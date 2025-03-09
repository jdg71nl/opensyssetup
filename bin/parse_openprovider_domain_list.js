#!/usr/bin/node
// #!/usr/local/bin/node
const my_file_name = "parse_openprovider_domain_list.js";

const fs = require("fs");

const json_file = process.argv[2];

function print_help() {
  // https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
  // <angle>        brackets for required parameters:   ping <hostname>
  // [square]       brackets for optional parameters:   mkdir [-p] <dirname>
  // ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
  // vertical |     bars for choice of items:           netstat {-t|-u}
  //
  console.log(`\n# Usage: ${my_file_name} { <filename.json> | - } `);
}

if (!json_file) {
  print_help();
  process.exit(0);
}

const json_obj_example = {
  code: 0,
  desc: "",
  data: {
    results: [
      {
        id: 23714003,
        reseller_id: 299144,
        nsgroup_id: 14099356,
        domain: {
          name: "fair-point",
          extension: "org",
        },
        name_servers: [
          {
            seq_nr: 0,
            name: "ns1.j71.nl",
          },
          {
            seq_nr: 1,
            name: "ns2.j71.nl",
          },
        ],
        creation_date: "2022-05-15 15:12:02",
        last_changed: "2024-06-26 08:13:24",
        expiration_date: "2025-05-15 15:12:02",
        dnssec: "signedDelegation",
        status: "ACT",
        dnssec_keys: [
          {
            protocol: 3,
            flags: 256,
            alg: 13,
            pub_key:
              "luQjlmnMhmjRZdkV4RHbK2IFDkJmKzvlNNASPVBv37Ql+vp7ZmGlog4fFUpQHOqkGDuR2/g0k/c8YQWCYTiv7Q==",
          },
          {
            protocol: 3,
            flags: 257,
            alg: 13,
            pub_key:
              "FxcIPbOcbh3TJEh3KcaVjSu+rgbHi8lTGdUh4uOrEaW0i2U4zR4WYVNe7n/g/i3NPmSqL/vuXVE4rnZ79Y5ryw==",
          },
        ],
      },
    ],
    total: 41,
  },
};

let json_obj = undefined;
//
try {
  //
  const json_contents = fs.readFileSync(json_file, {
    encoding: "utf8",
    flag: "r",
  });
  json_obj = JSON.parse(json_contents);
  //
} catch (e) {
  console.error(e.message);
  process.exit(1);
}

let domain_list = [];
//
async function fa_main() {
  // console.log(`start: fa_main()`);
  //
  json_obj?.data?.results.forEach((el) => {
    const domain_name = `${el?.domain?.name}.${el?.domain?.extension}`;
    // console.log(`${domain_name}`);
    domain_list.push(domain_name);
  });
  //
  domain_list.sort().forEach((el) => console.log(el));
  //
}
fa_main();

//-eof
