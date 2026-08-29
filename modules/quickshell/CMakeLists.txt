cmake_minimum_required(VERSION 3.21)

project(deadfall VERSION 0.1.0 LANGUAGES CXX)

include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(ENABLE_MODULES "plugin;shell" CACHE STRING "Modules to build/install")

set(INSTALL_QMLDIR "${CMAKE_INSTALL_LIBDIR}/qt-6/qml"
    CACHE STRING "QML module install dir")
set(INSTALL_QSCONFDIR "${CMAKE_INSTALL_DATADIR}/deadfall"
    CACHE STRING "Quickshell config install dir")

add_compile_options(
    -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion
    -Wold-style-cast -Wnull-dereference -Woverloaded-virtual
    -Wdouble-promotion -Wformat=2 -Wunreachable-code
)

if("plugin" IN_LIST ENABLE_MODULES)
    add_subdirectory(plugin)
endif()

if("shell" IN_LIST ENABLE_MODULES)
    install(DIRECTORY modules DESTINATION "${INSTALL_QSCONFDIR}")
    install(FILES shell.qml DESTINATION "${INSTALL_QSCONFDIR}")
endif()

find_program(QMLLINT_EXECUTABLE qmllint)
if(QMLLINT_EXECUTABLE)
    file(GLOB_RECURSE SHELL_QML_FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/modules/*.qml"
        "${CMAKE_CURRENT_SOURCE_DIR}/shell.qml")

    add_custom_target(shell_qmllint
        COMMAND ${QMLLINT_EXECUTABLE}
            -I "${CMAKE_BINARY_DIR}/qml"
            -I "$ENV{QUICKSHELL_QML_PATH}"
            ${SHELL_QML_FILES}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Linting shell QML"
        VERBATIM)
endif()

find_program(QMLFORMAT_EXECUTABLE qmlformat)
if(QMLFORMAT_EXECUTABLE AND SHELL_QML_FILES)
    add_custom_target(qmlformat
        COMMAND ${QMLFORMAT_EXECUTABLE} -i -n ${SHELL_QML_FILES}
        COMMENT "Formatting QML in place" VERBATIM)
endif()
