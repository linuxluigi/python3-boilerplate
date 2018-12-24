#!/bin/bash
cd "$( cd "$( dirname "$0" )"; pwd )"

PROJECT_NAME="acme"
export PIPENV_VERBOSITY=-1  # suppress warning if pipenv is starting inside venv

function init {
	pip3 install pipenv --upgrade
	PIPENV_VENV_IN_PROJECT=1 pipenv install --dev --skip-lock
}

function run {
	FLASK_APP=$PROJECT_NAME FLASK_DEBUG=1 pipenv run flask run
}

function shell {
    init
    pipenv shell
}

function test {
    pipenv run py.test
}

function lint {
    pipenv run flake8 $PROJECT_NAME
}

function coverage {
    pipenv run py.test -c .coveragerc --verbose tests
}

function publish {
    pipenv run python setup.py sdist bdist_wheel
	# publish somewhere...
	rm -fr build dist .egg $PROJECT_NAME.egg-info
}

# -----------------------------------------------------------------------------

coms=$( cat $0 | egrep "^function" | awk '{print $2}' | tr "\n" " " )
if [ -z "$1" ]; then
    echo "Select command: $coms"
    exit
fi
$1
