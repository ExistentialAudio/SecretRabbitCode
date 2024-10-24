cmake_minimum_required(VERSION 3.16)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
project(SecretRabbitCode LANGUAGES Swift C)

set(BUILD_TESTING CACHE BOOL OFF)
set(LIBSAMPLERATE_EXAMPLES OFF)
add_subdirectory (./libsamplerate)

add_library(SecretRabbitCode SHARED
    Sources/SecretRabbitCode/SecretRabbitCode.swift
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Sources/CSamplerate/)
add_library(CSamplerate ALIAS samplerate)

target_link_libraries(SecretRabbitCode
    PRIVATE
        CSamplerate
)
