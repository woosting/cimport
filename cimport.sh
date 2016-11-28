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


# CONFIGURATION:

  CONTAINERNAME=''


# INITIALISATION:

  CONTAINERNAME=''


# LOGIC

  clear
  echo -e "Please stat the container name to import to:"
  read CONTAINERNAME
  echo -e "Importing to /srv/${CONTAINERNAME}

# cp * /srv/${CONTAINERNAME}"
