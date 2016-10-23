#!/bin/bash

printf "\n[-] Setting up user...\n\n"

groupadd -r nodejs
useradd -m -r -g nodejs nodejs
