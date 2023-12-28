#!/usr/bin/node
//= test_bme680-sensor

// https://www.npmjs.com/package/bme680-sensor
// npm install bme680-sensor
'use strict';

const { Bme680 } = require('bme680-sensor');
const bme680 = new Bme680(1, 0x77);

async function fa_main() {

//-   //
//-   bme680.initialize().then(async () => {
//-     console.info('Sensor initialized');
//-     setInterval(async () => {
//-       console.info(await bme680.getSensorData());
//-     }, 3000);
//-   });

  //
  await bme680.initialize();
  console.info('Sensor initialized');
  const data = await bme680.getSensorData();
  console.info(data);

}
fa_main();

//#-eof


//- 
//- --[CWD=~/dev/test_bme680-sensor]--[1703752441 09:34:01 Thu 28-Dec-2023 CET]--[jdg@rpi4b-virb-mainrouter]--[hw:RPI4b-1.5,os:Debian-11/bullseye,kernel:6.1.21-v8+,isa:aarch64]------
//- > ./test_bme680-sensor.js 
//- Sensor initialized
//- BME680Data {
//-   chip_id: 97,
//-   chip_variant: 0,
//-   dev_id: null,
//-   intf: null,
//-   mem_page: null,
//-   ambient_temperature: 1930,
//-   data: FieldData {
//-     status: 32,
//-     heat_stable: false,
//-     gas_index: 0,
//-     meas_index: 0,
//-     temperature: 19.3,
//-     pressure: 1009.22,
//-     humidity: 57.191,
//-     gas_resistance: 4648.936110863161
//-   },
//-   calibration_data: CalibrationData {
//-     par_h1: 682,
//-     par_h2: 1028,
//-     par_h3: 0,
//-     par_h4: 45,
//-     par_h5: 20,
//-     par_h6: 120,
//-     par_h7: -100,
//-     par_gh1: -50,
//-     par_gh2: -9036,
//-     par_gh3: 18,
//-     par_t1: 26018,
//-     par_t2: 26500,
//-     par_t3: 3,
//-     par_p1: 36135,
//-     par_p2: -10193,
//-     par_p3: 88,
//-     par_p4: 9932,
//-     par_p5: -222,
//-     par_p6: 30,
//-     par_p7: 29,
//-     par_p8: -1093,
//-     par_p9: -3233,
//-     par_p10: 30,
//-     t_fine: 98802,
//-     res_heat_range: 1,
//-     res_heat_val: 36,
//-     range_sw_err: 0
//-   },
//-   tph_settings: TPHSettings { os_hum: 2, os_temp: 4, os_pres: 3, filter: 2 },
//-   gas_settings: GasSettings {
//-     nb_conv: 0,
//-     heatr_ctrl: null,
//-     run_gas: 1,
//-     heatr_temp: 320,
//-     heatr_dur: 150
//-   },
//-   power_mode: 1,
//-   new_fields: null
//- }
//- BME680Data {
//-   chip_id: 97,
//-   chip_variant: 0,
//-   dev_id: null,
//-   intf: null,
//-   mem_page: null,
//-   ambient_temperature: 1930,
//-   data: FieldData {
//-     status: 48,
//-     heat_stable: true,
//-     gas_index: 0,
//-     meas_index: 0,
//-     temperature: 19.3,
//-     pressure: 1009.26,
//-     humidity: 57.14,
//-     gas_resistance: 782.5004907586374
//-   },
//-   calibration_data: CalibrationData {
//-     par_h1: 682,
//-     par_h2: 1028,
//-     par_h3: 0,
//-     par_h4: 45,
//-     par_h5: 20,
//-     par_h6: 120,
//-     par_h7: -100,
//-     par_gh1: -50,
//-     par_gh2: -9036,
//-     par_gh3: 18,
//-     par_t1: 26018,
//-     par_t2: 26500,
//-     par_t3: 3,
//-     par_p1: 36135,
//-     par_p2: -10193,
//-     par_p3: 88,
//-     par_p4: 9932,
//-     par_p5: -222,
//-     par_p6: 30,
//-     par_p7: 29,
//-     par_p8: -1093,
//-     par_p9: -3233,
//-     par_p10: 30,
//-     t_fine: 98841,
//-     res_heat_range: 1,
//-     res_heat_val: 36,
//-     range_sw_err: 0
//-   },
//-   tph_settings: TPHSettings { os_hum: 2, os_temp: 4, os_pres: 3, filter: 2 },
//-   gas_settings: GasSettings {
//-     nb_conv: 0,
//-     heatr_ctrl: null,
//-     run_gas: 1,
//-     heatr_temp: 320,
//-     heatr_dur: 150
//-   },
//-   power_mode: 1,
//-   new_fields: null
//- }
//- ^C
//- #( bash[PROMPT_COMMAND]: prev.cmd returned non-zero code: 130 )
//- --[CWD=~/dev/test_bme680-sensor]--[1703752450 09:34:10 Thu 28-Dec-2023 CET]--[jdg@rpi4b-virb-mainrouter]--[hw:RPI4b-1.5,os:Debian-11/bullseye,kernel:6.1.21-v8+,isa:aarch64]------
//- > 


//- --[CWD=~/dev/test_bme680-sensor]--[1703797509 22:05:09 Thu 28-Dec-2023 CET]--[jdg@rpi4b-virb-mainrouter]--[hw:RPI4b-1.5,os:Debian-11/bullseye,kernel:6.1.21-v8+,isa:aarch64]------
//- > ./test_bme680-sensor.js 
//- Sensor initialized
//- BME680Data {
//-   chip_id: 97,
//-   chip_variant: 0,
//-   dev_id: null,
//-   intf: null,
//-   mem_page: null,
//-   ambient_temperature: 1274,
//-   data: FieldData {
//-     status: 32,
//-     heat_stable: false,
//-     gas_index: 0,
//-     meas_index: 0,
//-     temperature: 12.74,
//-     pressure: 1007.26,
//-     humidity: 77.441,
//-     gas_resistance: 4427.614660375754
//-   },
//-   calibration_data: CalibrationData {
//-     par_h1: 682,
//-     par_h2: 1028,
//-     par_h3: 0,
//-     par_h4: 45,
//-     par_h5: 20,
//-     par_h6: 120,
//-     par_h7: -100,
//-     par_gh1: -50,
//-     par_gh2: -9036,
//-     par_gh3: 18,
//-     par_t1: 26018,
//-     par_t2: 26500,
//-     par_t3: 3,
//-     par_p1: 36135,
//-     par_p2: -10193,
//-     par_p3: 88,
//-     par_p4: 9932,
//-     par_p5: -222,
//-     par_p6: 30,
//-     par_p7: 29,
//-     par_p8: -1093,
//-     par_p9: -3233,
//-     par_p10: 30,
//-     t_fine: 65205,
//-     res_heat_range: 1,
//-     res_heat_val: 36,
//-     range_sw_err: 0
//-   },
//-   tph_settings: TPHSettings { os_hum: 2, os_temp: 4, os_pres: 3, filter: 2 },
//-   gas_settings: GasSettings {
//-     nb_conv: 0,
//-     heatr_ctrl: null,
//-     run_gas: 1,
//-     heatr_temp: 320,
//-     heatr_dur: 150
//-   },
//-   power_mode: 1,
//-   new_fields: null
//- }
//- --[CWD=~/dev/test_bme680-sensor]--[1703797512 22:05:12 Thu 28-Dec-2023 CET]--[jdg@rpi4b-virb-mainrouter]--[hw:RPI4b-1.5,os:Debian-11/bullseye,kernel:6.1.21-v8+,isa:aarch64]------
//- 

