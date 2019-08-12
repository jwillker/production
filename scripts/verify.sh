#!/bin/bash

#COLORS
B_GREEN='\e[42m'
B_RED='\e[41m'
GREEN='\e[92m'
RED="\e[91m"
RESET='\e[0m'

echo -e "\nChecking local dependencies ...\n"

if ( docker version | grep -iq "Version" ); then
    echo -e "- ${B_GREEN}OK${RESET} ${GREEN}Docker is installed! ${RESET}\n"
else
    echo -e "- ${B_RED}FAIL${RESET} ${RED}Docker not found, please install ${RESET}\n"
fi

if ( docker-compose version | grep -iq "version" ); then
    echo -e "- ${B_GREEN}OK${RESET} ${GREEN}Docker compose is installed! ${RESET}\n"
else
    echo -e "- ${B_RED}FAIL${RESET} ${RED}docker-compose not found, please install ${RESET}\n"
fi

if ( aws --version | grep -iq "aws-cli" ); then
    echo -e "- ${B_GREEN}OK${RESET} ${GREEN}AWS cli is installed! ${RESET}\n"
else
    echo -e "- ${B_RED}FAIL${RESET} ${RED}AWS cli not found, please install ${RESET}\n"
fi

if ( packer version | grep -iq "Packer" ); then
     echo -e "- ${B_GREEN}OK${RESET} ${GREEN}Packer is installed! ${RESET}\n"
else
     echo -e "- ${B_RED}FAIL${RESET} ${RED}Packer not found, please install ${RESET}\n"
fi

if ( terraform --version | grep -iq "Terraform" ); then
     echo -e "- ${B_GREEN}OK${RESET} ${GREEN}Terraform is installed! ${RESET}\n"
else
     echo -e "- ${B_RED}FAIL${RESET} ${RED}Terraform not found, please install ${RESET}\n"
fi

if ( helm version --client | grep -iq "Client" ); then
     echo -e "- ${B_GREEN}OK${RESET} ${GREEN}Helm is installed! ${RESET}\n"
else
     echo -e "- ${B_RED}FAIL${RESET} ${RED}Helm not found, please install ${RESET}\n"
fi

if ( kubectl version --client | grep -iq "Client" ); then
     echo -e "- ${B_GREEN}OK${RESET} ${GREEN}Kubectl is installed! ${RESET}\n"
else
     echo -e "- ${B_RED}FAIL${RESET} ${RED}Kubectl not found, please install ${RESET}\n"
fi

if ( jq --help | grep -iq "JSON" ); then
    echo -e "- ${B_GREEN}OK${RESET} ${GREEN}jq is installed! ${RESET}\n"
else
    echo -e "- ${B_RED}FAIL${RESET} ${RED}jq not found, please install ${RESET}\n"
fi

echo -e "\n See README.md for more information."
