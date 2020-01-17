set(TARGET_NAME "format-me-default-way-of-calling")

add_library(${TARGET_NAME}
            src/test.cpp
            src/test.cxx)

target_include_directories(${TARGET_NAME} 
            PUBLIC include)

target_link_libraries(${TARGET_NAME} 
                    )

clang_format_me(TARGET_NAME ${TARGET_NAME}
                HEADER_EXTENSIONS ${CLANG_FORMAT_ME_DEFAULT_HEADER_EXTENSIONS} hxx
                SOURCE_EXTENSIONS ${CLANG_FORMAT_ME_DEFAULT_SOURCE_EXTENSIONS} cxx)