# MIT License

# Copyright (c) 2018-2019 Wiktor Drewniak

project(clang-me)
cmake_minimum_required(VERSION 3.12)

IF( NOT CMAKE_BUILD_TYPE )
   SET( CMAKE_BUILD_TYPE Release FORCE )
ENDIF()

include(cmake/clang-format-me.cmake)

function(add_executable_clang_me target_name)
   add_executable(${target_name} ${ARGN})
   clang_format_me(TARGET_NAME ${TARGET_NAME})
endfunction(add_executable_clang_me target_name)

function(add_library_clang_me target_name)
   add_library(${target_name} ${ARGN})
   clang_format_me(TARGET_NAME ${TARGET_NAME})
endfunction(add_library_clang_me target_name)

add_subdirectory(example)
