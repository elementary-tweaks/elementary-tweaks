project('elementary-tweaks', 'vala', 'c')

switchboard_dep = dependency('switchboard-2.0')

i18n = import('i18n')

add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()),
    language:'c'
)

subdir('po')
subdir('src')
