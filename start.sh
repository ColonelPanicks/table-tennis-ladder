#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR 

export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/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
#export TNTFL_ROOT_URL=http://10.151.15.125/
export TNTFL_ROOT_URL=http://tabletennis.alces-flight.com/

source pyenv/bin/activate
python wsgi.py
