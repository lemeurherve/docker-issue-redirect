#!/usr/bin/env bats

load test_helpers.bash

@test "redirects /issue/JENKINS-10000" {
  assert_redirect \
    "/issue/JENKINS-10000" \
    "https://issues.jenkins.io/browse/JENKINS-10000"
}

@test "redirects bare /JENKINS-10000" {
  assert_redirect \
    "/JENKINS-10000" \
    "https://issues.jenkins.io/browse/JENKINS-10000"
}

@test "redirects /browse/JENKINS-10000" {
  assert_redirect \
    "/browse/JENKINS-10000" \
    "https://issues.jenkins.io/browse/JENKINS-10000"
}

@test "redirects numeric issue id" {
  assert_redirect \
    "/issue/10000" \
    "https://issues.jenkins.io/browse/JENKINS-10000"
}

@test "redirects non-JENKINS project key" {
  assert_redirect \
    "/SECURITY-123" \
    "https://issues.jenkins.io/browse/SECURITY-123"
}

@test "redirects browse non-JENKINS project key" {
  assert_redirect \
    "/browse/SECURITY-123" \
    "https://issues.jenkins.io/browse/SECURITY-123"
}

# -------------------------
# Negative tests
# -------------------------

@test "returns 404 for invalid issue key" {
  assert_ok_no_redirect "/JENKINS-ABC"
}

@test "returns 404 for malformed key" {
  assert_ok_no_redirect "/INVALID"
}

@test "returns 404 for empty browse path" {
  assert_ok_no_redirect "/browse/"
}

@test "returns 404 for random path" {
  assert_ok_no_redirect "/this/should/not/exist"
}
