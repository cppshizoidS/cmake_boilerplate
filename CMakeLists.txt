cmake_minimum_required(VERSION 3.26)
project(${PROJECT_NAME} LANGUAGES CXX) #change ${PROJECT_NAME} to actual projet name only in project()

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#lld
set(CMAKE_EXE_LINKER_FLAGS -fuse-ld=lld)

find_program(IWYU_PROGRAM NAMES include-what-you-use) # https://github.com/include-what-you-use/include-what-you-use
if(IWYU_PROGRAM)
  set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${IWYU_PROGRAM})
endif()

#doxygen
if (DOCS)
  add_subdirectory(docs)
endif()

#debug
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -fsanitize=address -fsanitize=undefined -fsanitize=thread -fsanitize=memory -fPIE -pie -fno-omit-frame-pointer -g)
endif()

#  Functions
function(copy_after_build TARGET_NAME)
  set(DESTDIR ${CMAKE_CURRENT_LIST_DIR}/bin/)
  file(MAKE_DIRECTORY ${DESTDIR})
  # Copy binary file to <CMakeLists.txt didctory>./bin after target is compiled.
  add_custom_command(
    TARGET ${TARGET_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${TARGET_NAME}> ${DESTDIR})
endfunction()

#change to actu path
set(CMAKE_PREFIX_PATH "/home/cppshizoid/*/*/*/*/*/*")

find_package(Qt6 COMPONENTS
        Core
        Gui
        Widgets
        REQUIRED)

# qml and images
qt_add_qml_module(myapp
    URI hello
    QML_FILES
        main.qml
    RESOURCES
        img/world.png
)

#Target Configurations
file(GLOB SOURCE_FILE src/*.cpp)
add_executable(${PROJECT_NAME} ${SOURCE_FILE} app.qrc)

target_include_directories(${PROJECT_NAME} PRIVATE include)

add_subdirectory(lib)

# Link  main project with the library
target_link_libraries(${PROJECT_NAME} lib)
# Link libs with target
target_link_libraries(${PROJECT_NAME}
        Qt::Core
        Qt::Gui
        Qt::Widgets
)
