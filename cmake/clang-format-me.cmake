
set(CLANG_FORMAT_EXE clang-format-6.0)

function(clang_format_me target_name)
    # set(oneValueArgs DESTINATION RENAME)
    # set(multiValueArgs TARGETS CONFIGURATIONS)
    # cmake_parse_arguments(MY_INSTALL "${options}" "${oneValueArgs}"
    #                     "${multiValueArgs}" ${ARGN} )
    # ADD:
    # exclude pattern

    add_custom_target(clang-format-all)
    get_target_property(target_sources_list ${target_name} SOURCES)
    list(TRANSFORM target_sources_list PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

    get_target_property(target_include_directories_list ${target_name} INCLUDE_DIRECTORIES)

    foreach(current_dir ${target_include_directories_list})
        file(GLOB_RECURSE found_target_header_list
                RELATIVE ${current_dir}
                *.[h]
                *.[h]pp
        )
        foreach(found_header ${found_target_header_list})
            list(APPEND target_sources_list "${current_dir}/${found_header}")
        endforeach()
    endforeach()

    foreach(file ${target_sources_list})
        string(REPLACE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} output_file ${file})
        get_filename_component(output_path ${output_file} DIRECTORY)

	    add_custom_command(OUTPUT ${output_file}.clang_format
                            COMMAND ${CLANG_FORMAT_EXE} -i ${file}
                            COMMAND mkdir -p ${output_path}
                            COMMAND touch ${output_file}.clang_format
                            DEPENDS ${file})
        list(APPEND target_stamps ${output_file}.clang_format)
    endforeach()

    add_custom_target(clang-format-${target_name} DEPENDS ${target_stamps})
    add_dependencies(clang-format-all clang-format-${target_name})
endfunction()
