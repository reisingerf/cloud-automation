#!/bin/bash
#
# Runs daily COVID-19 ETLs
# Run as cron job in covid19@adminvm user account
#
# USER=<USER>
# S3_BUCKET=<S3_BUCKET>
# KUBECONFIG=path/to/kubeconfig
# 0   0   *   *   *    (if [ -f $HOME/cloud-automation/files/scripts/covid19-etl-job.sh ]; then JOB_NAME=<JOB_NAME> bash $HOME/cloud-automation/files/scripts/covid19-etl-job.sh; else echo "no codiv19-etl-job.sh"; fi) > $HOME/covid19-etl-$JOB_NAME-job.log 2>&1

# setup --------------------

export GEN3_HOME="${GEN3_HOME:-"$HOME/cloud-automation"}"

if ! [[ -d "$GEN3_HOME" ]]; then
  echo "ERROR: this does not look like a gen3 environment - check $GEN3_HOME and $KUBECONFIG"
  exit 1
fi

PATH="${PATH}:/usr/local/bin"

source "${GEN3_HOME}/gen3/gen3setup.sh"

# lib -------------------------

help() {
  cat - <<EOM
Use: bash ./augur-cronjob.sh
EOM
}


# main -----------------------

if [[ -z "$USER" ]]; then
  gen3_log_err "\$USER variable required"
  help
  exit 1
fi

# populate the job variable and change it's name to reflect the ETL being run
gen3 job run augur-cronjob ACCESS_TOKEN "$(gen3 api access-token $USER)"
