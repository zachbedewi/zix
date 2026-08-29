find_package(Qt6 REQUIRED COMPONENTS Core Qml Gui Quick Concurrent)

set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml")

qt_standard_project_setup(REQUIRES 6.8)

include(cmake/qml-module.cmake)

add_subdirectory(src/Deadfall/Services)
