# Define library target and properties
file(GLOB SOURCE_FILE src/*.cpp)
add_library(LibraryTargetName ${SOURCE_FILE})

# Include directories for the library
target_include_directories(LibraryTargetName PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include )
add_executable(${PROJECT_NAME} ${SOURCE_FILE})
