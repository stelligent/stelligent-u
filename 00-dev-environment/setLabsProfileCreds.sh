#!/usr/bin/env bash

# ===========================================================================================================
# Description:
#     This script swaps the aws profile ENV variables to a new one
# Arguments:
#     The valid profile name in the aws config file to swap to
#
# NOTE: You MUST source this script in order to change the env variables in the current shell
#       example from command prompt -->  $ . swapAwsProfile.sh <newProfile>
#
#       If not done, the script is run in its own, new shell and so the export will only occur
#       there and not in the current shell.
# ===========================================================================================================

# setting some color varibles for use
#  --------------------------------------
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
DARK_BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
SKY_BLUE=$(tput setaf 6)
WHITE=$(tput setaf 7)
GREY=$(tput setaf 8)
BRICK_RED=$(tput setaf 9)
BRIGHT_GREEN=$(tput setaf 10)
BRIGHT_YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 12)
PURPLE=$(tput setaf 13)
CYAN=$(tput setaf 14)
BRIGHT_WHITE=$(tput setaf 15)
DIRTY_WHITE=$(tput setaf 250)

doubleDiv=================================================================================================
singleLongDiv=------------------------------------------------------------------------------------------------
singleDiv=----------------------------

if [ -z "$1" ] ; then
    printf "\n\n%s\n\n" " ${RED}ERROR   ${BRIGHT_WHITE}No AWS Profile supplied${DIRTY_WHITE}"
    printf "%s\n" " ${BRIGHT_WHITE}Available profiles are:"
    printf "%s\n" "${BRIGHT_WHITE}${singleDiv}${BRIGHT_YELLOW}"
    aws configure list-profiles
    printf "\n\n${DIRTY_WHITE}"
    exit 1
else
    initialProfile=st_jh_labs
    newProfile=tmp_mfa_creds
    mfaToken=$1
    modFile="/Users/John.Hunter/.aws/credentials"
    tmpMfaCredential=""
    mfaCredential=""

    export AWS_PROFILE=$initialProfile AWS_DEFAULT_PROFILE=$initialProfile
    # aws sts get-caller-identity

    # echo
    # echo "mfaToken=$mfaToken"

    tmpMfaCredential=$(aws sts get-session-token --serial-number arn:aws:iam::324320755747:mfa/john.hunter.labs --token-code $mfaToken --query "[Credentials.[AccessKeyId, SecretAccessKey, SessionToken]]" --output text)

    mfaCredential=$(echo $tmpMfaCredential | tr -d [:space:])
    accessKeyId=$(echo $tmpMfaCredential | cut -d' ' -f1)
    secretAccessKey=$(echo $tmpMfaCredential | cut -d' ' -f2)
    sessionToken=$(echo $tmpMfaCredential | cut -d' ' -f3)

    # echo "AccessKeyId=$accessKeyId"
    # echo "SecretAccessKey=$secretAccessKey"
    # echo "SessionToken=$sessionToken"
    
    newAccessKeyIdLine="aws_access_key_id = $accessKeyId"
    newSecretAccessKeyLine="aws_secret_access_key = $secretAccessKey"
    newSessionTokenLine="aws_session_token = $sessionToken"
    escapedAccessKeyIdLine=$(echo $newAccessKeyIdLine | sed -e 's/[]$/.*[\^]/\\&/g')
    escapedSecretAccessKeyLine=$(echo $newSecretAccessKeyLine | sed -e 's/[]$/.*[\^]/\\&/g')
    escapedSessionTokenLine=$(echo $newSessionTokenLine | sed -e 's/[]$/.*[\^]/\\&/g')

    sed -i '' -e "s/aws_access_key_id = .*/${escapedAccessKeyIdLine}/" $modFile
    sed -i '' -e "s/aws_secret_access_key = .*/${escapedSecretAccessKeyLine}/" $modFile
    sed -i '' -e "s/aws_session_token = .*/${escapedSessionTokenLine}/" $modFile

    printf "\n%s\n" "${BRIGHT_YELLOW}Previous ENV values"
    printf "%s\n"   "${BRIGHT_WHITE}AWS_PROFILE =         ${DIRTY_WHITE}$AWS_PROFILE${DIRTY_WHITE}"
    printf "%s\n\n" "${BRIGHT_WHITE}AWS_DEFAULT_PROFILE = ${DIRTY_WHITE}$AWS_DEFAULT_PROFILE${DIRTY_WHITE}"

    export AWS_PROFILE=$newProfile AWS_DEFAULT_PROFILE=$newProfile

    printf "%s\n"   "${BRIGHT_YELLOW}New ENV values"
    printf "%s\n"   "${BRIGHT_WHITE}AWS_PROFILE =         ${CYAN}$AWS_PROFILE${DIRTY_WHITE}"
    printf "%s\n\n" "${BRIGHT_WHITE}AWS_DEFAULT_PROFILE = ${CYAN}$AWS_DEFAULT_PROFILE${DIRTY_WHITE}"
    echo

    aws iam get-user
    echo
fi

