set(TARGET_NAME "format-me")

add_library(${TARGET_NAME}
            src/test.cpp)

target_include_directories(${TARGET_NAME} 
            PUBLIC include)

target_link_libraries(${TARGET_NAME} 
                    )

clang_format_me(${TARGET_NAME})