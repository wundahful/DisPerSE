# - FindMathGL.cmake
# This module can be used to find MathGL and several of its optional components.
#
# You can specify one or more component as you call this find module.
# Possible components are: FLTK, GLUT, Qt, WX.
#
# The following variables will be defined for your use:
#
#  MATHGL2_FOUND           = MathGL and all specified components found
#  MATHGL2_INCLUDE_DIRS    = The MathGL include directories
#  MATHGL2_LIBRARIES       = The libraries to link against to use MathGL
#                           and all specified components
#  MATHGL2_VERSION_STRING  = A human-readable version of the MathGL (e.g. 1.11)
#  MATHGL2_XXX_FOUND       = Component XXX found (replace XXX with uppercased
#                           component name -- for example, QT or FLTK)
#
# The minimum required version and needed components can be specified using
# the standard find_package()-syntax, here are some examples:
#  find_package(MathGL 1.11 Qt REQUIRED) - 1.11 + Qt interface, required
#  find_package(MathGL 1.10 REQUIRED)    - 1.10 (no interfaces), required
#  find_package(MathGL 1.10 Qt WX)       - 1.10 + Qt and WX interfaces, optional
#  find_package(MathGL 1.11)             - 1.11 (no interfaces), optional
#
# Typical usage could be something like this:
#   find_package(MathGL 1.11 GLUT REQUIRED)
#   include_directories(${MATHGL2_INCLUDE_DIRS})
#   add_executable(myexe main.cpp)
#   target_link_libraries(myexe ${MATHGL2_LIBRARIES})
#

#=============================================================================
# Copyright (c) 2011 Denis Pesotsky <denis@kde.ru>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-MODULES for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

FIND_PATH(MATHGL2_INCLUDE_DIR
  NAMES mgl2/mgl.h 
  PATHS ${MATHGL2_DIR}/include/
  NO_DEFAULT_PATH
  )

FIND_PATH(MATHGL2_INCLUDE_DIR
          NAMES mgl2/mgl.h 
	  PATHS ${MATHGL2_DIR}/include/
          DOC "The MathGL include directory")

FIND_LIBRARY(MATHGL2_LIBRARY
             NAMES mgl
             PATHS ${MATHGL2_DIR}/include/
             NO_DEFAULT_PATH)

FIND_LIBRARY(MATHGL2_LIBRARY
             NAMES mgl
             PATHS ${MATHGL2_DIR}/lib/ ${MATHGL2_LIBRARY_DIR}
             DOC "The MathGL LIBRARY directory")

GET_FILENAME_COMPONENT(MATHGL2_LIBRARY_DIR ${MATHGL2_LIBRARY} PATH)

SET(MATHGL2_LIBRARIES ${MATHGL2_LIBRARY})
SET(MATHGL2_INCLUDE_DIRS ${MATHGL2_INCLUDE_DIR})

IF(MATHGL2_INCLUDE_DIR)
  SET(_CONFIG_FILE_NAME "mgl2/config.h")
  SET(_CONFIG_FILE_PATH "${MATHGL2_INCLUDE_DIR}/${_CONFIG_FILE_NAME}")
  SET(_VERSION_ERR "Cannot determine MathGL version")
  IF(EXISTS "${_CONFIG_FILE_PATH}")
    FILE(STRINGS "${_CONFIG_FILE_PATH}"
         MATHGL2_VERSION_STRING REGEX "^#define PACKAGE_VERSION \"[^\"]*\"$")
    IF(MATHGL2_VERSION_STRING)
      STRING(REGEX
             REPLACE "^#define PACKAGE_VERSION \"([^\"]*)\"$" "\\1"
             MATHGL2_VERSION_STRING ${MATHGL2_VERSION_STRING})
    ELSE()
      SET(MATHGL2_VERSION_STRING "2")
      #MESSAGE(FATAL_ERROR "${_VERSION_ERR}: ${_CONFIG_FILE_NAME} parse error")
    ENDIF()
  ELSE()
    MESSAGE(FATAL_ERROR "${_VERSION_ERR}: ${_CONFIG_FILE_NAME} not found")
  ENDIF()
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MathGL
                                  REQUIRED_VARS MATHGL2_LIBRARY
                                                MATHGL2_INCLUDE_DIR
                                  VERSION_VAR MATHGL2_VERSION_STRING)

FOREACH(_Component ${MathGL2_FIND_COMPONENTS})
  message("FINDING ${_Component}")
  STRING(TOLOWER ${_Component} _component)
  STRING(TOUPPER ${_Component} _COMPONENT)
  
  SET(MathGL2_${_Component}_FIND_REQUIRED ${MathGL2_FIND_REQUIRED})
  SET(MathGL2_${_Component}_FIND_QUIETLY true)
  
  FIND_PATH(MATHGL2_${_COMPONENT}_INCLUDE_DIR
            NAMES mgl2/${_component}.h
            PATHS ${MATHGL2_INCLUDE_DIR} NO_DEFAULT_PATH)
  FIND_LIBRARY(MATHGL2_${_COMPONENT}_LIBRARY
               NAMES mgl-${_component}
               PATHS ${MATHGL2_LIBRARY_DIR} NO_DEFAULT_PATH)

  FIND_PACKAGE_HANDLE_STANDARD_ARGS(MathGL2_${_Component} DEFAULT_MSG
                                    MATHGL2_${_COMPONENT}_LIBRARY
                                    MATHGL2_${_COMPONENT}_INCLUDE_DIR)
  
  IF(MATHGL2_${_COMPONENT}_FOUND)
    SET(MATHGL2_LIBRARIES
        ${MATHGL2_LIBRARIES} ${MATHGL2_${_COMPONENT}_LIBRARY})
    SET(MATHGL2_INCLUDE_DIRS
        ${MATHGL2_INCLUDE_DIRS} ${MATHGL2_${_COMPONENT}_INCLUDE_DIR})
  ENDIF()

  MARK_AS_ADVANCED(MATHGL2_${_COMPONENT}_INCLUDE_DIR
                   MATHGL2_${_COMPONENT}_LIBRARY)
ENDFOREACH()

MARK_AS_ADVANCED(MATHGL2_INCLUDE_DIR MATHGL2_LIBRARY)
