set(PRECOMPILE_TOOLS_PATH "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(PICCOLO_PRECOMPILE_PARAMS_IN_PATH "${CMAKE_CURRENT_SOURCE_DIR}/source/precompile/precompile.json.in")
set(PICCOLO_PRECOMPILE_PARAMS_PATH "${PRECOMPILE_TOOLS_PATH}/precompile.json")
configure_file(${PICCOLO_PRECOMPILE_PARAMS_IN_PATH} ${PICCOLO_PRECOMPILE_PARAMS_PATH})

if (CMAKE_HOST_WIN32)
    set(PRECOMPILE_PRE_EXE)
    set(PRECOMPILE_PARSER ${PRECOMPILE_TOOLS_PATH}/PiccoloParser.exe)
    set(sys_include "*") 
elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux" )
    set(PRECOMPILE_PRE_EXE)
    set(PRECOMPILE_PARSER ${PRECOMPILE_TOOLS_PATH}/PiccoloParser)
    set(sys_include "/usr/include/c++/9/") 
elseif(CMAKE_HOST_APPLE)
    find_program(XCRUN_EXECUTABLE xcrun)
    if(NOT XCRUN_EXECUTABLE)
      message(FATAL_ERROR "xcrun not found!!!")
    endif()

    execute_process(
      COMMAND ${XCRUN_EXECUTABLE} --sdk macosx --show-sdk-path
      OUTPUT_VARIABLE osx_sdk_path
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(PRECOMPILE_PRE_EXE)
    set(PRECOMPILE_PARSER ${PRECOMPILE_TOOLS_PATH}/PiccoloParser)
    set(STL_INCLUDE_DIR "${osx_sdk_path}/usr/include/c++/v1")
    set(SYS_INCLUDE_DIR "${osx_sdk_path}/usr/include")
endif()

set(PARSER_INPUT ${CMAKE_BINARY_DIR}/parser_header.h)
set(PRECOMPILE_TARGET "PiccoloPreCompile")

set(CLANG_INCLUDE_PATH "${ENGINE_ROOT_DIR}/source:${STL_INCLUDE_DIR}")

add_custom_target(${PRECOMPILE_TARGET} ALL
  COMMAND
    ${CMAKE_COMMAND} -E echo "************************************************************* "
  COMMAND
    ${CMAKE_COMMAND} -E echo "**** [Precompile] BEGIN "
  COMMAND
    ${CMAKE_COMMAND} -E echo "************************************************************* "
  COMMAND
    ${PRECOMPILE_PARSER}
      "${PICCOLO_PRECOMPILE_PARAMS_PATH}"
      "${PARSER_INPUT}"
      "${CLANG_INCLUDE_PATH}"
      "${SYS_INCLUDE_DIR}"
      "Piccolo"
      0
  COMMAND
    ${CMAKE_COMMAND} -E echo "+++ Precompile finished +++"
)
