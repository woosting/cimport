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

  function getInput () {
    local OPTIND c u h option
    while getopts c:u:h option
    do
      case "${option}"
       in
        c) TARGETCONTAINERFLAG=(${OPTARG});;
        u) TARGETUSERFLAG=(${OPTARG});;
        h) PRINTHELP=$((PRINTHELP+1));;
        \?)
          echo "Invalid option: -$OPTARG" >&2
          ;;
      esac
      if [ ${PRINTHELP} -gt 0 ]; then
        echo -e "USAGE: cimport [-c containername] [-u username] [-h]"
        echo -e "         -c Specifies the target container's name (must exist)"
        echo -e "         -u Specifies the target container's username (will be created)"
        echo -e "         -h Prints this help"
      fi
    done
          
    
# LOGIC

  if [ -z "${TARGETCONTAINERFLAG}" ]; then
    read -p "State target container name: " TARGETCONTAINER
  else
    TARGETCONTAINER=${TARGETCONTAINERFLAG}
  fi
  if [ -z "${TARGETCONTAINER}" ]; then
    echo "Please provide a containername!"
    exit 1
  elif [ ! -d "${TARGETPATHPREFIX}${TARGETCONTAINER}" ]; then
    echo "${TARGETCONTAINER} is not a directory, does a container with that name exist?"
    exit 1
  else
    TARGETPATH="${TARGETPATHPREFIX}${TARGETCONTAINER}${TARGETPATHPOSTFIX}"
    if [ ! -d "${TARGETPATH}" ]; then
      echo "${TARGETPATH} is not a (target) directory..."
      exit 1
    else
      echo -e " "
      echo -e "Importing ${SOURCEPATH} to ${TARGETPATH}"
      cp -r ${SOURCEPATH} ${TARGETPATH}
      echo -e "STARTING execution of scripts in ${TARGETCONTAINER}:"
      echo -e " "
      lxc-attach -n ${TARGETCONTAINER} -- chmod 700 /tmp/cinit/cinit.sh && \
      if [ -z "${TARGETUSERFLAG}" ]; then
        lxc-attach -n ${TARGETCONTAINER} -- /tmp/cinit/cinit.sh -u ${TARGETUSERFLAG} && \
      else
        lxc-attach -n ${TARGETCONTAINER} -- /tmp/cinit/cinit.sh && \
      fi
      echo -e " " && \
      echo -e "FINISHED executing of scripts in ${TARGETCONTAINER}"
    fi
  fi
