find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS REQUIRED gthread-2.0 gtk+-3.0 switchboard-2.0 granite gconf-2.0 gee-0.8 polkit-gobject-1 glib-2.0)

add_definitions (${DEPS_CFLAGS})
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.0" MINIMUM)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
    Tweaks.vala
    Util.vala
    Settings/AudienceSettings.vala
    Settings/IndicatorSoundSettings.vala
    Settings/FilesSettings.vala
    Settings/GalaSettings.vala
    Settings/GtkSettings.vala
    Settings/PlankSettings.vala
    Settings/SlingshotSettings.vala
    Settings/GnomeSettings.vala
    Settings/TerminalSettings.vala
    Settings/XSettings.vala
    Panes/AudiencePane.vala
    Panes/AnimationsPane.vala
    Panes/AppearancePane.vala
    Panes/FontsPane.vala
    Panes/MiscPane.vala
    Panes/FilesPane.vala
    Panes/TerminalPane.vala
    Panes/PlankPane.vala
    Panes/SlingshotPane.vala
    Objects/ShortcutObject.vala
    Widgets/Categories.vala
    Widgets/SettingBox.vala
    Widgets/Label.vala
    ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
    glib-2.0
    gtk+-3.0
    gee-0.8
    switchboard-2.0
    granite
    gconf-2.0
    polkit-gobject-1
    posix
OPTIONS
    --thread
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/../vapi/
)

add_library (${CMAKE_PROJECT_NAME} MODULE ${VALA_C})
target_link_libraries (${CMAKE_PROJECT_NAME} ${DEPS_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION ${PKGDATADIR})
