##########################################
# CMake universal template for ASM/C/C++ #
# Version: 1.1                           #
# Author : Igorek536                     #
# Licence: GPL                           #
##########################################

##### [ REQUIREMENTS ] #####
# - gcc   : i386
# - g++   : i386
# - FASM

##### [ CONFIG       ] #####

## Project name
set(PROJ_NAME RKernel)

## Project build type (Release/Debug)
set(PROJ_BUILD Debug)

## Project bits 32/64
## ARM currently unsupported
set(PROJ_BITS 32)

## C/C++ standart
set(PROJ_C_STANDART 11)
set(PROJ_CXX_STANDART 17)

## Link libraries
set(PROJ_LINK_LIBRARIES )

## Assembler support
set(PROJ_USE_ASSEMBLER TRUE)

## Source directory
set(PROJ_SRC_DIR src)

## Linker script
set(PROJ_LINKER_SCRIPT "link.ld")

## Additional compiller flags
set(PROJ_CXX_ADDITIONAL_FLAGS "-m32")
set(PROJ_C_ADDITIONAL_FLAGS "-m32")

## Additional linker flags
set(PROJ_LINKER_ADDITIONAL_FLAGS "-m32 -nostdlib ")

##### [ LOGIC        ] #####
cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules/CMakeFasm")

project(${PROJ_NAME} C CXX)
set(CMAKE_CXX_STANDARD  ${PROJ_CXX_STANDART})
set(CMAKE_C_STANDARD    ${PROJ_C_STANDART})
set(CMAKE_BUILD_TYPE    ${PROJ_BUILD})
set(CMAKE_CXX_FLAGS     "${CMAKE_CXX_FLAGS} ${PROJ_CXX_ADDITIONAL_FLAGS}")
set(CMAKE_C_FLAGS       "${CMAKE_C_FLAGS} ${PROJ_C_ADDITIONAL_FLAGS}")

if(PROJ_USE_ASSEMBLER)
    if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        if (${PROJ_BITS} STREQUAL "32")
            set(CMAKE_ASM_FASM_OBJECT_FORMAT elf32)
            message("Enabled FASM i386 support!")
        endif(${PROJ_BITS} STREQUAL "32")
        if (${PROJ_BITS} STREQUAL "64")
            set(CMAKE_ASM_FASM_OBJECT_FORMAT elf64)
            message("Enabled FASM x86_64 support!")
        endif (${PROJ_BITS} STREQUAL "64")
    endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        set(CMAKE_ASM_FASM_OBJECT_FORMAT macho64)
        #set(CMAKE_ASM_FASM_FLAGS "-DMACOS")
        message("Enabled FASM OSX support!")
    endif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(CMAKE_ASM_FASM_COMPILER ${CMAKE_CURRENT_SOURCE_DIR}/FASM/fasm)
    enable_language(ASM_FASM)
endif(PROJ_USE_ASSEMBLER)

if(PROJ_BUILD STREQUAL "Release")
    message("Building release...")
    set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/build-release)
else()
    message("Building debug...")
    set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/build-debug)
endif()

if (PROJ_LINKER_SCRIPT STREQUAL "")
    message("No linker script!")
    set(CMAKE_EXE_LINKER_FLAGS "${PROJ_LINKER_ADDITIONAL_FLAGS} ${CMAKE_EXE_LINKER_FLAGS}")
else()
    message("Using custom linker script!")
    set(CMAKE_EXE_LINKER_FLAGS "${PROJ_LINKER_ADDITIONAL_FLAGS} ${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_SOURCE_DIR}/${PROJ_LINKER_SCRIPT}")
endif()

file(GLOB_RECURSE CPP_SRC ${PROJ_SRC_DIR}/*.cpp ${PROJ_SRC_DIR}/*.h ${PROJ_SRC_DIR}/*.c)
file(GLOB_RECURSE ASM_SRC ${PROJ_SRC_DIR}/*.asm)
set(PROJECT_SRC ${CPP_SRC} ${ASM_SRC})
add_executable(${PROJECT_NAME} ${PROJECT_SRC})
target_link_libraries(${PROJECT_NAME} ${PROJ_LINK_LIBRARIES})
