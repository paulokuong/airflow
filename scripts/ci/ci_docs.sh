#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
export PYTHON_MAJOR_MINOR_VERSION=${PYTHON_MAJOR_MINOR_VERSION:-3.6}

# shellcheck source=scripts/ci/_script_init.sh
. "$( dirname "${BASH_SOURCE[0]}" )/_script_init.sh"

function run_docs() {
    docker run "${EXTRA_DOCKER_FLAGS[@]}" -t \
            --entrypoint "/usr/local/bin/dumb-init"  \
            --env PYTHONDONTWRITEBYTECODE \
            --env VERBOSE \
            --env VERBOSE_COMMANDS \
            --env HOST_USER_ID="$(id -ur)" \
            --env HOST_GROUP_ID="$(id -gr)" \
            --env HOST_OS="$(uname -s)" \
            --env HOST_HOME="${HOME}" \
            --env HOST_AIRFLOW_SOURCES="${AIRFLOW_SOURCES}" \
            --rm \
            "${AIRFLOW_CI_IMAGE}" \
            "--" "/opt/airflow/docs/build" \
            | tee -a "${OUTPUT_LOG}"
}

get_environment_for_builds_on_ci

prepare_ci_build

rebuild_ci_image_if_needed

run_docs
