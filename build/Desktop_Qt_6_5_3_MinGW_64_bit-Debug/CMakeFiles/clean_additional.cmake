# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appRecorder_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appRecorder_autogen.dir\\ParseCache.txt"
  "appRecorder_autogen"
  )
endif()
