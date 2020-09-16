if (NOT MOSEK_INSTALL_PATH OR MOSEK_INSTALL_PATH STREQUAL "")

    set(DEFAULT_MOSEK_INSTALL_PATH "/home/$ENV{USER}/mosek/*")
    message(STATUS "Parameter MOSEK_INSTALL_PATH was not given, looking for MOSEK inside ${DEFAULT_MOSEK_INSTALL_PATH}")

    file(GLOB MOSEK_DIRS ${DEFAULT_MOSEK_INSTALL_PATH})
    list(LENGTH MOSEK_DIRS MOSEK_DIRS_LENGTH)

    if (MOSEK_DIRS_LENGTH EQUAL 0)
        message(FATAL_ERROR "Looking for MOSEK inside ${DEFAULT_MOSEK_INSTALL_PATH} failed.")
    endif()

    list(GET MOSEK_DIRS 0 MOSEK_INSTALL_PATH)
    message(STATUS "Set MOSEK_INSTALL_PATH=${MOSEK_INSTALL_PATH}")
else()
    message(STATUS "User provided MOSEK_INSTALL_PATH=${MOSEK_INSTALL_PATH}")
endif ()

# deduce exact path for mosek
if (NOT MOSEK_TOOLS_SUFFIX)
    set (MOSEK_TOOLS_SUFFIX "tools/platform/")
    if (WIN32)
        set (MOSEK_TOOLS_SUFFIX "${MOSEK_TOOLS_SUFFIX}win")
    elseif (APPLE)
        set (MOSEK_TOOLS_SUFFIX "${MOSEK_TOOLS_SUFFIX}osx")
    else ()
        set (MOSEK_TOOLS_SUFFIX "${MOSEK_TOOLS_SUFFIX}linux")
    endif ()
    if (CMAKE_SIZE_OF_VOID_P EQUAL 4)
        set (MOSEK_TOOLS_SUFFIX "${MOSEK_TOOLS_SUFFIX}32")
    else ()
        set (MOSEK_TOOLS_SUFFIX "${MOSEK_TOOLS_SUFFIX}64")
    endif ()
    set (MOSEK_TOOLS_SUFFIX "${MOSEK_TOOLS_SUFFIX}x86")
endif ()

find_path (
        MOSEK_INCLUDE_DIR
        NAMES         fusion.h
        HINTS         ${MOSEK_INSTALL_PATH}
        PATH_SUFFIXES ${MOSEK_TOOLS_SUFFIX}/h
        REQUIRED
)

find_library (
        MOSEK_LIBRARY
        NAMES         fusion64
        HINTS         ${MOSEK_INSTALL_PATH}
        PATH_SUFFIXES ${MOSEK_TOOLS_SUFFIX}/bin
        REQUIRED
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MOSEK DEFAULT_MSG MOSEK_INCLUDE_DIR MOSEK_LIBRARY)

if (NOT MOSEK_FOUND)
    message(FATAL_ERROR "Could not find solver MOSEK")
endif()

mark_as_advanced(MOSEK_INCLUDE_DIR MOSEK_LIBRARY)