#!/usr/bin/env python3

from os import environ, path
from subprocess import call

if not environ.get('DESTDIR'):
    install_prefix = environ.get('MESON_INSTALL_PREFIX')
    print('Updating icon cache…')
    call(['gtk-update-icon-cache', '-qtf', path.join(install_prefix, 'share/icons/hicolor')])
