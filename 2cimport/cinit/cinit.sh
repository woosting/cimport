#!/bin/bash


# CONFIGURATION:

  EMCOL='\033[1m'     #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m' #NOT OK color (default: RED)
  OKCOL='\033[0;32m'  #OK color (default: GREEN)
  RCOL='\033[0m'      #RESET color (default: terminal default)


# FUNCTION DEFINITION:

  function printHelp () {
    echo -e "USAGE: cinit [-u username] | [-h]"
    echo -e "         -u Specifies the target container's username (will be created)."
    echo -e "         -h Prints this help."
    echo -e "If no options are provided an interactive shell will commence."
  }

  function getInput () {
    local OPTIND  u h option
    while getopts u:h option
    do
      case "${option}"
       in
        u) TARGETUSERFLAG=(${OPTARG});;
        h) printHelp
           exit 0
        ;;
	\?) printHelp
            exit 1
        ;;
      esac
    done
  }


# LOGIC

  getInput "$@"

  echo -e " "
  echo -e ">Installing wget:" && \
  echo -e " "
  apt-get install -y wget && \

  echo -e " "
  echo -e ">Downloading general init script:" && \
  echo -e " "
  wget -P /tmp/cinit/ https://raw.githubusercontent.com/woosting/baseInst/master/init.sh && \
  chmod 700 /tmp/cinit/init.sh && \
  if [ -z "${TARGETUSERFLAG}" ]; then
    read -p "State the username: " TARGETUSER
  else
    TARGETUSER=${TARGETUSERFLAG}
  fi
  if [ -z "${TARGETUSER}" ]; then
    echo -e "${NOKCOL}No username received!${RCOL} Not executing genereal init script (you can still run it from within the container)!"
    exit 1
  elif [ "${TARGETUSER}" = "root" ]; then
    echo -e "${NOKCOL}${TARGETUSER} is not allowed!${RCOL} Not executing genereal init script (you can still run it from within the container)!"
    exit 1
  else
    echo -e " "
    echo -e ">Executing general init script creating ${TARGETUSER} as a user:" && \
    echo -e " "
    /tmp/cinit/init.sh -u ${TARGETUSER}
  fi
