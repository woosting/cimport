#!/bin/bash


# CONFIGURATION:

  EMCOL='\033[1m'     #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m' #NOT OK color (default: RED)
  OKCOL='\033[0;32m'  #OK color (default: GREEN)
  RCOL='\033[0m'      #RESET color (default: terminal default)


# EXECUTION

  echo -e " "
  echo -e ">Updating repository cache, upgrading distro, and installing wget:" && \
  echo -e " "
  apt-get update && appt-get dist-upgrade -y && apt-get install -y wget && \

  echo -e " "
  echo -e ">Downloading init script:" && \
  echo -e " "
  wget -P /tmp/cinit/ https://raw.githubusercontent.com/woosting/baseInst/master/init.sh && \
  chmod 700 /tmp/cinit/init.sh && \

  echo -e " "
  echo -e "${EMCOL}Usage: /tmp/cinit/init.sh -u <user>${RCOL}"
  echo -e " "
