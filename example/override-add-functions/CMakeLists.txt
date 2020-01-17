set(TARGET_NAME "format-me-override-add-functions")

add_library_clang_me(${TARGET_NAME}
            src/test.cpp
            src/test.cxx)

target_include_directories(${TARGET_NAME} 
            PUBLIC include)

target_link_libraries(${TARGET_NAME} 
                    )
