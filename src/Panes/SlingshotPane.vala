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
    public class Panes.SlingshotPane : Categories.Pane {
        private Gtk.Switch category_default;

        private Gtk.Adjustment rows_adj = new Gtk.Adjustment (0,1,10,1,1,1);
        private Gtk.Adjustment columns_adj = new Gtk.Adjustment (0,3,10,1,1,1);

        private Gtk.SpinButton rows;
        private Gtk.SpinButton columns;

        public SlingshotPane () {
            base (_("Launcher"), "preferences-tweaks-slingshot");
        }

        construct {
            if (Util.schema_exists ("io.elementary.desktop.wingpanel.applications-menu")) {
                build_ui ();
                init_data ();
                connect_signals ();
            }
        }

        private void build_ui () {
            var size_box = new Widgets.SettingsBox ();
            var category_box = new Widgets.SettingsBox ();

            rows = size_box.add_spin_button (_("Rows"), rows_adj);
            columns = size_box.add_spin_button (_("Columns"), columns_adj);

            category_default = category_box.add_switch (_("Show category view by default"));

            grid.add (size_box);
            grid.add (category_box);

            grid.show_all ();
        }

        protected override void init_data () {
            rows.set_value (SlingshotSettings.get_default ().rows);
            columns.set_value (SlingshotSettings.get_default ().columns);

            category_default.set_state (SlingshotSettings.get_default ().use_category);
        }

        private void connect_signals () {
             category_default.notify["active"].connect (() => {
                SlingshotSettings.get_default ().use_category = category_default.state;
            });

            connect_spin_button (rows, (val) => { SlingshotSettings.get_default ().rows = val; });
            connect_spin_button (columns, (val) => { SlingshotSettings.get_default ().columns = val; });

            connect_reset_button (() => {SlingshotSettings.get_default().reset (); });
        }
    }
}
