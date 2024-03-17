set(EXEC example)
set(SRC main.cpp app.qrc)
set(QML main.qml)

find_package(Qt6 6.3.1 COMPONENTS Quick Gui REQUIRED)

qt_add_executable(${EXEC} ${SRC})
qt_add_qml_module(${EXEC}
    URI some
    VERSION 0.1.0
    QML_FILES ${QML}
)

target_link_libraries(${EXEC} PRIVATE Qt6::Gui Qt6::Quick)