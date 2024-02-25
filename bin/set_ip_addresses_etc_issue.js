//= ./bin/set_ip_addresses_etc_issue.js

import * as jdbl from "../jdbl/jdbl-main.lib.js";
const site_static_config = jdbl.f_get_site_static_config();

import { f_get_current_ip_addresses } from "../api_server/src/lib/network.lib.js";

const server_shortname = (site_static_config.web_ui && site_static_config.web_ui.server_shortname) || "TSS";

const ip_address = f_get_current_ip_addresses();

const issue_string = `Login Debian-Linux console \\l [${server_shortname}, LAN=${ip_address.lan}, WLAN=${ip_address.wlan}, VPN=${ip_address.vpn}] `;

console.log(issue_string);

//-eof
