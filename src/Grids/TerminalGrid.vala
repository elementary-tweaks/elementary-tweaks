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

    /**
     * A set of settings for the terminal that sets how it looks
     */
    public class TerminalTheme
    {
        public string name;
        public string cursor;
        public string foreground;
        public string background;
        public string palette;

        private static Gee.Map<string, TerminalTheme> defaults = null;

        /**
         * Constructs a new terminal theme
         */
        public TerminalTheme (string _name, string _cursor, string fg, string bg, string _palette)
        {
            name = _name;
            cursor = _cursor;
            foreground = fg;
            background = bg;
            palette = _palette;
        }

        /**
         * Applies this theme to the terminal.
         */
        public void apply_theme () {
            var settings = TerminalSettings.get_default ();

            settings.cursor_color = cursor;
            settings.foreground = foreground;
            settings.background = background;
            settings.palette = palette;
        }

        /**
         * Gets the applied theme from the settings.
         */
        public static TerminalTheme get_applied_theme () {
            var settings = TerminalSettings.get_default ();

            string _cursor = settings.cursor_color;
            string _foreground = settings.foreground;
            string _background = settings.background;
            string _palette = settings.palette;

            var default_themes = get_default_themes ();

            // check to see if the theme is in the default themes
            foreach (TerminalTheme theme in default_themes.values) {
                if (_cursor == theme.cursor &&
                        _foreground == theme.foreground &&
                        _background == theme.background &&
                        _palette == settings.palette) {
                    // found it
                    return theme;
                }
            }

            // it isn't a default theme, it's custom
            return new TerminalTheme (_("Custom"), _cursor, _foreground, _background, _palette);
        }

        /**
         * Get all of the default themes
         */
        public static Gee.Map<string, TerminalTheme> get_default_themes () {
            if (defaults == null) {
                defaults = new Gee.HashMap<string, TerminalTheme> ();
                defaults.set ("Default",
                        new TerminalTheme (
                            "Default",
                            "#839496",
                            "#94a3a5",
                            "#252e32",
                            "#073642:#dc322f:#859900:#b58900:#268bd2:#ec0048:#2aa198:#94a3a5:#586e75:#cb4b16:#859900:#b58900:#268bd2:#d33682:#2aa198:#6c71c4"
                            ));
                defaults.set ("Chalk",
                        new TerminalTheme (
                            "Chalk",
                            "#d0d0d0",
                            "#d0d0d0",
                            "#151515",
                            "#151515:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#d0d0d0:#505050:#eda987:#202020:#303030:#b0b0b0:#e0e0e0:#deaf8f:#f5f5f5"
                            ));
                defaults.set ("Monokai",
                        new TerminalTheme (
                            "Monokai",
                            "#f8f8f2",
                            "#f8f8f2",
                            "#272822",
                            "#272822:#f92672:#a6e22e:#f4bf75:#66d9ef:#ae81ff:#a1efe4:#f8f8f2:#75715e:#fd971f:#383830:#49483e:#a59f85:#f5f4f1:#cc6633:#f9f8f5"
                            ));
                defaults.set ("Solarized",
                        new TerminalTheme (
                            "Solarized",
                            "#93a1a1",
                            "#93a1a1",
                            "#002b36",
                            "#002b36:#dc322f:#859900:#b58900:#268bd2:#6c71c4:#2aa198:#93a1a1:#657b83:#cb4b16:#073642:#586e75:#839496:#eee8d5:#d33682:#fdf6e3"
                            ));
                defaults.set ("Zenburn",
                        new TerminalTheme (
                            "Zenburn",
                            "#8f8faf",
                            "#dcdcdc",
                            "#1f1f1f",
                            "#3f3f3f:#e8e893:#9e9ece:#f0f0df:#8c8cd0:#c0c0be:#dfdfaf:#efefef:#3f3f3f:#e8e893:#9e9ece:#f0f0df:#8c8cd0:#c0c0be:#dfdfaf:#efefef"
                            ));
            }

            return defaults;
        }
    }

    public class TerminalGrid : Gtk.Grid
    {
        public TerminalGrid ()
        {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // Terminal Opacity tweak
            var opacity = new TweakWidget.with_spin_button (
                        _("Opacity:"),
                        _("How transparent the background of the terminal is"),
                        null,
                        (() => { return TerminalSettings.get_default ().opacity ; }), // get
                        ((val) => { TerminalSettings.get_default ().opacity = val; }), // set
                        (() => { TerminalSettings.get_default ().schema.reset ("opacity"); }), // reset
                        0, 100, 1
                    );
            this.add (opacity);

            // Terminal Theme
            var default_themes = TerminalTheme.get_default_themes ();
            var theme_map = new Gee.HashMap<string, string> ();
            foreach (string theme_name in default_themes.keys) {
                theme_map.set (theme_name, theme_name);
            }
            //theme_map.set (_("Custom"), _("Custom"));

            var theme = new TweakWidget.with_combo_box (
                        _("Theme:"), // name
                        _("A set of settings for terminal palette and background color"), // tooltip
                        null, // warning
                        (() => { return TerminalTheme.get_applied_theme ().name; }), // get
                        ((val) => {
                                TerminalTheme.get_default_themes ()[val].apply_theme ();
                            }), // set
                        (() => {
                                TerminalSettings.get_default ().schema.reset ("background");
                                TerminalSettings.get_default ().schema.reset ("foreground");
                                TerminalSettings.get_default ().schema.reset ("cursor-color");
                                TerminalSettings.get_default ().schema.reset ("palette");
                            }), // reset
                        theme_map
                    );
            this.add (theme);

            var unsafe_paste_alert_switch = new TweakWidget.with_switch (
                        _("Unsafe alert:"),
                        _("If the user paste's a command into the terminal that might be considered unsafe, when them"),
                        null,
                        (() => { return TerminalSettings.get_default ().unsafe_paste_alert; }), // get
                        ((val) => {
                                TerminalSettings.get_default ().unsafe_paste_alert = val;
                            }), // set
                        (() => { TerminalSettings.get_default ().schema.reset ("unsafe-paste-alert"); }) // reset
                    );
            this.add (unsafe_paste_alert_switch);
            
            var natural_copy_paste_switch = new TweakWidget.with_switch (
                        _("Natural copy paste:"),
                        _("Defined whether to use ctrl-c or ctrl-shift-c for copy"),
                        null,
                        (() => { return TerminalSettings.get_default ().natural_copy_paste; }), // get
                        ((val) => {
                                TerminalSettings.get_default ().natural_copy_paste = val;
                            }), // set
                        (() => { TerminalSettings.get_default ().schema.reset ("natural-copy-paste"); }) // reset
                    );
            this.add (natural_copy_paste_switch);
            
            var follow_last_tab = new TweakWidget.with_switch (
                        _("Follow last tab:"),
                        _("If the user opens a new tab either take the current workdirectory of the previous tab or the default one."),
                        null,
                        (() => { return TerminalSettings.get_default ().follow_last_tab; }), // get
                        ((val) => {
                                TerminalSettings.get_default ().follow_last_tab = val;
                            }), // set
                        (() => { TerminalSettings.get_default ().schema.reset ("follow-last-tab"); }) // reset
                    );
            this.add (follow_last_tab);
            
            var cursor_map = new Gee.HashMap<string, string> ();
            cursor_map.set ("Block", _("Block"));
            cursor_map.set ("I-Beam", _("I-Beam"));
            cursor_map.set ("Underline", _("Underline"));
            var cursor_shape_combox = new TweakWidget.with_combo_box (
                        _("Cursor shape:"), // name
                        _("The shape of the cursor of the terminal"), // tooltip
                        null, // warning
                        (() => { return TerminalSettings.get_default ().cursor_shape; }), // get
                        ((val) => {
                                 TerminalSettings.get_default ().cursor_shape = val;
                            }), // set
                        (() => {
                                TerminalSettings.get_default ().schema.reset ("cursor-shape");
                            }), // reset
                        cursor_map
                    );
            this.add (cursor_shape_combox);
            /*
            // scrollback
            var limit_scrollback = new Gtk.Switch ();
            limit_scrollback.halign = Gtk.Align.START;
            limit_scrollback.active = TerminalSettings.get_default ().scrollback_lines >= 0;
            var scrollback = new Gtk.SpinButton.with_range (0, 99999999999, 100);
            scrollback.width_request = 160;
            scrollback.halign = Gtk.Align.START;
            scrollback.value = limit_scrollback.active ? TerminalSettings.get_default ().scrollback_lines : 0;
            scrollback.sensitive = limit_scrollback.active;
            limit_scrollback.notify["active"].connect (() => {
                    TerminalSettings.get_default ().scrollback_lines = limit_scrollback.active ? (int)scrollback.value : -1;
                    scrollback.sensitive = limit_scrollback.active;
                    });
            scrollback.changed.connect (() => {
                    if (limit_scrollback.active)
                    TerminalSettings.get_default ().scrollback_lines = (int)scrollback.value;
                    });


            // custom font
            var custom_font = new Gtk.Switch ();
            custom_font.halign = Gtk.Align.START;
            custom_font.active = TerminalSettings.get_default ().font != "";
            var font = new Gtk.FontButton ();
            font.set_font (TerminalSettings.get_default ().font == "" ?
                    InterfaceSettings.get_default ().monospace_font_name :
                    TerminalSettings.get_default ().font );
            font.sensitive = custom_font.active;
            font.width_request = 160;
            font.halign = Gtk.Align.START;
            font.font_set.connect (() => {
                    TerminalSettings.get_default ().font = font.get_font_desc ().to_string ();
                    });
            custom_font.notify["active"].connect (() => {
                    TerminalSettings.get_default ().font = custom_font.active ? font.get_font_desc ().to_string () : "";
                    font.sensitive = custom_font.active;
                    });

            var opacity = new Gtk.SpinButton.with_range ( 0, 100, 1);
            var opacity_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            opacity.width_request = 160;
            opacity.halign = Gtk.Align.START;
            opacity.set_value (TerminalSettings.get_default ().opacity);
            opacity.value_changed.connect (() => {
                    TerminalSettings.get_default ().opacity = (int)opacity.get_value ();
                    });

            var opacity_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

            opacity_default.clicked.connect (() => {
                    TerminalSettings.get_default ().schema.reset ("opacity");
                    opacity.set_value (TerminalSettings.get_default ().opacity);
                    });

            opacity_default.halign = Gtk.Align.START;

            opacity_box.pack_start (opacity, false);
            opacity_box.pack_start (opacity_default, false);

            var themes = new Gtk.ComboBoxText ();
            var themes_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            themes.width_request = 160;
            themes.halign = Gtk.Align.START;
            TerminalTheme[] custom_themes = {};
            var active = -1;
            int i = 0;
            for (; i < DEFAULT_THEMES.length; i++) {
                var theme = DEFAULT_THEMES[i];
                if (theme.palette == TerminalSettings.get_default ().palette)
                    active = i;
                themes.append (i.to_string (), theme.name);
            }

            var themes_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

            themes_default.clicked.connect (() => {
                    TerminalSettings.get_default ().schema.reset ("palette");
                    TerminalSettings.get_default ().schema.reset ("background");
                    TerminalSettings.get_default ().schema.reset ("foreground");
                    TerminalSettings.get_default ().schema.reset ("cursor-color");
                    themes.active = 0;
                    });

            themes_default.halign = Gtk.Align.START;

            themes_box.pack_start (themes, false);
            themes_box.pack_start (themes_default, false);

            var custom_themes_file = File.new_for_path (Environment.get_user_data_dir () + "/pantheon-terminal/themes");
            if (custom_themes_file.query_exists ()) {
                try {
                    var it = custom_themes_file.enumerate_children (FileAttribute.STANDARD_NAME, 0, null);
                    FileInfo info;
                    while ((info = it.next_file ()) != null) {
                        string data;
                        FileUtils.get_contents (custom_themes_file.get_path () + "/" + info.get_name (), out data);
                        var parts = data.split ("\n");
                        custom_themes += TerminalTheme (info.get_name (), parts[0], parts[1], parts[2], parts[3]);
                        i++;
                        themes.append (i.to_string (), info.get_name ());
                    }
                } catch (Error e) { warning (e.message); }
            }

            themes.append ("-1", _("Custom"));
            themes.active_id = active.to_string ();
            themes.changed.connect (() => {
                    TerminalTheme theme;
                    var index = int.parse (themes.active_id);
                    if (index == -1)
                    return;

                    if (index < DEFAULT_THEMES.length)
                    theme = DEFAULT_THEMES[index];
                    else
                    theme = custom_themes[index - DEFAULT_THEMES.length - 1];

                    TerminalSettings.get_default ().cursor_color = theme.cursor;
                    TerminalSettings.get_default ().foreground = theme.foreground;
                    TerminalSettings.get_default ().background = theme.background;
                    TerminalSettings.get_default ().palette = theme.palette;
                    });

            attach (new LLabel.right (_("Limit Scrollback Lines:")), 0, 0, 1, 1);
            attach (limit_scrollback, 1, 0, 1, 1);
            attach (scrollback, 1, 1, 1, 1);

            attach (new LLabel.right (_("Custom Font:")), 0, 2, 1, 1);
            attach (custom_font, 1, 2, 1, 1);
            attach (font, 1, 3, 1, 1);

            attach (new LLabel.right (_("Opacity:")), 0, 4, 1, 1);
            attach (opacity_box, 1, 4, 1, 1);

            attach (new LLabel.right (_("Theme:")), 0, 5, 1, 1);
            attach (themes_box, 1, 5, 1, 1);
            */
        }
    }
}
