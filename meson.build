project('elementary-tweaks', 'vala', 'c')

switchboard_dep = dependency('switchboard-2.0')

gettext_name = meson.project_name() + '-plug'
pkgdatadir = join_paths(switchboard_dep.get_pkgconfig_variable('plugsdir'), 'personal')
i18n = import('i18n')

add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language:'c'
)

subdir('data')
subdir('po')
subdir('src')

meson.add_install_script('meson/post_install.py')
