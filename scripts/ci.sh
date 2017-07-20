#!/bin/sh

#
# Optional Environment Variables for Configuration
#
# - TIMEOUT_SCALE_FACTOR: (default: 15)
#   A multiplation factor that can be used to raise the wait-time on
#   various longer-running tests.  Useful for slower (or faster!) hardware.
# - ADDL_SELF_TEST_EXCLUDE: (optional)
#   A regex or list of additional regexes to skip.

# Export this one so it's available in the node environment.
export TIMEOUT_SCALE_FACTOR=${TIMEOUT_SCALE_FACTOR:-4}

# Skip these tests always.  Add other tests with ADDL_SELF_TEST_EXCLUDE.
SELF_TEST_EXCLUDE="^old cli tests|^minifiers can't register non-js|^minifiers: apps can't use|^compiler plugins - addAssets"

# If no SELF_TEST_EXCLUDE is defined, use those defined here by default
if ! [ -z "$ADDL_SELF_TEST_EXCLUDE" ]; then
  SELF_TEST_EXCLUDE="${SELF_TEST_EXCLUDE}|${ADDL_SELF_TEST_EXCLUDE}"
fi

# Don't print as many progress indicators
export EMACS=t

export METEOR_HEADLESS=true

# Clear dev_bundle/.npm to ensure consistent test runs.
./meteor npm cache clear

# Since PhantomJS has been removed from dev_bundle/lib/node_modules
# (#6905), but self-test still needs it, install it now.
./meteor npm install -g phantomjs-prebuilt browserstack-webdriver

# Make sure we have initialized and updated submodules such as
# packages/non-core/blaze.
git submodule update --init --recursive

# Also, if any uncaught errors slip through, fail the build.
set -e

echo "Running warehouse self-tests"
./meteor self-test --headless \
    --with-tag "custom-warehouse" \
    --exclude "$SELF_TEST_EXCLUDE" \