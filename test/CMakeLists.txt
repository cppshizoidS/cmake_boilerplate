include(GoogleTest)

set(SOURCE_FILES test_main.cpp)

# Test executable
add_executable(Tests ${SOURCE_FILES})

# Link with Google Test
target_link_libraries(Tests GTest::GTest GTest::Main)

gtest_add_tests(TARGET Tests)
