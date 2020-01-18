/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
 *
 * Some code taken from from Gala (https://launchpad.net/gala)
 * Copyright (C) 2012 GardenGnome, Rico Tzschichholz, Tom Beckmann, Michael Langfermann
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

    const string SCHEMA = "org.pantheon.desktop.gala";

    public class BehaviorSettings : Granite.Services.Settings {
        public bool edge_tiling { get; set; }
        public string panel_main_menu_action { get; set; }
        public string toggle_recording_action { get; set; }

        public int hotcorner_topleft { get; set; }
        public int hotcorner_topright { get; set; }
        public int hotcorner_bottomleft { get; set; }
        public int hotcorner_bottomright { get; set; }

        public string hotcorner_custom_command { get; set; }

        static BehaviorSettings? instance = null;

        private BehaviorSettings () {
            base (SCHEMA + ".behavior");
        }

        public static BehaviorSettings get_default () {
            if (instance == null) {
                instance = new BehaviorSettings ();
            }

            return instance;
        }
    }

    public class AppearanceSettings : Granite.Services.Settings {
        public string button_layout { get; set; }
        public bool attach_modal_dialogs { get; set; }
        public bool dim_parents { get; set; }

        static Gee.HashMap<string, string> preset_button_layouts;
        static Gtk.ListStore button_layouts;
        static AppearanceSettings? instance = null;
        private GLib.Settings gnome_wm_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        private AppearanceSettings () {
            base (SCHEMA + ".appearance");

            changed.connect (() => {
                gnome_wm_settings.set_string ("button-layout", button_layout);
            });
        }

        public static AppearanceSettings get_default () {
            if (instance == null) {
                instance = new AppearanceSettings ();
            }

            return instance;
        }

        public void reset () {
            schema.reset ("button-layout");
            gnome_wm_settings.reset ("button-layout");
        }

        private static Gee.HashMap<string, string> get_preset_button_layouts () {
            if (preset_button_layouts == null) {
                preset_button_layouts = new Gee.HashMap<string, string> ();
                preset_button_layouts["close:maximize"] = _("elementary");
                preset_button_layouts[":close"] = _("Close Only Right");
                preset_button_layouts["close:"] = _("Close Only Left");
                preset_button_layouts["close,minimize:maximize"] = _("Minimize Left");
                preset_button_layouts["close:minimize,maximize"] = _("Minimize Right");
                preset_button_layouts[":minimize,maximize,close"] = _("Windows");
                preset_button_layouts["close,minimize,maximize"] = _("OS X");
                preset_button_layouts["close,maximize,minimize"] = _("Ubuntu");
            }

            return preset_button_layouts;
        }

        public static Gtk.ListStore get_button_layouts (out int active_index) {
            if (button_layouts == null) {
                button_layouts = new Gtk.ListStore(2, typeof (string), typeof (string));
                Gtk.TreeIter iter;

                int index = 0;
                active_index = 0;

                var layouts = get_preset_button_layouts ();

                foreach (var layout in layouts.entries) {
                    debug ("Adding button layout: %s => %s", layout.key, layout.value);
                    button_layouts.append (out iter);
                    button_layouts.set (iter, 0, layout.value, 1, layout.key);
                    if (AppearanceSettings.get_default ().button_layout == layout.key) {
                        active_index = index;
                    }

                    index++;
                }
            } else {
                active_index = 1;
            }

            return button_layouts;
        }
    }

    public class ShadowSettings : Granite.Services.Settings {
        public string[] menu { get; set; }
        public string[] normal_focused { get; set; }
        public string[] normal_unfocused { get; set; }
        public string[] dialog_focused { get; set; }
        public string[] dialog_unfocused { get; set; }

        static ShadowSettings? instance = null;

        private ShadowSettings () {
            base (SCHEMA + ".shadows");
        }

        public static ShadowSettings get_default () {
            if (instance == null) {
                instance = new ShadowSettings ();
            }

            return instance;
        }
    }

    public class AnimationSettings : Granite.Services.Settings {
        public bool enable_animations { get; set; }
        public int open_duration { get; set; }
        public int snap_duration { get; set; }
        public int minimize_duration { get; set; }
        public int close_duration { get; set; }
        public int workspace_switch_duration { get; set; }

        static AnimationSettings? instance = null;

        private AnimationSettings () {
            base (SCHEMA + ".animations");
        }

        public static AnimationSettings get_default () {
            if (instance == null) {
                instance = new AnimationSettings ();
            }

            return instance;
        }

        public void reset () {
            schema.reset ("enable-animations");
            schema.reset ("open-duration");
            schema.reset ("snap-duration");
            schema.reset ("minimize-duration");
            schema.reset ("close-duration");
            schema.reset ("workspace-switch-duration");
        }
    }
}
