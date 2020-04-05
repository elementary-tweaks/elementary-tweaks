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
    public class Panes.PlankPane : Categories.Pane {
        private Gtk.ComboBoxText monitor;

        private Gtk.Adjustment icon_size = new Gtk.Adjustment (0,0,1000,1,10,10);
        private Gtk.Adjustment hide_delay = new Gtk.Adjustment (0,0,1000,1,10,10);
        private Gtk.Adjustment offset = new Gtk.Adjustment (0,0,1000,1,10,10);

        public PlankPane () {
            base (_("Dock"), "plank");
        }

        construct {
            var settings = new Settings.with_path ("net.launchpad.plank.dock.settings", "/net/launchpad/plank/docks/dock1/");

            var behabiour = new Widgets.SettingsBox ();
            var appearance = new Widgets.SettingsBox ();

            var hide_mode_hashmap = new Gee.HashMap <string, string> ();
            hide_mode_hashmap.set ("none", _("Disable Hiding"));
            hide_mode_hashmap.set ("intelligent", dgettext ("plank", "Intellihide"));
            hide_mode_hashmap.set ("auto", dgettext ("plank", "Autohide"));
            hide_mode_hashmap.set ("dodge-maximized", dgettext ("plank", "Dodge maximized window"));
            hide_mode_hashmap.set ("window-dodge", dgettext ("plank", "Window Dodge"));
            hide_mode_hashmap.set ("dodge-active", dgettext ("plank", "Dodge active window"));

            //Behavior
            var behabiour_label = new Widgets.Label (_("Behavior"));
            var lock_items = behabiour.add_switch (_("Lock items"));
            var show_unpinned = behabiour.add_switch (_("Show Unpinned"));
            var current_workspace =behabiour.add_switch (_("Restrict to Workspace"));
            var hide_mode = behabiour.add_combo_box_text (_("Hide mode"), hide_mode_hashmap);
            behabiour.add_spin_button (_("Hide delay"), hide_delay);

            var screen_position_hashmap = new Gee.HashMap <string, string> ();
            screen_position_hashmap.set ("left", dgettext ("plank", "Left"));
            screen_position_hashmap.set ("right", dgettext ("plank", "Right"));
            screen_position_hashmap.set ("top", dgettext ("plank", "Top"));
            screen_position_hashmap.set ("bottom", dgettext ("plank", "Bottom"));

            var alignment_hashmap = new Gee.HashMap <string, string> ();
            alignment_hashmap.set ("fill", dgettext ("plank", "Fill"));
            alignment_hashmap.set ("start", dgettext ("plank", "Start"));
            alignment_hashmap.set ("end", dgettext ("plank", "End"));
            alignment_hashmap.set ("center", dgettext ("plank", "Center"));

            var item_alignment_hashmap = new Gee.HashMap <string, string> ();
            item_alignment_hashmap.set ("fill", dgettext ("plank", "Fill"));
            item_alignment_hashmap.set ("start", dgettext ("plank", "Start"));
            item_alignment_hashmap.set ("end", dgettext ("plank", "End"));
            item_alignment_hashmap.set ("center", dgettext ("plank", "Center"));

            //Appearance
            var appearance_label = new Widgets.Label (_("Appearance"));
            var theme = appearance.add_combo_box_text (_("Theme"), get_theme_list ());
            appearance.add_spin_button (_("Icon size"), icon_size);
            monitor = appearance.add_combo_box_text (_("Monitor"), get_monitor_list ());
            var screen_position = appearance.add_combo_box_text (_("Screen position"), screen_position_hashmap);
            var alignment = appearance.add_combo_box_text (_("Alignment"), alignment_hashmap);
            var item_alignment = appearance.add_combo_box_text (_("Item alignment"), alignment_hashmap);
            appearance.add_spin_button (_("Offset"), offset);

            grid.add (behabiour_label);
            grid.add (behabiour);
            grid.add (appearance_label);
            grid.add (appearance);
            grid.show_all ();

            settings.bind ("lock-items", lock_items, "active", SettingsBindFlags.DEFAULT);
            settings.bind ("pinned-only", show_unpinned, "active", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("current-workspace-only", current_workspace, "active", SettingsBindFlags.DEFAULT);
            settings.bind ("hide-mode", hide_mode, "active_id", SettingsBindFlags.DEFAULT);
            settings.bind ("hide-delay", hide_delay, "value", SettingsBindFlags.DEFAULT);

            settings.bind ("theme", theme, "active_id", SettingsBindFlags.DEFAULT);
            settings.bind ("icon-size", icon_size, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("monitor", monitor, "active_id", SettingsBindFlags.DEFAULT);
            settings.bind ("position", screen_position, "active_id", SettingsBindFlags.DEFAULT);
            settings.bind ("alignment", alignment, "active_id", SettingsBindFlags.DEFAULT);
            settings.bind ("items-alignment", item_alignment, "active_id", SettingsBindFlags.DEFAULT);
            settings.bind ("offset", offset, "value", SettingsBindFlags.DEFAULT);
        }

        // Modified https://github.com/ricotz/plank/blob/248cc4ae060775c187667e5ce192c3a8f1aff506/lib/Drawing/Theme.vala#L377-L417
		private Gee.HashMap<string, string> get_theme_list () {
			var list = new Gee.HashMap<string, string> ();
            list.set ("Default", "Default");
			list.set ("Gtk+", "Gtk+");

            // Look in user's themes-folder
			try {
                var path = File.new_for_path ("%s/plank/themes/".printf (Environment.get_user_data_dir ()));
				var enumerator = path.enumerate_children ("standard::name,standard::type",
					GLib.FileQueryInfoFlags.NONE);
				FileInfo info;
				while ((info = enumerator.next_file ()) != null) {
					if (info.get_is_hidden () || info.get_file_type () != GLib.FileType.DIRECTORY) {
                        continue;
                    }

					list.set (info.get_name (), info.get_name ());
				}
			} catch (Error e) {
                warning (e.message);
            }

			// Look in system's themes-folder
			try {
                var path = File.new_for_path ("/usr/share/plank/themes");
				var enumerator = path.enumerate_children ("standard::name,standard::type",
					GLib.FileQueryInfoFlags.NONE);
				FileInfo info;
				while ((info = enumerator.next_file ()) != null) {
					if (info.get_is_hidden () || info.get_file_type () != GLib.FileType.DIRECTORY) {
                        continue;
                    }

					list.set (info.get_name (), info.get_name ());
				}
			} catch (Error e) {
                warning (e.message);
            }

			return list;
		}

        private Gee.HashMap<string, string> get_monitor_list () {
            var monitor_list = new Gee.HashMap<string, string> ();
            int pos = 0;
            var display = Gdk.Display.get_default ();
            foreach (unowned string plug_name in get_monitor_plug_names (display)) {
                monitor_list.set (plug_name, plug_name);
                pos++;
            }

            return monitor_list;
        }

        public string[] get_monitor_plug_names (Gdk.Display display) {
            int n_monitors = display.get_n_monitors ();
            var result = new string[n_monitors];

            for (int i = 0; i < n_monitors; i++) {
                result[i] = display.get_monitor (i).get_model () ?? "PLUG_MONITOR_%i".printf (i);
            }

            return result;
        }
    }
}
