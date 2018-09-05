#!/bin/bash
#
# This file is part of SCOAP3.
# Copyright (C) 2014-2018 CERN.
#
# SCOAP3 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SCOAP3 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SCOAP3. If not, see <http://www.gnu.org/licenses/>.
#
# In applying this license, CERN does not waive the privileges and immunities
# granted to it by virtue of its status as an Intergovernmental Organization
# or submit itself to any jurisdiction.

set -e

if [ ! -d "${VIRTUAL_ENV}" ]; then
  >&2 echo "You must be in a virtual environment to use this script."
  exit 1
fi

if [ ! -x "$(command -v SCOAP3)" ]; then
  >&2 echo "You must have the SCOAP3 command to use this script."
  exit 1
fi

scoap3 db drop --yes-i-know
scoap3 db create
scoap3 index destroy --force --yes-i-know
scoap3 index init
scoap3 fixtures init

if [[ "$1" != "--no-populate" ]]; then
  scoap3 migrate file --force --wait scoap3/data/scoap3export.xml
fi
