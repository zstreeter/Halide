set(GENERATORS
    addconstant_generator.cpp
    bit_generator.cpp
    complexstub_generator.cpp
    nobuildmethod_generator.cpp
    partialbuildmethod_generator.cpp
    simplestub_generator.cpp
    user_context_generator.cpp
    )

foreach (GEN IN LISTS GENERATORS)
    string(REPLACE "_generator.cpp" "" TARGET "${GEN}")
    add_generator_python(${TARGET} ${GEN})
endforeach ()

add_library(the_sort_function MODULE the_sort_function.c)
target_link_libraries(the_sort_function PRIVATE Halide::Runtime)
