#!/usr/bin/env bash

# Application name, please set
APPLICATION_NAME='notes' # Use hyphens - only as symbols, no _ underscores (NIRD convention)
GIT_REPO_NAME='notes' # Git repo name, matches the dir name

# Colors for cosmetics
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'



echo -e "=================${YELLOW} Deployment Steps =================="
echo -e " 1.) ${YELLOW}Download CLI"
echo -e " 2.) ${YELLOW}Login to CF"
echo -e " 3.) ${YELLOW}CD into app and remove vendor/bundle dir"
echo -e " 4.) ${YELLOW}Rename old application and push new one"
echo -e " 5.) ${YELLOW}Start new application"
echo -e " 6.) ${YELLOW}Remove old application"
echo -e " 7.) ${YELLOW}Deploy finished"

function rollback {
  echo -e " x.) ${RED}ROLLBACK"
    cf delete ${APPLICATION_NAME} -f
    cf rename ${APPLICATION_NAME}-old ${APPLICATION_NAME}
}

./grailsw war

cf rename ${APPLICATION_NAME} ${APPLICATION_NAME}-old
if ! cf push ${APPLICATION_NAME} --no-start ; then
    echo -e "${RED}[-] Application could not be pushed, rolling back..."
    rollback
    exit -1;
fi

######################
# APP ENV SETUP
######################
echo -e "${GREEN}[+] Setting application environment"
{
#cf set-env ${APPLICATION_NAME} NEW_RELIC_KEY "$NEW_RELIC_KEY"
cf set-env ${APPLICATION_NAME} NOTES_EMAIL_HOST "mail.cabolabs.com" #"smtp.sendgrid.net"
cf set-env ${APPLICATION_NAME} NOTES_EMAIL_PORT 587 #25
cf set-env ${APPLICATION_NAME} NOTES_EMAIL_USER "notes@cabolabs.com" #"apikey"
cf set-env ${APPLICATION_NAME} NOTES_EMAIL_PASS "A#HcpkQ@Iavv" #"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"
cf set-env ${APPLICATION_NAME} NOTES_EMAIL_FROM "notes@cabolabs.com" #"engineerbell@gmail.com"

cf set-env ${APPLICATION_NAME} PROD_DB_USER "appuser"
cf set-env ${APPLICATION_NAME} PROD_DB_PASS "mzVso0cSwjSZNdGT"
cf set-env ${APPLICATION_NAME} PROD_DB_IP "10.4.72.5"
cf set-env ${APPLICATION_NAME} PROD_DB_PORT "30097"
cf set-env ${APPLICATION_NAME} PROD_DB_NAME "notes"
} > /dev/null


######################
# APP START
######################
echo -e "${GREEN}[+] Starting application"
if ! cf start ${APPLICATION_NAME}; then
    echo -e "${RED}[-] Application could not be started, rolling back..."
    rollback
    exit -1;
fi

######################
# CLEANUP
######################
cf delete ${APPLICATION_NAME}-old -f

echo -e "${GREEN}[+] Deploy Complete"

exit 0
