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

    public class TerminalSettings : Granite.Services.Settings {
        public string background { get; set; }
        public string cursor_color { get; set; }
        public string font { get; set; }
        public string foreground { get; set; }
        //public int opacity { get; set; }
        public string palette { get; set; }
        public int scrollback_lines { get; set; }
        public bool unsafe_paste_alert { get; set; }
        public bool natural_copy_paste { get; set; }
        public bool follow_last_tab { get; set; }
        public bool remember_tabs { get; set; }
        public string cursor_shape { get; set; }
                
        static TerminalSettings? instance = null;

        private TerminalSettings () {
            base ((Util.schema_exists ("io.elementary.terminal.settings"))?"io.elementary.terminal.settings":"org.pantheon.terminal.settings");
        }

        public static TerminalSettings get_default () {
            if (instance == null)
                instance = new TerminalSettings ();

            return instance;
        }

        public void reset () {
            string[] to_reset = {"background", "cursor-color", "font", "foreground", "palette",
                                 "scrollback-lines", "unsafe-paste-alert", "natural-copy-paste",
                                 "follow-last-tab", "cursor-shape", "remember-tabs"};

            foreach (string key in to_reset) {
                schema.reset (key);
            }
        }
    }
}
