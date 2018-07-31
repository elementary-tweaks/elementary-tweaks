include (Translations)
add_translations_directory("${GETTEXT_PACKAGE}")
add_translations_catalog("${GETTEXT_PACKAGE}"
    ../src
    ../src/Grids
    ../src/Objects
    ../src/Settings
    ../src/TweakTemplates
    ../src/Widgets
)
