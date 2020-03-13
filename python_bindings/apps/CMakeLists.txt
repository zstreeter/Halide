set(SCRIPTS
    bilateral_grid.py
    blur.py
    erode.py
    interpolate.py
    local_laplacian.py)

foreach (SCRIPT IN LISTS SCRIPTS)
    get_filename_component(BASE ${SCRIPT} NAME_WE)
    file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${SCRIPT}" NATIVE_SCRIPT)
    add_test(NAME python_apps_${BASE}
             # Apps are broken with GPU targets.
             COMMAND
             "${CMAKE_COMMAND}" -E env "PYTHONPATH=$<TARGET_FILE_DIR:Halide::Python>" "HL_TARGET=host"
             "$<TARGET_FILE:Python3::Interpreter>" "${NATIVE_SCRIPT}")
    set_tests_properties(python_apps_${BASE} PROPERTIES LABELS python)
endforeach ()
