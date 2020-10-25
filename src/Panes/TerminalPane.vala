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
    public class Panes.TerminalPane : Categories.Pane {
        private Gtk.ColorButton background;
        private Gtk.FontButton font;
        private Gtk.Switch natural_copy_paste;
        private Gtk.Switch follow_last_tab;
        private Gtk.Switch unsafe_paste_alert;
        private Gtk.Switch rem_tabs;
        private Gtk.Switch term_bell;

        public TerminalPane () {
            base (_("Terminal"), "utilities-terminal");
        }

        construct {
            if (Util.schema_exists ("org.pantheon.terminal.settings") || Util.schema_exists ("io.elementary.terminal.settings")) {
                build_ui ();
                init_data ();
                connect_signals ();
            }
        }

        private void build_ui () {
            var box = new Widgets.SettingsBox ();

            background = new Gtk.ColorButton ();
            font = new Gtk.FontButton ();
            font.use_font = true;

            box.add_widget (_("Background color"), background);
            box.add_widget (_("Terminal Font"), font);
            natural_copy_paste = box.add_switch (_("Natural copy paste"));
            follow_last_tab = box.add_switch (_("Follow last tab"));
            unsafe_paste_alert = box.add_switch (_("Unsafe paste alert"));
            rem_tabs = box.add_switch (_("Remember tabs"));
            term_bell = box.add_switch (_("Terminal bell"));

            grid.add (box);

            grid.show_all ();
        }

        protected override void init_data () {
            var rgba = Gdk.RGBA ();
            rgba.parse (TerminalSettings.get_default ().background);
            background.use_alpha = true;
            background.rgba = rgba;
            font.font_name = TerminalSettings.get_default ().font;
            natural_copy_paste.set_state (TerminalSettings.get_default ().natural_copy_paste);
            follow_last_tab.set_state (TerminalSettings.get_default ().follow_last_tab);
            unsafe_paste_alert.set_state (TerminalSettings.get_default ().unsafe_paste_alert);
            rem_tabs.set_state (TerminalSettings.get_default ().remember_tabs);
            term_bell.set_state (TerminalSettings.get_default ().audible_bell);
        }

        private void connect_signals () {
            background.color_set.connect ( () => {
                TerminalSettings.get_default ().background = background.rgba.to_string ();
            });

            connect_font_button (font, (val) => { TerminalSettings.get_default ().font = val; });

            natural_copy_paste.notify["active"].connect (() => {
                TerminalSettings.get_default ().natural_copy_paste = natural_copy_paste.state;
            });

            follow_last_tab.notify["active"].connect (() => {
                TerminalSettings.get_default ().follow_last_tab = follow_last_tab.state;
            });

            unsafe_paste_alert.notify["active"].connect (() => {
                TerminalSettings.get_default ().unsafe_paste_alert = unsafe_paste_alert.state;
            });

            rem_tabs.notify["active"].connect (() => {
                TerminalSettings.get_default ().remember_tabs = rem_tabs.state;
            });

            term_bell.notify["active"].connect (() => {
                TerminalSettings.get_default ().audible_bell = term_bell.state;
            });

            connect_reset_button (() => {TerminalSettings.get_default ().reset();});
        }
    }
}
