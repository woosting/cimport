#!/bin/bash
# Copyright 2016 Willem Oosting
#
# >This program is free software: you can redistribute it and/or modify
# >it under the terms of the GNU General Public License as published by
# >the Free Software Foundation, either version 3 of the License, or
# >(at your option) any later version.
# >
# >This program is distributed in the hope that it will be useful,
# >but WITHOUT ANY WARRANTY; without even the implied warranty of
# >MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# >GNU General Public License for more details.
# >
# >You should have received a copy of the GNU General Public License
# >along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# FORK ME AT GITHUB: https://github.com/woosting/cimport


# CONFIGURATION

  SOURCEPATH="/root/cimports/2cimport/*"
  TARGETPATHPREFIX="/srv/lxc/"
  TARGETPATHPOSTFIX="/rootfs/tmp/"


# LOGIC

# echo -e "State target container name:"
# read CONTAINERNAME
  read -p "State target container name: " CONTAINERNAME
  
  if [ -z "${CONTAINERNAME}" ]; then
    echo "Please provide a containername!"
    exit 1
  elif [ ! -d "${TARGETPATHPREFIX}${CONTAINERNAME}" ]; then
    echo "${CONTAINERNAME} is not a directory, does a container with that name exist?"
    exit 1
  else
    TARGETPATH="${TARGETPATHPREFIX}${CONTAINERNAME}${TARGETPATHPOSTFIX}"
    if [ ! -d "${TARGETPATH}" ]; then
      echo "${TARGETPATH} is not a (target) directory..."
      exit 1
    else
      echo -e "Importing ${SOURCEPATH} to ${TARGETPATH}"
      cp -r ${SOURCEPATH} ${TARGETPATH}
      lxc-attach -n ${CONTAINERNAME} chmod 700 /tmp/cinit/cinit.sh
    fi
  fi
