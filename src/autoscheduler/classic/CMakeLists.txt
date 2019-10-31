# libhlsched_classic
add_library(hlsched_classic SHARED AutoSchedule.cpp)

target_link_libraries(hlsched_classic PRIVATE Halide)

if (NOT MSVC)
    set_target_properties(hlsched_classic PROPERTIES LINK_FLAGS "-rdynamic")
elseif (APPLE)
    set_target_properties(hlsched_classic PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
endif ()

if (NOT HALIDE_ENABLE_RTTI)
    if (NOT MSVC)
        target_compile_options(hlsched_classic PUBLIC "-fno-rtti")
    else ()
        target_compile_options(hlsched_classic PUBLIC "/GR-")
    endif ()
endif ()

install(TARGETS hlsched_classic LIBRARY DESTINATION bin)
