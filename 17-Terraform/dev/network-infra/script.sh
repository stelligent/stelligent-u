#!/bin/bash

WORKSPACE_NAME="${1}"
OPTION="${2}"

FILE="${WORKSPACE_NAME}.tfvars"
BACKUP_PATH="data_backup"

if [ -f "/$FILE" ]
    then   
       echo "File '${FILE}' not found."
else
    terraform ${OPTION} -out ${BACKUP_PATH}/tfplan -var-file=${FILE}
    if [ -f "${BACKUP_PATH}/tfplan" ]
        then
            echo "Plan is available for review!"
            time terraform apply ${BACKUP_PATH}/tfplan
    else
        echo "tfplan not found"
    fi
fi
