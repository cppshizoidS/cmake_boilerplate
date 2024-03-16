project(lib)
# Define library target and properties
file(GLOB SOURCE_FILE src/*.cpp)
add_library(lib ${SOURCE_FILE})

# Include directories for the library
target_include_directories(${PROJECT_NAME} 
    PUBLIC ${PROJECT_SOURCE_DIR}/include
    PRIVATE ${PROJECT_SOURCE_DIR}/src
    )
add_executable(${PROJECT_NAME} ${SOURCE_FILE})
