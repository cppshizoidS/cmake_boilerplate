cmake_minimum_required(VERSION 3.26)
project(${PROJECT_NAME} LANGUAGES CXX) #change ${PROJECT_NAME} to actual projet name only in project()
# standart
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
#nvim/vscode
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# configurations
set(CMAKE_CONFIGURATION_TYPES
    "Debug;Release;RelWithDebInfo;MinSizeRel"
    CACHE STRING "" FORCE)

#lld
set(CMAKE_EXE_LINKER_FLAGS -fuse-ld=mold)
#lto
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)

# include what you use
find_program(IWYU_PROGRAM NAMES include-what-you-use) # https://github.com/include-what-you-use/include-what-you-use
if(IWYU_PROGRAM)
  set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${IWYU_PROGRAM})
endif()

#doxygen
if (DOCS)
  add_subdirectory(docs)
endif()

# caching on ci
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_PROGRAM})
  set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ${CCACHE_PROGRAM})
endif()

#Target Configurations
file(GLOB SOURCE_FILE src/*.cpp)
add_executable(${PROJECT_NAME} ${SOURCE_FILE})
# Include headers dir
target_include_directories(${PROJECT_NAME} PRIVATE include)
# add lib dir
add_subdirectory(lib)

#debug
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /Od /Ob0 /Wall /sdl /Zi /fsanitize=address /GS /RTC1 #dll /MDd)
  else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -fsanitize=address -fsanitize=undefined -fsanitize=thread -fsanitize=memory -fPIE -pie -fno-omit-frame-pointer -g)
  endif()
endif()

# release
if (CMAKE_BUILD_TYPE STREQUAL "Release")
  include(CheckIPOSupported)
  check_ipo_supported(RESULT result)
  if(result)
    set_target_properties(${PROJECT_NAME} PROPERTIES INTERPROCEDURAL_OPTIMIZATION TRUE)
  else()
    message(WARNING "IPO is not supported: ${result}")
  endif()
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


# Find Packages conan
#fmt until all compilers will support C++20 format and C++23 print
find_package(fmt CONFIG REQUIRED)
# alternative for cin(C++ streams) and scanf(C std non typesafe func)
find_package(scnlib CONFIG REQUIRED)
#boost
find_package(Boost CONFIG REQUIRED)
#graphics
find_package(glfw3 CONFIG REQUIRED)
find_package(glm CONFIG REQUIRED)
find_package(glew CONFIG REQUIRED)
find_package(imgui CONFIG REQUIRED)
#regex
find_package(ctre CONFIG REQUIRED)
#sfml
find_package(SFML CONFIG REQUIRED)
#poco
find_package(Poco CONFIG REQUIRED Data Net Util XML)


# Link  main project with the library
target_link_libraries(${PROJECT_NAME} lib)

target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt)
target_link_libraries(${PROJECT_NAME} PRIVATE scnlib::scnlib)
target_link_libraries(${PROJECT_NAME} PRIVATE Boost::boost)
# Link libs with target glm
target_link_libraries(${PROJECT_NAME} PRIVATE glm)
# glfw
target_link_libraries(${PROJECT_NAME} PRIVATE glfw)
# glew
target_link_libraries(${PROJECT_NAME} PRIVATE GLEW::GLEW)
# imgui
target_link_libraries(${PROJECT_NAME} PRIVATE imgui::imgui)
# crte
target_link_libraries(${PROJECT_NAME} PRIVATE ctre::ctre)
# sfml
target_link_libraries(${PROJECT_NAME} PRIVATE sfml::sfml)
# poco
target_link_libraries(${PROJECT_NAME} PRIVATE Poco::Data Poco::Net Poco::Util Poco::XML)


# boost
#if(NOT WIN32)
  target_link_libraries(${PROJECT_NAME} PRIVATE boost::system pthread)
#else()
# Windows WIN32 API
 target_link_libraries(${PROJECT_NAME} PRIVATE boost::system)
#endif()



#Test
include(CTest)
enable_testing()
add_subdirectory(test)

find_package(GTest REQUIRED)

#Use in graphics projects
############## Build SHADERS #######################
find_program(GLSL_VALIDATOR glslangValidator HINTS
  ${Vulkan_GLSLANG_VALIDATOR_EXECUTABLE}
  /usr/bin
  /usr/local/bin
  ${VULKAN_SDK_PATH}/Bin
  ${VULKAN_SDK_PATH}/Bin32
  $ENV{VULKAN_SDK}/Bin/
  $ENV{VULKAN_SDK}/Bin32/
)

# get all .vert and .frag files in shaders directory
file(GLOB_RECURSE GLSL_SOURCE_FILES
  "${PROJECT_SOURCE_DIR}/shaders/*.frag"
  "${PROJECT_SOURCE_DIR}/shaders/*.vert"
)

foreach(GLSL ${GLSL_SOURCE_FILES})
  get_filename_component(FILE_NAME ${GLSL} NAME)
  set(SPIRV "${PROJECT_SOURCE_DIR}/shaders/${FILE_NAME}.spv")
  add_custom_command(
    OUTPUT ${SPIRV}
    COMMAND ${GLSL_VALIDATOR} -V ${GLSL} -o ${SPIRV}
    DEPENDS ${GLSL})
  list(APPEND SPIRV_BINARY_FILES ${SPIRV})
endforeach(GLSL)

add_custom_target(
    Shaders
    DEPENDS ${SPIRV_BINARY_FILES}
)
