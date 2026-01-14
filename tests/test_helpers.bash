#!/usr/bin/env bash
set -euo pipefail

setup() {
  BASE_URL="http://localhost:8060"
}

assert_redirect() {
  local path="$1"
  local expected="$2"

  run curl -s -o /dev/null -w "%{http_code} %{redirect_url}" "${BASE_URL}${path}"

  [[ "${status}" -eq 0 ]]

  http_code=$(echo "${output}" | awk '{print $1}')
  location=$(echo "${output}" | awk '{print $2}')

  # [[ "${http_code}" == "301" || "${http_code}" == "302" ]]
  [[ "${http_code}" == "301" || "${http_code}" == "308" ]]
  [[ "${location}" = "${expected}" ]]
}

assert_not_found() {
  local path="$1"

  run curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}${path}"

  [[ "${status}" -eq 0 ]]
  [[ "${output}" = "404" ]]
}

assert_ok_no_redirect() {
  local path="$1"

  run curl -s -o /dev/null -w "%{http_code} %{redirect_url}" "${BASE_URL}${path}"

  [[ "${status}" -eq 0 ]]

  http_code=$(echo "${output}" | awk '{print $1}')
  location=$(echo "${output}" | awk '{print $2}')

  [[ "${http_code}" == "200" ]]
  [[ -z "${location}" ]]
}
