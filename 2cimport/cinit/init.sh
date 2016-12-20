#!/bin/bash

TODAY=$(date +%Y%m%d)
NEWUSER=""

while getopts u:d option
  do
    case "${option}"
     in
      u) NEWUSER=(${OPTARG});;
      d) DENV="lxde";;
      #x) EXAMPLE=(${OPTARG});;
    esac
  done

if [ ! ${NEWUSER} ]; then
      echo -e "Usage: init [-d] -u username"
      echo -e "       -u Creates the user (REQUIRED)"
      echo -e "       -d Sets desktop environment to: LXDE (OPTIONAL)"
      exit 1;
  else
  # UPDATE + UPGRADE + INSTALLS
      apt-get update && apt-get -y dist-upgrade
      apt-get install -y ssh vim screen wget git fail2ban colordiff
      #apt-get install -y linuxlogo
  # USER ADDITION
      adduser --disabled-password --gecos "${NEWUSER}" ${NEWUSER}
      usermod -aG sudo ${NEWUSER}
      mkdir /home/${NEWUSER}/.ssh/ && touch /home/${NEWUSER}/.ssh/authorized_keys
      chown ${NEWUSER}:${NEWUSER} -R /home/${NEWUSER}/.ssh && chmod 700 /home/${NEWUSER}/.ssh && chmod 600 /home/${NEWUSER}/.ssh/authorized_keys
  # CUSTOM SCRIPTS
      mkdir /home/${NEWUSER}/scripts
      git clone https://github.com/woosting/dirp.git /home/${NEWUSER}/scripts/dirp && \
        ln -s /home/${NEWUSER}/scripts/dirp/dirp.sh /usr/local/bin/dirp
      git clone https://github.com/woosting/stba.git /home/${NEWUSER}/scripts/stba && \
        ln -s /home/${NEWUSER}/scripts/stba/stba.sh /usr/local/bin/stba
      chown ${NEWUSER}:${NEWUSER} -R /home/${NEWUSER}/scripts
      chmod 755 /home/${NEWUSER}/scripts/*/*.sh
  # UX
      cp /home/${NEWUSER}/.bashrc /home/${NEWUSER}/.bashrc.bak${TODAY}
      echo "" >> /home/${NEWUSER}/.bashrc
      echo "###" >> /home/${NEWUSER}/.bashrc
      echo "# INIT.SH ADDITIONS" >> /home/${NEWUSER}/.bashrc
      echo "# Things automatically added by the init.sh script:" >> /home/${NEWUSER}/.bashrc
      echo "# Grouping directories first:" >> /home/${NEWUSER}/.bashrc
      echo "alias ls='ls --color=auto --group-directories-first'" >> /home/${NEWUSER}/.bashrc
      echo "alias weather='wget -qO- wttr.in'" >> /home/${NEWUSER}/.bashrc
      echo "alias cpuhoggers='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head && uptime'" >> /home/${NEWUSER}/.bashrc
      echo "alias memhoggers='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head'" >> /home/${NEWUSER}/.bashrc
      echo "" >> /home/${NEWUSER}/.bashrc
      echo "###" >> /home/${NEWUSER}/.bashrc
      echo "# MANUAL ADDITIONS" >> /home/${NEWUSER}/.bashrc
      echo "# Add your own:" >> /home/${NEWUSER}/.bashrc
      echo "" >> /home/${NEWUSER}/.bashrc
      echo "###" >> /home/${NEWUSER}/.bashrc
      echo "# LAST TO EXECUTE" >> /home/${NEWUSER}/.bashrc
      echo "# Things to run at the end of .bashrc loading:" >> /home/${NEWUSER}/.bashrc
      echo "# Display logo at bash login:" >> /home/${NEWUSER}/.bashrc
      echo "#if [ -f /usr/bin/linux_logo ]; then linuxlogo -u -y; fi" >> /home/${NEWUSER}/.bashrc
  # DESKTOP TWEAKING
    if [ ${DENV} ]; then
      mkdir /home/${NEWUSER}/Downloads
      mkdir /home/${NEWUSER}/Downloads/${DENV}
      mkdir /home/${NEWUSER}/Downloads/${DENV}/openbox && wget -P /home/${NEWUSER}/Downloads/${DENV}/openbox https://dl.opendesktop.org/api/files/download/id/1460769323/69196-1977-openbox.obt
      mkdir /home/${NEWUSER}/Downloads/${DENV}/icons && wget -P /home/${NEWUSER}/Downloads/${DENV}/icons https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/faenza-icon-theme/faenza-icon-theme_1.3.zip
    fi
fi
