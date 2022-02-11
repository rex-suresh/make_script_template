function update_result () {
  local TEST_STATUS=$1
  if [[ $TEST_STATUS -eq 0 ]]
  then
    RESULT[0]=$(( ${RESULT[0]} + 1 ))
  else
    RESULT[1]=$(( ${RESULT[1]} + 1 ))
  fi
}

function heading(){
  local TEXT=$1
  local BOLD='\033[1m'
  local NORMAL='\033[0m'
  echo -e "${BOLD}${TEXT}${NORMAL}"
}

function display_tests_summary () {
  local IFS=$'\n'
  local RESULT=( "$@" )
  local NOCOLOR='\033[0m'
  local RED='\033[0;31m'
  local LIGHT_RED='\033[1;31m'
  local GREEN='\033[0;32m'
  echo -en "\n\t${GREEN}PASS : ${RESULT[0]}${NOCOLOR}"
  echo -e "\t${RED}FAIL : ${RESULT[1]}${NOCOLOR}\n"

  [[ -z "${ERROR[*]}" ]] && return 0
  local INDEX=0
  local LENGTH=${#ERROR[*]}
  while [[ $INDEX -lt $LENGTH ]]; do
    echo -e "$(( $INDEX + 1 )).\n${LIGHT_RED}${ERROR[$INDEX]}${NOCOLOR}"
    echo -en "\n"
    INDEX=$(( $INDEX + 1 ))
  done
}

function assert () {
  local OLDIFS=${IFS}
  local IFS=$'\n'
  local inputs=$1
  local expected=$2
  local actual=$3
  local description=$4
  local NOCOLOR='\033[0m'
  local RED='\033[0;31m'
  local GREEN='\033[0;32m'
  local test_result="${RED}✗${NOCOLOR}"
  local return_status=1

  if [[ "${actual}" == "${expected}" ]]
  then
    test_result="${GREEN}✔${NOCOLOR}"
    return_status=0
  fi

  if [[ $return_status == 1 ]]; then
    local ERROR_DETAILS=( "Description : ${description}" "Inputs - ${inputs}" "Expected - ${expected}" "Actual - ${actual}" )
    local LENGTH=${#ERROR[*]}
    ERROR[$LENGTH]="${ERROR_DETAILS[*]}"
    description="${RED}${description}${NOCOLOR}"
  fi
  echo -e "$test_result ${description}"

  return $return_status
}