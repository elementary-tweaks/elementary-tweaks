/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
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

    public class FilesSettings : Granite.Services.Settings {
        public string date_format { get; set; }
        public string sidebar_zoom_level { get; set; }
        public bool single_click { get; set; }
        public bool restore_tabs { get; set; }

        static FilesSettings? instance = null;

        private FilesSettings () {
            base ((Util.schema_exists ("io.elementary.files.preferences"))?"io.elementary.files.preferences":"org.pantheon.files.preferences");
        }

        public static FilesSettings get_default () {
            if (instance == null)
                instance = new FilesSettings ();

            return instance;
        }

        public static Gtk.ListStore get_date_formats (out int active_index) {
            var date_layouts = new Gtk.ListStore(2, typeof (string), typeof (string));
            Gtk.TreeIter iter;

            int index = 0;
            active_index = 0;

            var date_format_map = new Gee.HashMap<string, string> ();
            date_format_map.set ("locale", _("Locale"));
            date_format_map.set ("iso", _("ISO"));
            date_format_map.set ("informal", _("Informal"));

            foreach (var layout in date_format_map.entries) {
                debug ("Adding button layout: %s => %s", layout.key, layout.value);
                date_layouts.append (out iter);
                date_layouts.set (iter, 0, layout.value, 1, layout.key);
                if (FilesSettings.get_default ().date_format == layout.key) {
                    active_index = index;
                }

                index++;
            }

            return date_layouts;
        }

        public void reset () {
            schema.reset ("date-format");
            schema.reset ("single-click");
            schema.reset ("restore-tabs");
        }
    }
}
