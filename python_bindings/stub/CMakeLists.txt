if (NOT TARGET Halide::PyStubs)
    add_library(Halide_PyStubs INTERFACE)
    target_sources(Halide_PyStubs INTERFACE ${CMAKE_CURRENT_LIST_DIR}/PyStub.cpp ${CMAKE_CURRENT_LIST_DIR}/PyStubImpl.cpp)
    target_link_libraries(Halide_PyStubs INTERFACE Halide::Halide Python3::Python)
    add_library(Halide::PyStubs ALIAS Halide_PyStubs)
endif ()

function(add_generator_python TARGET)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    pybind11_add_module(${TARGET} MODULE SYSTEM ${args_UNPARSED_ARGUMENTS})
    target_compile_definitions(${TARGET} PRIVATE
                               "HALIDE_PYSTUB_GENERATOR_NAME=${TARGET}"
                               "HALIDE_PYSTUB_MODULE_NAME=${TARGET}")
    target_link_libraries(${TARGET} PRIVATE Halide::PyStubs)
endfunction()
