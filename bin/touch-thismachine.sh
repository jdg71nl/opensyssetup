#!/bin/bash
#= touch-thismachine.sh

HOST=$( hostname -s )
THIS="thismachine--${HOST}.touch"

#touch-2099.sh $HOME/$THIS
touch-2033.sh $HOME/$THIS

#
