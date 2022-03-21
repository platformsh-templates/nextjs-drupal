#!/usr/bin/env bash
########################################################################################################################
# NOTE:
# 
# This script runs the build commands for the Next.js frontend, installing dependencies for the main app and a 
#   verification script run in the post_deploy hook.
#
########################################################################################################################
# Build dependencies.
set -e
#   a. For the main app.
yarn --frozen-lockfile
#   b. For our verification test.
cd platformsh-scripts/test/next-drupal-debug
yarn --frozen-lockfile
