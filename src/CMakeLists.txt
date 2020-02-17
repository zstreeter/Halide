include(CheckCXXCompilerFlag)

# The externally-visible header files that go into making Halide.h.
# Don't include anything here that includes llvm headers.
# Keep this list sorted in alphabetical order.
set(HEADER_FILES
    AddAtomicMutex.h
    AddImageChecks.h
    AddParameterChecks.h
    AlignLoads.h
    AllocationBoundsInference.h
    ApplySplit.h
    Argument.h
    AssociativeOpsTable.h
    Associativity.h
    AsyncProducers.h
    AutoSchedule.h
    AutoScheduleUtils.h
    BoundaryConditions.h
    Bounds.h
    BoundsInference.h
    BoundSmallAllocations.h
    Buffer.h
    CanonicalizeGPUVars.h
    Closure.h
    CodeGen_ARM.h
    CodeGen_C.h
    CodeGen_D3D12Compute_Dev.h
    CodeGen_GPU_Dev.h
    CodeGen_GPU_Host.h
    CodeGen_Internal.h
    CodeGen_LLVM.h
    CodeGen_Metal_Dev.h
    CodeGen_MIPS.h
    CodeGen_OpenCL_Dev.h
    CodeGen_OpenGL_Dev.h
    CodeGen_OpenGLCompute_Dev.h
    CodeGen_Posix.h
    CodeGen_PowerPC.h
    CodeGen_PTX_Dev.h
    CodeGen_PyTorch.h
    CodeGen_RISCV.h
    CodeGen_WebAssembly.h
    CodeGen_X86.h
    ConciseCasts.h
    CPlusPlusMangle.h
    CSE.h
    Debug.h
    DebugArguments.h
    DebugToFile.h
    Definition.h
    Deinterleave.h
    Derivative.h
    DerivativeUtils.h
    DeviceArgument.h
    DeviceInterface.h
    Dimension.h
    EarlyFree.h
    Elf.h
    EliminateBoolVectors.h
    EmulateFloat16Math.h
    Error.h
    Expr.h
    ExprUsesVar.h
    Extern.h
    FastIntegerDivide.h
    FindCalls.h
    Float16.h
    Func.h
    Function.h
    FunctionPtr.h
    FuseGPUThreadLoops.h
    FuzzFloatStores.h
    Generator.h
    HexagonOffload.h
    HexagonOptimize.h
    ImageParam.h
    InferArguments.h
    InjectHostDevBufferCopies.h
    InjectOpenGLIntrinsics.h
    Inline.h
    InlineReductions.h
    IntegerDivisionTable.h
    Interval.h
    Introspection.h
    IntrusivePtr.h
    IR.h
    IREquality.h
    IRMatch.h
    IRMutator.h
    IROperator.h
    IRPrinter.h
    IRVisitor.h
    JITModule.h
    Lambda.h
    Lerp.h
    LICM.h
    LLVM_Output.h
    LLVM_Runtime_Linker.h
    LoopCarry.h
    Lower.h
    LowerWarpShuffles.h
    MainPage.h
    MatlabWrapper.h
    Memoization.h
    Module.h
    ModulusRemainder.h
    Monotonic.h
    ObjectInstanceRegistry.h
    OutputImageParam.h
    ParallelRVar.h
    Param.h
    Parameter.h
    ParamMap.h
    PartitionLoops.h
    Pipeline.h
    Prefetch.h
    Profiling.h
    PurifyIndexMath.h
    PythonExtensionGen.h
    Qualify.h
    Random.h
    RDom.h
    Realization.h
    RealizationOrder.h
    Reduction.h
    RegionCosts.h
    RemoveDeadAllocations.h
    RemoveExternLoops.h
    RemoveUndef.h
    runtime/HalideBuffer.h
    runtime/HalideRuntime.h
    Schedule.h
    ScheduleFunctions.h
    Scope.h
    SelectGPUAPI.h
    Simplify.h
    SimplifyCorrelatedDifferences.h
    SimplifySpecializations.h
    SkipStages.h
    SlidingWindow.h
    Solve.h
    SplitTuples.h
    StmtToHtml.h
    StorageFlattening.h
    StorageFolding.h
    StrictifyFloat.h
    Substitute.h
    Target.h
    ThreadPool.h
    Tracing.h
    TrimNoOps.h
    Tuple.h
    Type.h
    UnifyDuplicateLets.h
    UniquifyVariableNames.h
    UnpackBuffers.h
    UnrollLoops.h
    UnsafePromises.h
    Util.h
    Var.h
    VaryingAttributes.h
    VectorizeLoops.h
    WasmExecutor.h
    WrapCalls.h
    )

# Keep this list sorted in alphabetical order.
set(SOURCE_FILES
    AddAtomicMutex.cpp
    AddImageChecks.cpp
    AddParameterChecks.cpp
    AlignLoads.cpp
    AllocationBoundsInference.cpp
    ApplySplit.cpp
    Argument.cpp
    AssociativeOpsTable.cpp
    Associativity.cpp
    AsyncProducers.cpp
    AutoSchedule.cpp
    AutoScheduleUtils.cpp
    BoundaryConditions.cpp
    Bounds.cpp
    BoundsInference.cpp
    BoundSmallAllocations.cpp
    Buffer.cpp
    CanonicalizeGPUVars.cpp
    Closure.cpp
    CodeGen_ARM.cpp
    CodeGen_C.cpp
    CodeGen_D3D12Compute_Dev.cpp
    CodeGen_GPU_Dev.cpp
    CodeGen_GPU_Host.cpp
    CodeGen_Hexagon.cpp
    CodeGen_Internal.cpp
    CodeGen_LLVM.cpp
    CodeGen_Metal_Dev.cpp
    CodeGen_MIPS.cpp
    CodeGen_OpenCL_Dev.cpp
    CodeGen_OpenGL_Dev.cpp
    CodeGen_OpenGLCompute_Dev.cpp
    CodeGen_Posix.cpp
    CodeGen_PowerPC.cpp
    CodeGen_PTX_Dev.cpp
    CodeGen_PyTorch.cpp
    CodeGen_RISCV.cpp
    CodeGen_WebAssembly.cpp
    CodeGen_X86.cpp
    CPlusPlusMangle.cpp
    CSE.cpp
    Debug.cpp
    DebugArguments.cpp
    DebugToFile.cpp
    Definition.cpp
    Deinterleave.cpp
    Derivative.cpp
    DerivativeUtils.cpp
    DeviceArgument.cpp
    DeviceInterface.cpp
    Dimension.cpp
    EarlyFree.cpp
    Elf.cpp
    EliminateBoolVectors.cpp
    EmulateFloat16Math.cpp
    Error.cpp
    FastIntegerDivide.cpp
    FindCalls.cpp
    Float16.cpp
    Func.cpp
    Function.cpp
    FuseGPUThreadLoops.cpp
    FuzzFloatStores.cpp
    Generator.cpp
    HexagonOffload.cpp
    HexagonOptimize.cpp
    ImageParam.cpp
    InferArguments.cpp
    InjectHostDevBufferCopies.cpp
    InjectOpenGLIntrinsics.cpp
    Inline.cpp
    InlineReductions.cpp
    IntegerDivisionTable.cpp
    Interval.cpp
    Introspection.cpp
    IR.cpp
    IREquality.cpp
    IRMatch.cpp
    IRMutator.cpp
    IROperator.cpp
    IRPrinter.cpp
    IRVisitor.cpp
    JITModule.cpp
    Lerp.cpp
    LICM.cpp
    LLVM_Output.cpp
    LLVM_Runtime_Linker.cpp
    LoopCarry.cpp
    Lower.cpp
    LowerWarpShuffles.cpp
    MatlabWrapper.cpp
    Memoization.cpp
    Module.cpp
    ModulusRemainder.cpp
    Monotonic.cpp
    ObjectInstanceRegistry.cpp
    OutputImageParam.cpp
    ParallelRVar.cpp
    Parameter.cpp
    ParamMap.cpp
    PartitionLoops.cpp
    Pipeline.cpp
    Prefetch.cpp
    PrintLoopNest.cpp
    Profiling.cpp
    PurifyIndexMath.cpp
    PythonExtensionGen.cpp
    Qualify.cpp
    Random.cpp
    RDom.cpp
    RealizationOrder.cpp
    Reduction.cpp
    RegionCosts.cpp
    RemoveDeadAllocations.cpp
    RemoveExternLoops.cpp
    RemoveUndef.cpp
    Schedule.cpp
    ScheduleFunctions.cpp
    SelectGPUAPI.cpp
    Simplify.cpp
    Simplify_Add.cpp
    Simplify_And.cpp
    Simplify_Call.cpp
    Simplify_Cast.cpp
    Simplify_Div.cpp
    Simplify_EQ.cpp
    Simplify_Exprs.cpp
    Simplify_Let.cpp
    Simplify_LT.cpp
    Simplify_Max.cpp
    Simplify_Min.cpp
    Simplify_Mod.cpp
    Simplify_Mul.cpp
    Simplify_Not.cpp
    Simplify_Or.cpp
    Simplify_Select.cpp
    Simplify_Shuffle.cpp
    Simplify_Stmts.cpp
    Simplify_Sub.cpp
    SimplifyCorrelatedDifferences.cpp
    SimplifySpecializations.cpp
    SkipStages.cpp
    SlidingWindow.cpp
    Solve.cpp
    SplitTuples.cpp
    StmtToHtml.cpp
    StorageFlattening.cpp
    StorageFolding.cpp
    StrictifyFloat.cpp
    Substitute.cpp
    Target.cpp
    Tracing.cpp
    TrimNoOps.cpp
    Tuple.cpp
    Type.cpp
    UnifyDuplicateLets.cpp
    UniquifyVariableNames.cpp
    UnpackBuffers.cpp
    UnrollLoops.cpp
    UnsafePromises.cpp
    Util.cpp
    Var.cpp
    VaryingAttributes.cpp
    VectorizeLoops.cpp
    WasmExecutor.cpp
    WrapCalls.cpp
    )

##
# Build and import the runtime.
##
add_subdirectory(runtime)

##
# Build the Halide mono-header
# TODO: break dependency on this for internal use
##

file(TO_NATIVE_PATH "${Halide_BINARY_DIR}/include/" NATIVE_INCLUDE_PATH)
file(TO_NATIVE_PATH "${Halide_SOURCE_DIR}/LICENSE.txt" NATIVE_LICENSE_PATH)
add_custom_command(OUTPUT "${Halide_BINARY_DIR}/include/Halide.h"
                   COMMAND build_halide_h "${NATIVE_LICENSE_PATH}" ${HEADER_FILES} > "${NATIVE_INCLUDE_PATH}Halide.h"
                   WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                   DEPENDS build_halide_h "${Halide_SOURCE_DIR}/LICENSE.txt" ${HEADER_FILES})
add_custom_target(
        HalideIncludes
        ALL
        DEPENDS "${CMAKE_BINARY_DIR}/include/Halide.h")

##
# Define the Halide library target.
##
option(HALIDE_SHARED_LIBRARY "Build as a shared library" ON)
if (HALIDE_SHARED_LIBRARY)
    set(HALIDE_LIBRARY_TYPE SHARED)
    message(STATUS "Building Halide as a shared library")
else ()
    set(HALIDE_LIBRARY_TYPE STATIC)
    message(STATUS "Building Halide as a static library")
endif ()

add_library(Halide ${HALIDE_LIBRARY_TYPE}
            ${SOURCE_FILES}
            ${HEADER_FILES}
            )

target_link_libraries(Halide PRIVATE Halide_initmod)

##
# Set definitions and compiler flags
##

# We could expose the /MP flag to all targets, but that might end up saturating the build
# since multiple MSBuild projects might get built in parallel, each of which compiling their
# source files in parallel; the Halide library itself is a "knot" point of the build graph,
# so compiling its files in parallel should not oversubscribe the system
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/MP>)

# Define Halide_SHARED or Halide_STATIC depending on library type
target_compile_definitions(Halide PRIVATE "Halide_${HALIDE_LIBRARY_TYPE}")
add_dependencies(Halide HalideIncludes)

# TODO: don't depend on headers in binary directory!
target_include_directories(Halide INTERFACE "${CMAKE_BINARY_DIR}/include")

option(TARGET_OPENCL "Include OpenCL-C target" ON)
if (TARGET_OPENCL)
    target_compile_definitions(Halide PRIVATE WITH_OPENCL)
endif ()

option(TARGET_OPENGL "Include OpenGL/GLSL target" ON)
if (TARGET_OPENGL)
    target_compile_definitions(Halide PRIVATE WITH_OPENGL)
endif ()

option(TARGET_METAL "Include Metal target" ON)
if (TARGET_METAL)
    target_compile_definitions(Halide PRIVATE WITH_METAL)
endif ()

option(TARGET_D3D12COMPUTE "Include Direct3D 12 Compute target" ON)
if (TARGET_D3D12COMPUTE)
    target_compile_definitions(Halide PRIVATE WITH_D3D12)
endif ()

target_compile_definitions(Halide PRIVATE COMPILING_HALIDE)
if (NOT LLVM_ENABLE_ASSERTIONS)
    target_compile_definitions(Halide PRIVATE NDEBUG)
endif ()

## Suppress some warnings
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4244>)  # 4244: conversion, possible loss of data
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4267>)  # 4267: conversion, possible loss of data
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4800>)  # 4800: BOOL -> true or false
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4996>)  # 4996: compiler encountered deprecated declaration
# Injected from recent LLVM:
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4141>)  # 'inline' used more than once
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4146>)  # unary minus applied to unsigned type
target_compile_options(Halide PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4291>)  # No matching operator delete found

target_compile_definitions(Halide PRIVATE
                           $<$<CXX_COMPILER_ID:MSVC>:_CRT_SECURE_NO_WARNINGS>
                           $<$<CXX_COMPILER_ID:MSVC>:_SCL_SECURE_NO_WARNINGS>)

if (MSVC)
    # To compile LLVM headers following was taken from LLVM CMake files:
    # Disable sized deallocation if the flag is supported. MSVC fails to compile
    # the operator new overload in LLVM/IR/Function.h and Instruction.h otherwise.
    # See LLVM PR: 23513 (https://llvm.org/bugs/show_bug.cgi?id=23513)
    check_cxx_compiler_flag("/WX /Zc:sizedDealloc-" SUPPORTS_SIZED_DEALLOC)
    if (SUPPORTS_SIZED_DEALLOC)
        target_compile_options(Halide PRIVATE "/Zc:sizedDealloc-")
    endif ()
endif ()

if (NOT HALIDE_ENABLE_RTTI)
    target_compile_options(Halide PUBLIC
                           $<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/GR- >
                           $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<CXX_COMPILER_ID:MSVC>>>:-fno-rtti>)
endif ()

target_link_libraries(Halide PRIVATE LLVM::LLVM LLVM::Config)

if (NOT MSVC AND NOT LLVM_USE_SHARED_LLVM_LIBRARY)
    execute_process(COMMAND llvm-config --system-libs ${LLVM_COMPONENTS} OUTPUT_VARIABLE EXTRA_LIBS)
    string(STRIP EXTRA_LIBS "${EXTRA_LIBS}")   # strip whitespace from start & end
    string(REPLACE "\n" "" EXTRA_LIBS "${EXTRA_LIBS}")
    string(REPLACE " " ";" EXTRA_LIBS "${EXTRA_LIBS}")  # convert into a list
    target_link_libraries(Halide PRIVATE ${EXTRA_LIBS})
endif ()

##
# Interface target for enabling PNG/JPEG support in Halide
##

add_library(halide_image_io INTERFACE)
foreach (LIB IN ITEMS PNG JPEG)
    if (TARGET ${LIB}::${LIB})
        target_link_libraries(halide_image_io INTERFACE ${LIB}::${LIB})
    else ()
        message(STATUS "${LIB} not found; compiling with -DHALIDE_NO_${LIB}")
        target_compile_definitions(halide_image_io INTERFACE HALIDE_NO_${LIB})
    endif ()
endforeach ()
add_library(Halide::ImageIO ALIAS halide_image_io)

##
# Install and export targets.
##

install(TARGETS Halide
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION bin
        ARCHIVE DESTINATION lib)
