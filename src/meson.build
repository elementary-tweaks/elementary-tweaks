plug_files = files(
    'Tweaks.vala',
    'Util.vala',
    'Settings/AudienceSettings.vala',
    'Settings/IndicatorSoundSettings.vala',
    'Settings/FilesSettings.vala',
    'Settings/GalaSettings.vala',
    'Settings/GtkSettings.vala',
    'Settings/PlankSettings.vala',
    'Settings/KeyboardSettings.vala',
    'Settings/SlingshotSettings.vala',
    'Settings/CerbereSettings.vala',
    'Settings/GnomeSettings.vala',
    'Settings/TerminalSettings.vala',
    'Settings/XSettings.vala',
    'Panes/AudiencePane.vala',
    'Panes/AnimationsPane.vala',
    'Panes/AppearancePane.vala',
    'Panes/FontsPane.vala',
    'Panes/MiscPane.vala',
    'Panes/FilesPane.vala',
    'Panes/TerminalPane.vala',
    'Panes/CerberePane.vala',
    'Panes/PlankPane.vala',
    'Panes/SlingshotPane.vala',
    'Objects/ShortcutObject.vala',
    'Widgets/Categories.vala',
    'Widgets/SettingBox.vala',
    'Widgets/Label.vala',
)

gettext_data = configuration_data()
gettext_data.set('GETTEXT_PACKAGE', meson.project_name())
gettext_declaration = configure_file(
    configuration: gettext_data,
    input: 'config.vala.in',
    output: '@BASENAME@'
)

shared_module(
    meson.project_name(),
    plug_files,
    dependencies: [
        dependency('gconf-2.0'),
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('polkit-gobject-1'),
        meson.get_compiler('vala').find_library('posix'),
        switchboard_dep
    ],
    install: true
)
