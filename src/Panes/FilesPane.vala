/*
 * Copyright (C) Elementary Tweaks Developers, 2016
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace ElementaryTweaks {
    public class Panes.FilesPane : Categories.Pane {
        private Gtk.Switch single_click;
        private Gtk.Switch restore_tabs;
        private Gtk.ComboBox date_format;

        private Gtk.ListStore date_format_store;

        public FilesPane () {
            base (_("Files"), "system-file-manager");
        }

        construct {
            if (Util.schema_exists ("org.pantheon.files.preferences") || Util.schema_exists ("io.elementary.files.preferences")) {
                build_ui ();
                make_stores ();
                init_data ();
                connect_signals ();
            }
        }

        private void build_ui () {
            var files_box = new Widgets.SettingsBox ();

            single_click = files_box.add_switch (_("Single click"));
            restore_tabs = files_box.add_switch (_("Restore Tabs"));
            date_format = files_box.add_combo_box (_("Date format"));

            grid.add (files_box);
            grid.show_all ();
        }

        private void make_stores () {
            int date_index;
            date_format_store = FilesSettings.get_date_formats (out date_index);
        }

        protected override void init_data () {
            int date_index;

            FilesSettings.get_date_formats (out date_index);
            date_format.set_model (date_format_store);
            date_format.set_active (date_index);

            single_click.set_state (FilesSettings.get_default ().single_click);
            restore_tabs.set_state (FilesSettings.get_default ().restore_tabs);
        }

        private void connect_signals () {
            connect_combobox (date_format, date_format_store, (val) => { FilesSettings.get_default ().date_format = val; });

            single_click.notify["active"].connect (() => {
                FilesSettings.get_default ().single_click = single_click.active;
            });

            restore_tabs.notify["active"].connect (() => {
                FilesSettings.get_default ().restore_tabs = restore_tabs.active;
            });

            connect_reset_button (() => {
                FilesSettings.get_default ().reset ();
            });
        }
    }
}
