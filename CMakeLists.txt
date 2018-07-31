cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

# Set the Properties of your Plug
set (PLUGNAME "tweaks")
set (PLUGCATEGORY "personal")
set (PLUGTITLE "System Tweaks")
set (PLUGICON "preferences-desktop-tweaks")

set (VERSION "1.0")
project (elementary-tweaks)

# Comment this out to enable C compiler warnings
add_definitions (-w)

include (GNUInstallDirs)
set (DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
set (PKGDATADIR "${DATADIR}/${PLUGCATEGORY}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}-plug")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configure file
configure_file (${CMAKE_SOURCE_DIR}/config.vala.cmake ${CMAKE_BINARY_DIR}/src/config.vala)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-desktop-tweaks.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-anim.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-cerbere.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-shadows.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-slingshot.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;/.gitignore/.git/;;~$;${CPACK_SOURCE_IGNORE_FILES}")
include (CPack)
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

# Translation stuff
add_subdirectory (po)

# Info-plug
install (FILES ${resources} DESTINATION ${PKGDATADIR})

add_subdirectory(src)

