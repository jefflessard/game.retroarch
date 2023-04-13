cmake_minimum_required(VERSION 3.5)
project(game.retroarch)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_INSTALL_PREFIX /usr)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

find_package(Kodi REQUIRED)

include_directories(${KODI_INCLUDE_DIR}
                    ${PROJECT_SOURCE_DIR}
		    /amdplex/kodi/xbmc/xbmc)

set(PROJECT_SOURCES src/client.cpp)
set(PROJECT_HEADERS src/client.h)

build_addon(${PROJECT_NAME} PROJECT DEPLIBS)

include(CPack)
