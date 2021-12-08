#!/bin/bash

# Apache Virtual Host Creation Tool
#
# Version 1.0
# Copyright (c) 2021 Tom Higuchi (https://tom-gs.com/)
# Released under the MIT license
# https://opensource.org/licenses/mit-license.php

set -eu

date_init_given_date() {
    format=${1}
    given_date=${2}
    if [ "${given_date}" = "" ];
    then
        date "${format}"
    else
        date "${format}" -d "${given_date}"
    fi
}

date_start_of_year() {
    format=${1}
    given_date=$(date_init_given_date "+%Y-01-01" "${2}")
    date -d "${given_date}" "${format}"
}

date_end_of_year() {
    format=${1}
    given_date=$(date_start_of_year "+%Y-%m-%d" "${2}")
    date -d "${given_date} +1year -1day" "${format}"
}

date_start_of_month() {
    format=${1}
    given_date=$(date_init_given_date "+%Y-%m-01" "${2}")
    date -d "${given_date}" "${format}"
}

date_end_of_month() {
    format=${1}
    given_date=$(date_start_of_month "+%Y-%m-%d" "${2}")
    date -d "${given_date} +1month -1day" "${format}"
}

date_start_of_week() {
    format=${1}
    given_date=$(date_init_given_date "+%Y-%m-%d" "${2}")
    dow=$(date "+%w" -d "${given_date}")
    date -d "${given_date} -${dow}day" "${format}"
}

date_end_of_week() {
    format=${1}
    given_date=$(date_init_given_date "+%Y-%m-%d" "${2}")
    dow=$(date "+%w" -d "${given_date}")
    diff=$(expr 6 - ${dow})
    date -d "${given_date} +${diff}day" "${format}"
}

# vim: expandtab tabstop=4 softtabstop=4 shiftwidth=4 smarttab :
