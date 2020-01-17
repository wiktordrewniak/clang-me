# MIT License

# Copyright (c) 2018-2019 Wiktor Drewniak

find_program(CLANG_FORMAT_EXE
    NAMES clang-format
        clang-format-10
        clang-format-9
        clang-format-8
        clang-format-7
        clang-format-6.0
        clang-format-5.0
        clang-format-4.0
        clang-format-3.9
        clang-format-3.8
        clang-format-3.7
        clang-format-3.6
        clang-format-3.5
        clang-format-3.4
        clang-format-3.3
    DOC "clang-format executable")

if(DEFINED CLANG_FORMAT_EXE)
    MESSAGE("Detected clang-format: ${CLANG_FORMAT_EXE}")
else()
    MESSAGE(FATAL_ERROR "Can't find clang-format")
endif()

set(CLANG_FORMAT_ME_DEFAULT_HEADER_EXTENSIONS h hpp)
set(CLANG_FORMAT_ME_DEFAULT_SOURCE_EXTENSIONS c cpp cc)
set(CLANG_FORMAT_ME_DEFAULT_STYLE "Google")

add_custom_target(clang-format-all)

function(clang_format_me)
    set(options)
    set(oneValueArgs TARGET_NAME EXCLUDE_PATTERN)
    set(multiValueArgs HEADER_EXTENSIONS SOURCE_EXTENSIONS)
    cmake_parse_arguments(CLANG_FORMAT_ME "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN} )

    if(NOT DEFINED CLANG_FORMAT_ME_TARGET_NAME)
        MESSAGE(FATAL_ERROR "Missing TARGET_NAME")
    endif()

    if(NOT DEFINED CLANG_FORMAT_ME_HEADER_EXTENSIONS)
        set(CLANG_FORMAT_ME_HEADER_EXTENSIONS ${CLANG_FORMAT_ME_DEFAULT_HEADER_EXTENSIONS})
    endif()

    if(NOT DEFINED CLANG_FORMAT_ME_SOURCE_EXTENSIONS)
        set(CLANG_FORMAT_ME_SOURCE_EXTENSIONS ${CLANG_FORMAT_ME_DEFAULT_SOURCE_EXTENSIONS})
    endif()

    if(NOT DEFINED CLANG_FORMAT_ME_EXCLUDE_PATTERN AND DEFINED CLANG_FORMAT_ME_DEFAULT_EXCLUDE_PATTERN)
        set(CLANG_FORMAT_ME_EXCLUDE_PATTERN ${CLANG_FORMAT_ME_DEFAULT_EXCLUDE_PATTERN})
    endif()

    set(CLANG_FORMAT_STYLE_FILE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    while(TRUE)
        if(EXISTS "${CLANG_FORMAT_STYLE_FILE_PATH}/.clang-format")
            set(CLANG_FORMAT_STYLE_FILE_PATH "${CLANG_FORMAT_STYLE_FILE_PATH}/.clang-format")
            break()
        elseif(EXISTS "${CLANG_FORMAT_STYLE_FILE_PATH}/_clang-format")
            set(CLANG_FORMAT_STYLE_FILE_PATH "${CLANG_FORMAT_STYLE_FILE_PATH}/_clang-format")
            break()
        elseif(${CLANG_FORMAT_STYLE_FILE_PATH} STREQUAL ${CMAKE_HOME_DIRECTORY})
            set(CLANG_FORMAT_STYLE_FILE_PATH "${CLANG_FORMAT_STYLE_FILE_PATH}/.clang-format")
            add_custom_command(OUTPUT ${CLANG_FORMAT_STYLE_FILE_PATH}
                                COMMAND ${CLANG_FORMAT_EXE} -style=${CLANG_FORMAT_ME_DEFAULT_STYLE} -dump-config > ${CLANG_FORMAT_STYLE_FILE_PATH})
            break()
        else()
            get_filename_component(CLANG_FORMAT_STYLE_FILE_PATH ${CLANG_FORMAT_STYLE_FILE_PATH} DIRECTORY)
        endif()
    endwhile()
    get_target_property(target_sources_list ${TARGET_NAME} SOURCES)

    foreach(source_pattern ${CLANG_FORMAT_ME_SOURCE_EXTENSIONS})
        if(NOT DEFINED source_filter)
            set(source_filter ".*${source_pattern}")
        else()
            set(source_filter "${source_filter}|.*${source_pattern}")
        endif()
    endforeach()

    list(FILTER target_sources_list INCLUDE REGEX "${source_filter}")
    list(TRANSFORM target_sources_list PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

    get_target_property(target_include_directories_list ${TARGET_NAME} INCLUDE_DIRECTORIES)

    list(TRANSFORM CLANG_FORMAT_ME_HEADER_EXTENSIONS PREPEND "*.")

    foreach(current_dir ${target_include_directories_list})
        file(GLOB_RECURSE found_target_header_list
                RELATIVE ${current_dir}
                ${CLANG_FORMAT_ME_HEADER_EXTENSIONS}
        )
        foreach(found_header ${found_target_header_list})
            list(APPEND target_sources_list "${current_dir}/${found_header}")
        endforeach()
    endforeach()

    if(DEFINED CLANG_FORMAT_ME_EXCLUDE_PATTERN)
        list(FILTER target_sources_list EXCLUDE REGEX "${CLANG_FORMAT_ME_EXCLUDE_PATTERN}")
    endif()

    foreach(file ${target_sources_list})
        string(REPLACE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} output_file ${file})
        get_filename_component(output_path ${output_file} DIRECTORY)

	    add_custom_command(OUTPUT ${output_file}.clang.format
                            COMMAND ${CLANG_FORMAT_EXE} -style=file -i ${file}
                            COMMAND mkdir -p ${output_path}
                            COMMAND touch ${output_file}.clang.format
                            DEPENDS ${file} ${CLANG_FORMAT_STYLE_FILE_PATH})
        list(APPEND target_stamps ${output_file}.clang.format)
    endforeach()

    add_custom_target(clang-format-${TARGET_NAME} DEPENDS ${target_stamps})
    add_dependencies(clang-format-all clang-format-${TARGET_NAME})
    add_dependencies(${TARGET_NAME} clang-format-${TARGET_NAME})
endfunction()
