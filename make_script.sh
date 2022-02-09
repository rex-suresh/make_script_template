function push_script_content() {
  local project_dir="$1"
  local library_file="$2"
  local run_file="$3"

  cat <<EOF > ${project_dir}/${run_file}
#! /bin/bash
source ${library_file}

main
EOF

  cat <<EOF > ${project_dir}/${library_file}
function main() {
  echo "Hello World"
}
EOF

}

function push_test_content() {
  local project_dir="$1"
  local test_file="$2"
  local run_test_file="$3"
  local library_file="$4"


  cat <<EOF > ${project_dir}/${run_test_file}
#! /bin/bash
source ${test_file}

all_tests
display_tests_summary "\${RESULTS[@]}"
EOF

  cat <<EOF > ${project_dir}/${test_file}
source ${library_file}

function all_tests() {
  echo "This is a testing file"
}
EOF

}

function create_files() {
  local project_name="$1"
  local library_file="$2"
  local run_file="$3"
  local test_file="$4"
  local run_test_file="$5"

  touch ${project_name}/{${library_file},${run_file},${test_file},${run_test_file}}
}

function intialize_version_control() {
  local project_name="$1"

  read -p "Press Y if you want to add git repository into your project : " option
  if [[ ${option} == "Y" ]]
  then
    cd ${project_name}
    git init &> /dev/null
  fi
}

function change_mode() {
  local project_dir="$1"
  local run_file="$2"
  local run_test_file="$3"

  chmod +x ${project_dir}/{${run_file},${run_test_file}}
}

function import_testing_utilities() {
  local project_dir="$1"
  local utilities_dir="$2"

  cp ${utilities_dir}/* ${project_dir}
}

function main() {
  local project_name="$1"
  
  local utilities_dir=~/Workspace/terminal/TESTING_UTILITIES
  local library_file="${project_name}_library.sh"
  local run_file="run.sh"
  local test_file="test_${project_name}.sh"
  local run_test_file="run_test.sh"

  if [[ -z ${project_name} ]]
  then
      echo "error: project name required"
  return 1
  fi

  mkdir -p "${project_name}"
  create_files "${project_name}" "${library_file}" "${run_file}" "${test_file}" "${run_test_file}" # Doesn't really need this command.
  push_script_content "${project_name}" "${library_file}" "${run_file}"
  push_test_content "${project_name}" "${test_file}" "${run_test_file}" "${library_file}"
  import_testing_utilities "${project_name}" "${utilities_dir}"

  change_mode "${project_name}" "${run_file}" "${run_test_file}"
  intialize_version_control "${project_name}"
}