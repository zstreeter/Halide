# libhlsched_gradient
add_library(hlsched_gradient SHARED GradientAutoscheduler.cpp ASLog.cpp)

if (HALIDE_LIBRARY_TYPE STREQUAL STATIC)
else ()
    target_link_libraries(hlsched_gradient PRIVATE Halide)
endif ()

if (NOT MSVC)
    set_target_properties(hlsched_gradient PROPERTIES LINK_FLAGS "-rdynamic")
elseif (APPLE)
    set_target_properties(hlsched_gradient PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
endif ()

if (NOT HALIDE_ENABLE_RTTI)
    if (NOT MSVC)
        target_compile_options(hlsched_gradient PUBLIC "-fno-rtti")
    else ()
        target_compile_options(hlsched_gradient PUBLIC "/GR-")
    endif ()
endif ()

install(TARGETS hlsched_gradient LIBRARY DESTINATION bin)
