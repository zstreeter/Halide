include_directories("${CMAKE_CURRENT_SOURCE_DIR}/common" "${HALIDE_INCLUDE_DIR}")

add_subdirectory(common)
add_subdirectory(Adams2019)
add_subdirectory(Li2018)
add_subdirectory(Mullapudi2016)
