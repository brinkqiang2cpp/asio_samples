﻿# 
# Copyright (c) 2015 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

cmake_minimum_required(VERSION 2.8.11)

# Prefix for all Qt5::FreeType relative public variables
if(NOT DEFINED QT5_FREE_TYPE_PUBLIC_VAR_NS)
    set(QT5_FREE_TYPE_PUBLIC_VAR_NS "Qt5FreeType")
endif()

# Prefix for all Qt5::FreeType relative internal variables
if(NOT DEFINED QT5_FREE_TYPE_PRIVATE_VAR_NS)
    set(QT5_FREE_TYPE_PRIVATE_VAR_NS "_${QT5_FREE_TYPE_PUBLIC_VAR_NS}")
endif()

set(${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FOUND FALSE)
set(${QT5_FREE_TYPE_PUBLIC_VAR_NS}_LIBRARIES )

find_package(Qt5Gui)

if(Qt5Gui_FOUND)
    # Extract directory of Qt Core library
    get_target_property(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_LOCATION
        Qt5::Gui
        LOCATION)
    get_filename_component(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_DIR 
        "${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_LOCATION}" 
        PATH)

    set(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIBRARIES )

    find_library(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_RELEASE 
        "qtfreetype"
        HINTS "${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_DIR}"
        DOC "Release library of Qt5::FreeType")

    find_library(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_DEBUG 
        "qtfreetyped" 
        HINTS "${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_DIR}"
        DOC "Debug library of Qt5::FreeType")

    if(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_RELEASE OR ${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_DEBUG)
        set(${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FOUND TRUE)
    endif()

    if(${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FOUND)   
        # Determine linkage type of imported Qt5::FreeType (via linkage type of Qt5::Gui library)
        get_property(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_TARGET_TYPE 
            TARGET Qt5::Gui PROPERTY TYPE)
        set(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LINKAGE_TYPE "SHARED")
        if(${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_QT_GUI_TARGET_TYPE} STREQUAL "STATIC_LIBRARY")
            set(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LINKAGE_TYPE "STATIC")
        endif()

        add_library(Qt5::FreeType 
            ${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LINKAGE_TYPE} IMPORTED)

        if(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_RELEASE)
            set_property(TARGET Qt5::FreeType APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
            set_target_properties(Qt5::FreeType PROPERTIES IMPORTED_LOCATION_RELEASE 
                "${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_RELEASE}")
            list(APPEND ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_LIBRARIES 
                optimized ${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_RELEASE})
        endif()

        if(${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_DEBUG)
            set_property(TARGET Qt5::FreeType APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
            set_target_properties(Qt5::FreeType PROPERTIES IMPORTED_LOCATION_DEBUG 
                "${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_DEBUG}")
            list(APPEND ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_LIBRARIES 
                debug ${${QT5_FREE_TYPE_PRIVATE_VAR_NS}_LIB_DEBUG})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
if(${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FIND_REQUIRED AND NOT ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FIND_QUIETLY)
    find_package_handle_standard_args(${QT5_FREE_TYPE_PUBLIC_VAR_NS}
        FOUND_VAR ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FOUND
        REQUIRED_VARS ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_LIBRARIES)
else()
    find_package_handle_standard_args(${QT5_FREE_TYPE_PUBLIC_VAR_NS}
        FOUND_VAR ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_FOUND
        REQUIRED_VARS ${QT5_FREE_TYPE_PUBLIC_VAR_NS}_LIBRARIES
        FAIL_MESSAGE "Qt5::FreeType not found")
endif()
