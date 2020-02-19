include(HalideGeneratorHelpers)

##
# Convenience method for defining test cases in this directory.
##

function(halide_define_aot_test NAME)
    set(options OMIT_DEFAULT_GENERATOR)
    set(oneValueArgs FUNCTION_NAME HALIDE_TARGET)
    set(multiValueArgs GENERATOR_ARGS DEPS FILTER_DEPS HALIDE_TARGET_FEATURES)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(TARGET "generator_aot_${NAME}")
    add_executable("${TARGET}" "${NAME}_aottest.cpp")
    target_include_directories("${TARGET}" PRIVATE "${Halide_SOURCE_DIR}/test/common")
    target_link_libraries(${TARGET} PRIVATE Halide::Halide ${NAME} ${CMAKE_DL_LIBS} Threads::Threads)
    add_halide_test("${TARGET}" GROUPS generator travis)
endfunction(halide_define_aot_test)

##
# Write down build rules for all the generators
##

set(GENERATOR_SRCS
    acquire_release_generator.cpp
    alias_generator.cpp
    argvcall_generator.cpp
    async_parallel_generator.cpp
    autograd_generator.cpp
    bit_operations_generator.cpp
    blur2x2_generator.cpp
    buffer_copy_generator.cpp
    buildmethod_generator.cpp
    can_use_target_generator.cpp
    cleanup_on_error_generator.cpp
    configure_generator.cpp
    cxx_mangling_define_extern_generator.cpp
    cxx_mangling_generator.cpp
    define_extern_opencl_generator.cpp
    embed_image_generator.cpp
    error_codes_generator.cpp
    example_generator.cpp
    extern_output_generator.cpp
    external_code_generator.cpp
    float16_t_generator.cpp
    gpu_object_lifetime_generator.cpp
    gpu_only_generator.cpp
    image_from_array_generator.cpp
    mandelbrot_generator.cpp
    matlab_generator.cpp
    memory_profiler_mandelbrot_generator.cpp
    metadata_tester_generator.cpp
    msan_generator.cpp
    #    multitarget_generator.cpp  # see issue #4619
    nested_externs_generator.cpp
    output_assign_generator.cpp
    pyramid_generator.cpp
    rdom_input_generator.cpp
    string_param_generator.cpp
    tiled_blur_generator.cpp
    user_context_generator.cpp
    user_context_insanity_generator.cpp
    variable_num_threads_generator.cpp
    )

# Common extra functionality needed by certain tests.
add_library(cxx_mangling_externs STATIC cxx_mangling_externs.cpp)

# Special configuration for various tests.
set(FN_NAME_cxx_mangling HalideTest::AnotherNamespace::cxx_mangling)
set(FEATURES_cxx_mangling c_plus_plus_name_mangling)

set(FEATURES_gpu_object_lifetime debug)

set(FEATURES_matlab matlab)

set(FEATURES_memory_profiler_mandelbrot profile)

set(FEATURES_msan msan)

set(HL_TARGET_multitarget host host-debug)
set(FEATURES_multitarget c_plus_plus_name_mangling)
set(FN_NAME_multitarget HalideTest::multitarget)

set(PARAMS_pyramid levels=10)

set(PARAMS_string_param rpn_expr="5 y * x +")

set(FEATURES_user_context user_context)
set(FEATURES_user_context_insanity user_context)

# Create the generator / filter-library targets.
foreach (FILE ${GENERATOR_SRCS})
    string(REPLACE "_generator.cpp" "" GEN_NAME "${FILE}")

    add_executable("${GEN_NAME}.generator" "${FILE}")
    target_link_libraries("${GEN_NAME}.generator" PRIVATE Halide::Generator)

    set(PARAMS ${PARAMS_${GEN_NAME}})
    set(FEATURES ${FEATURES_${GEN_NAME}})
    set(HL_TARGET ${HL_TARGET_${GEN_NAME}})
    set(FN_NAME ${FN_NAME_${GEN_NAME}})

    add_halide_library(${GEN_NAME}
                       FROM "${GEN_NAME}.generator"
                       PARAMS ${PARAMS}
                       TARGETS ${HL_TARGET}
                       FUNCTION_NAME ${FN_NAME}
                       FEATURES ${FEATURES})
endforeach ()

target_link_libraries(cxx_mangling INTERFACE cxx_mangling_externs)

target_link_libraries(external_code.generator PRIVATE external_code_generator_deps)

add_halide_library(nested_externs_root FROM nested_externs.generator)
add_halide_library(nested_externs_inner FROM nested_externs.generator)
add_halide_library(nested_externs_combine FROM nested_externs.generator)
add_halide_library(nested_externs_leaf FROM nested_externs.generator)

##
# Define a nontrivial dependency for external_code.generator
##

file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external_code_extern.cpp" EXTERNAL_CPP)

set(EC32 "external_code_extern_bitcode_32")
add_custom_command(OUTPUT "${EC32}.bc"
                   DEPENDS external_code_extern.cpp
                   COMMAND clang -O3 -c -m32 -target le32-unknown-nacl-unknown -emit-llvm "${EXTERNAL_CPP}" -o "${EC32}.bc")
add_custom_command(OUTPUT "${EC32}.cpp"
                   DEPENDS "${EC32}.bc"
                   COMMAND binary2cpp external_code_extern_bitcode_32 < "${EC32}.bc" > "${EC32}.cpp")

set(EC64 "external_code_extern_bitcode_64")
add_custom_command(OUTPUT "${EC64}.bc"
                   DEPENDS external_code_extern.cpp
                   COMMAND clang -O3 -c -m64 -target le64-unknown-unknown-unknown -emit-llvm "${EXTERNAL_CPP}" -o "${EC64}.bc")
add_custom_command(OUTPUT "${EC64}.cpp"
                   DEPENDS "${EC64}.bc"
                   COMMAND binary2cpp external_code_extern_bitcode_64 < "${EC64}.bc" > "${EC64}.cpp")

set(ECCPP "external_code_extern_cpp_source")
add_custom_command(OUTPUT "${ECCPP}.cpp"
                   DEPENDS external_code_extern.cpp
                   COMMAND binary2cpp external_code_extern_cpp_source < "${EXTERNAL_CPP}" > "${ECCPP}.cpp")

add_library(external_code_generator_deps OBJECT "${EC32}.cpp" "${EC64}.cpp" "${ECCPP}.cpp")

##
# Ahead of Time tests
##

#halide_define_aot_test(cleanup_on_error) # requires access to internal header runtime/device_interface.h
halide_define_aot_test(acquire_release)
halide_define_aot_test(argvcall)
halide_define_aot_test(can_use_target)
halide_define_aot_test(configure)
halide_define_aot_test(cxx_mangling)
halide_define_aot_test(define_extern_opencl)
halide_define_aot_test(embed_image)
halide_define_aot_test(error_codes)
halide_define_aot_test(example)
halide_define_aot_test(external_code)
halide_define_aot_test(float16_t)
halide_define_aot_test(gpu_object_lifetime)
halide_define_aot_test(gpu_only)
halide_define_aot_test(image_from_array)
halide_define_aot_test(mandelbrot)
halide_define_aot_test(memory_profiler_mandelbrot)
halide_define_aot_test(msan)
halide_define_aot_test(output_assign)
halide_define_aot_test(pyramid)
halide_define_aot_test(string_param)
halide_define_aot_test(user_context)
halide_define_aot_test(user_context_insanity)
halide_define_aot_test(variable_num_threads)

#halide_define_aot_test(multitarget)  # see issue #4619

halide_define_aot_test(matlab)
set_target_properties(generator_aot_matlab PROPERTIES ENABLE_EXPORTS True)

return()

# Tests that require nonstandard targets, namespaces, args, etc.

if (TARGET_PTX)
    halide_library_from_generator(cxx_mangling_gpu
                                  GENERATOR cxx_mangling.generator
                                  FUNCTION_NAME HalideTest::cxx_mangling_gpu
                                  HALIDE_TARGET_FEATURES c_plus_plus_name_mangling cuda)
    target_link_libraries(generator_aot_cxx_mangling PRIVATE cxx_mangling_gpu)
endif ()

# Tests that require additional dependencies, args, etc
set(MDTEST_GEN_ARGS
    input.type=uint8 input.dim=3
    dim_only_input_buffer.type=uint8
    untyped_input_buffer.type=uint8 untyped_input_buffer.dim=3
    output.type=float32,float32 output.dim=3
    input_not_nod.type=uint8 input_not_nod.dim=3
    input_nod.dim=3
    input_not.type=uint8
    array_input.size=2
    array_i8.size=2
    array_i16.size=2
    array_i32.size=2
    array_h.size=2
    buffer_array_input2.dim=3
    buffer_array_input3.type=float32
    buffer_array_input4.dim=3
    buffer_array_input4.type=float32
    buffer_array_input5.size=2
    buffer_array_input6.size=2
    buffer_array_input6.dim=3
    buffer_array_input7.size=2
    buffer_array_input7.type=float32
    buffer_array_input8.size=2
    buffer_array_input8.dim=3
    buffer_array_input8.type=float32
    buffer_f16_untyped.type=float16
    array_outputs.size=2
    array_outputs7.size=2
    array_outputs8.size=2
    array_outputs9.size=2
    )

halide_define_aot_test(metadata_tester GENERATOR_ARGS "${MDTEST_GEN_ARGS}")

halide_library_from_generator(metadata_tester_ucon
                              GENERATOR metadata_tester.generator
                              HALIDE_TARGET_FEATURES user_context
                              GENERATOR_ARGS "${MDTEST_GEN_ARGS}"
                              EXTRA_OUTPUTS stmt assembly)

target_link_libraries(generator_aot_metadata_tester PUBLIC metadata_tester_ucon)

# needs gradient-descent variant as well
halide_define_aot_test(autograd)
halide_library_from_generator(autograd_grad
                              GENERATOR autograd.generator
                              FUNCTION_NAME autograd_grad
                              GRADIENT_DESCENT 1
                              GENERATOR_ARGS "auto_schedule=true")
target_link_libraries(generator_aot_autograd PUBLIC autograd_grad)

# Needs an extra library from this Generator
halide_define_aot_test(alias)
halide_library(alias_with_offset_42
               SRCS alias_generator.cpp
               GENERATOR_NAME alias_with_offset_42)
target_link_libraries(generator_aot_alias PUBLIC alias_with_offset_42)

halide_define_aot_test(tiled_blur)
halide_library_from_generator(blur2x2)
target_link_libraries(generator_aot_tiled_blur PUBLIC blur2x2)

add_library(cxx_mangling_define_extern_externs STATIC cxx_mangling_define_extern_externs.cpp)
target_link_libraries(cxx_mangling_define_extern_externs PRIVATE cxx_mangling_externs cxx_mangling)

halide_define_aot_test(cxx_mangling_define_extern
                       HALIDE_TARGET_FEATURES c_plus_plus_name_mangling user_context
                       FUNCTION_NAME HalideTest::cxx_mangling_define_extern
                       FILTER_DEPS cxx_mangling_externs cxx_mangling_define_extern_externs)
# The cxx_mangling library was already defined implicitly, above,
# so just add a dependency on it
target_link_libraries(generator_aot_cxx_mangling_define_extern PUBLIC cxx_mangling)

halide_define_aot_test(nested_externs OMIT_DEFAULT_GENERATOR)
foreach (G root inner combine leaf)
    halide_library_from_generator(nested_externs_${G})
    target_link_libraries(generator_aot_nested_externs PRIVATE nested_externs_${G})
endforeach ()
