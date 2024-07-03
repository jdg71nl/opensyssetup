#!/bin/bash
#= jest_run_here.sh
JEST_RT="./node_modules/jest/bin/jest.js "
NODE_ENV=development $JEST_RT --watchAll --verbose
#-eof