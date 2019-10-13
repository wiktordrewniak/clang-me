


function(clang_format_me target_name)
    # set(oneValueArgs DESTINATION RENAME)
    # set(multiValueArgs TARGETS CONFIGURATIONS)
    # cmake_parse_arguments(MY_INSTALL "${options}" "${oneValueArgs}"
    #                     "${multiValueArgs}" ${ARGN} )
    # ADD:
    # exclude pattern

    add_custom_target(clang-format-all)
    add_custom_target(clang-format-${target_name})
    add_dependencies(clang-format-all clang-format-${target_name})

    get_target_property(target_sources_list ${target_name} SOURCES)
    get_target_property(target_include_directories_list ${target_name} INCLUDE_DIRECTORIES)

    foreach(current_dir ${target_include_directories_list})
        file(GLOB_RECURSE found_target_header_list
                RELATIVE ${current_dir}
                *.[h]
                *.[h]pp
        )
        foreach(found_header ${found_target_header_list})
            list(APPEND target_sources_list ${current_dir}/${found_header})
        endforeach()
    endforeach()

    foreach(file ${${target_sources_list}})
        message(${file})
        string(REPLACE "/" "_" CURRENT_TARGET ${file})
        add_custom_command(OUTPUT ${file}.clang-format
                            COMMAND echo ${file}
                            COMMAND touch ${file}.clang-format
                            BYPRODUCTS ${file}.clang-format
                            DEPENDS ${file})
        add_custom_target(${CURRENT_TARGET}.clang-format-marker
                          DEPENDS ${file}.clang-format)
        add_dependencies(clang-format-${target_name} ${CURRENT_TARGET}.clang-format-marker)
    endforeach()
endfunction()
