project(clang-me)
cmake_minimum_required(VERSION 3.12)

IF( NOT CMAKE_BUILD_TYPE )
   SET( CMAKE_BUILD_TYPE Release FORCE )
ENDIF()

include(cmake/clang-format-me.cmake)
add_subdirectory(example)
