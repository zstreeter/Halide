# TODO: make this dependent on distrib/ instead?
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/common" "${HALIDE_INCLUDE_DIR}")

# all plugins need -fPIC
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_subdirectory(common)
add_subdirectory(Adams2019)
add_subdirectory(Li2018)
add_subdirectory(Mullapudi2016)
