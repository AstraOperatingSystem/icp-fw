cmake_minimum_required(VERSION 3.22)

# ===========================
# === Configs and Options ===
# ===========================

# Project name for CMake
set(FW_PROJECT_NAME icp-fw-app)

# Linker script
set(FW_LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/STM32F042xx_FLASH.ld)

# OpenOCD target for flashing
set(FW_OPENOCD_TARGET stm32f0x.cfg)



# ========================
# === Project building ===
# ========================
project(${FW_PROJECT_NAME}
	VERSION 0.1.0
	LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)

set(EXECUTABLE ${FW_PROJECT_NAME})
add_executable(${EXECUTABLE} "")

# Set compiler/linker options
target_compile_definitions(${EXECUTABLE} PRIVATE
	${COMPILER_DEFINES}
)
target_compile_options(${EXECUTABLE} PRIVATE
	-Wall
	-Wextra
	-Wpedantic
	-O0
    -g
	-ffunction-sections
	-fdata-sections
	-flto
)
target_link_options(${EXECUTABLE} PRIVATE
	-T ${FW_LINKER_SCRIPT}
	--specs=nano.specs
	-Wl,--gc-sections
	-flto
)

# Recurse subdirectories
add_subdirectory(src)

# Add libraries
target_link_libraries(${EXECUTABLE} PRIVATE cubemx)



# =============================
# === Dependency management ===
# =============================

# Add CPM
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CPM.cmake)

# Add FetchContent
include(FetchContent)



# ==========================
# === External libraries ===
# ==========================

# == CPM Packages ==
#CPMAddPackage(...)

# == FetchContent Packages ==
#FetchContent_Declare(...)
#FetchContent_MakeAvailable(...)

# == Library linking ==
#target_link_libraries(${EXECUTABLE} ...)



# =====================
# === Flashing code ===
# =====================

find_program(OPENOCD openocd)

add_custom_target(flash
	COMMAND ${OPENOCD} -f interface/stlink.cfg -f target/${FW_OPENOCD_TARGET} -c "program $<TARGET_FILE:${EXECUTABLE}> verify reset exit"
)
