#! /bin/bash
source test_make_script.sh

all_tests
display_tests_summary "${RESULT[@]}"