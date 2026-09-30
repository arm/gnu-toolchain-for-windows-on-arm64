#!/bin/bash
source `dirname ${BASH_SOURCE[0]}`/../config.sh

echo "$TESTS_BUILD=passed" >> $GITHUB_OUTPUT
