#!/bin/bash


# CONFIGURATION:

  EMCOL='\033[1m'     #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m' #NOT OK color (default: RED)
  OKCOL='\033[0;32m'  #OK color (default: GREEN)
  RCOL='\033[0m'      #RESET color (default: terminal default)


# EXECUTION
    echo -e " "
    echo -e ">Installing wget:" && \
    echo -e " "
    apt-get apt-get install -y wget && \

    echo -e " "
    echo -e ">Downloading general init script:" && \
    echo -e " "
    wget -P /tmp/cinit/ https://raw.githubusercontent.com/woosting/baseInst/master/init.sh && \
    chmod 700 /tmp/cinit/init.sh && \

    read -p "State the username: " TARGETUSERNAME
    if [ -z "${TARGETUSERNAME}" ]; then
      echo -e "${NOKCOL}No username received!${RCOL} Not executing genereal init script (you can still run it from within the container)!"
      exit 1
    elif [ "${TARGETUSERNAME}" = "root" ]; then
      echo -e "${NOKCOL}${TARGETUSERNAME} is not allowed!${RCOL} Not executing genereal init script (you can still run it from within the container)!"
      exit 1
    else
      echo -e " "
      echo -e ">Executing general init script creating ${TARGETUSERNAME} as a user:" && \
      echo -e " "
      /tmp/cinit/init.sh -u ${TARGETUSERNAME}
    fi
