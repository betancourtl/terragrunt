#!/bin/bash

ROOT=$(pwd)
ACCOUNT="main"
REGIONS=$(find ${ROOT}/deployments/${ACCOUNT}/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n')

function apply() {
    for region in ${REGIONS[*]}; do
        echo "deploying $region"
        cd "${ROOT}/deployments/${ACCOUNT}/$region/$1/infra"
        terragrunt "apply" -auto-approve -input=true --terragrunt-non-interactive
    done
}

function apply_all() {
    for region in ${REGIONS[*]}; do
        local environments=$(find ${ROOT}/deployments/${ACCOUNT}/$region -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
        for environment in ${environments[*]}; do
            echo "deploying $region $environment"
            cd "${ROOT}/deployments/${ACCOUNT}/$region/$environment/infra"
            terragrunt apply -auto-approve -input=true --terragrunt-non-interactive --terragrunt-source-update
        done
    done
}

function destroy_all() {
    for region in ${REGIONS[*]}; do
        local environments=$(find ${ROOT}/deployments/${ACCOUNT}/$region -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
        for environment in ${environments[*]}; do
            echo "deploying $region $environment"
            cd "${ROOT}/deployments/${ACCOUNT}/$region/$environment/infra"
            terragrunt destroy -auto-approve -input=true --terragrunt-non-interactive --terragrunt-source-update
        done
    done
}

function delete_state_bucket() {
    bucket=$1

    echo "Removing all versions from $bucket"

    versions=$(aws s3api list-object-versions --bucket $bucket | jq '.Versions')
    markers=$(aws s3api list-object-versions --bucket $bucket | jq '.DeleteMarkers')
    let count=$(echo $versions | jq 'length')-1

    if [ $count -gt -1 ]; then
        echo "removing files"
        for i in $(seq 0 $count); do
            key=$(echo $versions | jq .[$i].Key | sed -e 's/\"//g')
            versionId=$(echo $versions | jq .[$i].VersionId | sed -e 's/\"//g')
            cmd="aws s3api delete-object --bucket $bucket --key $key --version-id $versionId"
            echo $cmd
            $cmd
        done
    fi

    let count=$(echo $markers | jq 'length')-1

    if [ $count -gt -1 ]; then
        echo "removing delete markers"

        for i in $(seq 0 $count); do
            key=$(echo $markers | jq .[$i].Key | sed -e 's/\"//g')
            versionId=$(echo $markers | jq .[$i].VersionId | sed -e 's/\"//g')
            cmd="aws s3api delete-object --bucket $bucket --key $key --version-id $versionId"
            echo $cmd
            $cmd
        done
    fi

    aws s3 rb "s3://$bucket"
}

function destroy_all_state_buckets() {
    for region in ${REGIONS[*]}; do
        local environments=$(find ${ROOT}/deployments/${ACCOUNT}/$region -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
        for environment in ${environments[*]}; do
            local bucket="main-${region}-${environment}-tfstate"
            delete_state_bucket $bucket
        done
    done
}

"$@"
