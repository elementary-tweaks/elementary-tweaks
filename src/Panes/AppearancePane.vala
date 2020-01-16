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
    public class Panes.AppearancePane : Categories.Pane {
        private Gtk.Switch prefer_dark_switch;
        private Gtk.Switch gnome_menu;
        private Gtk.ComboBox gtk_combobox;
        //  private Gtk.ComboBox metacity_combobox;
        private Gtk.ComboBox icon_combobox;
        private Gtk.ComboBox cursor_combobox;
        private Gtk.ComboBox controls_combobox;

        private Gtk.ListStore gtk_store;
        //  private Gtk.ListStore metacity_store;
        private Gtk.ListStore icon_store;
        private Gtk.ListStore cursor_store;
        private Gtk.ListStore controls_store;

        private int gtk_index = 0;
        //private int metacity_index = 0;
        private int icon_index = 0;
        private int cursor_index = 0;
        private int controls_index = 0;

        public AppearancePane () {
            base (_("Appearance"), "applications-graphics");
        }

        construct {
            build_ui ();
            make_stores ();
            init_data ();
            connect_signals ();
        }

        private void build_ui () {
            var theme_label = new Widgets.Label (_("Theme Settings"));
            var theme_box = new Widgets.SettingsBox ();

            gtk_combobox = theme_box.add_combo_box (_("GTK+"));
            //metacity_combobox = theme_box.add_combo_box (_("Metacity (Non-GTK+ applications)"));
            icon_combobox = theme_box.add_combo_box (_("Icons"));
            cursor_combobox = theme_box.add_combo_box (_("Cursor"));
            prefer_dark_switch = theme_box.add_switch (_("Prefer dark variant"));

            grid.add (theme_label);
            grid.add (theme_box);

            var layout_label = new Widgets.Label (_("Window Controls"));
            var layout_box = new Widgets.SettingsBox ();

            controls_combobox = layout_box.add_combo_box (_("Layout"));
            gnome_menu = layout_box.add_switch (_("Show GNOME menu"));

            grid.add (layout_label);
            grid.add (layout_box);

            grid.show_all ();
        }

        private void make_stores () {
            gtk_store = Util.get_themes_store ("themes", "gtk-3.0", InterfaceSettings.get_default ().gtk_theme, out gtk_index);
            //metacity_store = Util.get_themes_store ("themes", "metacity-1", WindowSettings.get_default ().theme, out metacity_index);
            icon_store = Util.get_themes_store ("icons", "index.theme", InterfaceSettings.get_default ().icon_theme, out icon_index);
            cursor_store = Util.get_themes_store ("icons", "cursors", InterfaceSettings.get_default ().cursor_theme, out cursor_index);
            controls_store = AppearanceSettings.get_button_layouts (out controls_index);

            gtk_combobox.set_model (gtk_store);
            //  metacity_combobox.set_model (metacity_store);
            icon_combobox.set_model (icon_store);
            cursor_combobox.set_model (cursor_store);
            controls_combobox.set_model (controls_store);
        }

        protected override void init_data () {
            gtk_combobox.set_active (gtk_index);
            //metacity_combobox.set_active (metacity_index);
            icon_combobox.set_active (icon_index);
            cursor_combobox.set_active (cursor_index);
            controls_combobox.set_active (controls_index);

            gnome_menu.set_state (XSettings.get_default ().has_gnome_menu ());
            prefer_dark_switch.set_state (GtkSettings.get_default ().prefer_dark_theme);
        }

        private void connect_signals () {
            prefer_dark_switch.notify["active"].connect (() => {
                GtkSettings.get_default ().prefer_dark_theme = prefer_dark_switch.state;
            });

            connect_combobox (gtk_combobox, gtk_store, (val) => { InterfaceSettings.get_default ().gtk_theme = val; });
            //connect_combobox (metacity_combobox, metacity_store, (val) => { WindowSettings.get_default ().theme = val; });
            connect_combobox (icon_combobox, icon_store, (val) => { InterfaceSettings.get_default ().icon_theme = val; });
            connect_combobox (cursor_combobox, cursor_store, (val) => { InterfaceSettings.get_default ().cursor_theme = val; });
            connect_combobox (controls_combobox, controls_store,
                (val) => {  AppearanceSettings.get_default ().button_layout = val;
                            XSettings.get_default ().set_gnome_menu (gnome_menu.state, val);
                            });

            gnome_menu.notify["active"].connect (() => {
                controls_combobox.changed ();
            });

            connect_reset_button (()=> {
                GtkSettings.get_default().prefer_dark_theme = false;
                //WindowSettings.get_default ().reset_appearance ();
                InterfaceSettings.get_default ().reset_appearance ();
                AppearanceSettings.get_default ().reset ();
                XSettings.get_default ().reset ();
            });
        }
    }
}
