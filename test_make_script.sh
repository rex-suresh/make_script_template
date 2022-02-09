source make_script.sh
source testing_utilities.sh

function test_create_files() {
  local test_dir="potato"
  local message="Should create empty project, run, test, run_test 'sh' files in specified directory"
  local inputs="${test_dir}"
  
  mkdir -p ${test_dir}
  create_files "${test_dir}" "${test_dir}_library.sh" "run.sh" "test_${test_dir}.sh" "run_test.sh" # Initializing function

  local result[0]="$( [[ ! -f ${test_dir}/run.sh ]] && echo "run.sh file doesn't exist" )"
  local result[1]="$( [[ ! -f ${test_dir}/run_test.sh ]] && echo "run_test.sh file doesn't exist" )"
  local result[2]="$( [[ ! -f ${test_dir}/${test_dir}_library.sh ]] && echo "${test_dir}.sh file doesn't exist" )"
  local result[3]="$( [[ ! -f ${test_dir}/test_${test_dir}.sh ]] && echo "test_${test_dir}.sh file doesn't exist" )"
  
  local expected_array[0]="" expected_array[1]="" expected_array[2]="" expected_array[3]=""
  local expected_output="${expected_array[@]}"
  local actual_output="${result[@]}"

  assert "${inputs}" "${expected_output}" "${actual_output}" "${message}"
  local test_result=$?
  update_result "${test_result}"

  rm -r ${test_dir} &> /dev/null
}

function test_case_push_script_content_run() {
  local test_dir="potato"
  local message="Should insert run file content into the run.sh file"
  local library_file="${test_dir}_library.sh"
  local run_file="run.sh"
  local inputs="${test_dir}, ${run_file}, ${library_file}"

  mkdir -p "${test_dir}"
  push_script_content "${test_dir}" "${library_file}" "${run_file}"  # Initializing function 

  local expected_output="`echo -e "#! /bin/bash\nsource ${library_file}\n\nmain"`"
  local actual_output="$( cat ${test_dir}/run.sh )"
  
  assert "${inputs}" "${expected_output}" "${actual_output}" "${message}"
  local test_result=$?
  update_result "${test_result}"

  rm -r ${test_dir} &> /dev/null
}
function test_case_push_script_content_library() {
  local test_dir="potato"
  local message="Should insert library file content into the library.sh file"
  local library_file="${test_dir}_library.sh"
  local run_file="run.sh"
  local inputs="${test_dir}, ${run_file}, ${library_file}"

  mkdir -p "${test_dir}"
  push_script_content "${test_dir}" "${library_file}" "${run_file}"  # Initializing function 

  local expected_output="`echo -e "function main() {\n  echo \\"Hello World\\"\n}"`"
  local actual_output="$( cat ${test_dir}/${library_file} )"
  
  assert "${inputs}" "${expected_output}" "${actual_output}" "${message}"
  local test_result=$?
  update_result "${test_result}"

  rm -r ${test_dir} &> /dev/null
}
function test_push_script_content() {
  test_case_push_script_content_run
  test_case_push_script_content_library
}

function test_case_push_test_content_run_test() {
  local test_dir="potato"
  local message="Should insert run test file content into the run_test.sh file"

  local library_file="${test_dir}_library.sh"
  local test_file="test_${test_dir}.sh"
  local run_test_file="run_test.sh"
  local inputs="${test_dir}, ${run_test_file}, ${test_dir}, ${library_file}"

  mkdir -p "${test_dir}"
  push_test_content "${test_dir}" "${test_file}" "${run_test_file}" "${library_file}" # Initializing function 

  local expected_output="`echo -e "#! /bin/bash\nsource ${test_file}\n\nall_tests\ndisplay_tests_summary \\\"\\${RESULTS[@]}\\\""`"
  local actual_output="$( cat ${test_dir}/run_test.sh )"
  
  assert "${inputs}" "${expected_output}" "${actual_output}" "${message}"
  local test_result=$?
  update_result "${test_result}"

  rm -r ${test_dir} &> /dev/null
}
function test_case_push_test_content_test() {
  local test_dir="potato"
  local message="Should insert test file content into the test.sh file"

  local library_file="${test_dir}_library.sh"
  local test_file="test_${test_dir}.sh"
  local run_test_file="run.sh"
  local inputs="${test_dir}, ${run_test_file}, ${library_file}"

  mkdir -p "${test_dir}"
  push_test_content "${test_dir}" "${test_file}" "${run_test_file}" "${library_file}"  # Initializing function 

  local expected_output="`echo -e "source ${library_file}\n\nfunction all_tests() {\n  echo \\"This is a testing file\\"\n}"`"
  local actual_output="$( cat ${test_dir}/${test_file} )"
  
  assert "${inputs}" "${expected_output}" "${actual_output}" "${message}"
  local test_result=$?
  update_result "${test_result}"

  rm -r ${test_dir} &> /dev/null
}
function test_push_test_content() {
  test_case_push_test_content_run_test
  test_case_push_test_content_test
}


function all_tests() {
  heading "Create file"
  test_create_files 
  
  heading "Push script content"
  test_push_script_content 

  heading "Push test content"
  test_push_test_content 
}
