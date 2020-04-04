/*
 * Copyright (C) Switchboard Accessibility Plug, 2016
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
    public class Widgets.SettingsBox : Gtk.Frame {
        private Gtk.ListBox list_box;
        private bool has_childen = false;

        public SettingsBox () {
            list_box = new Gtk.ListBox ();
            this.add (list_box);
        }

        public void add_widget (string title, Gtk.Widget widget) {
            var settings_box = new EmptyBox (title, has_childen);
            widget.set_margin_end (12);
            bind_sensitivity (widget, settings_box);

            settings_box.grid.add (widget);
            list_box.add (settings_box);
            show_all ();

            has_childen = true;
        }

        public Gtk.ComboBox add_combo_box (string title) {
            var combo = new Gtk.ComboBox ();
            combo.set_size_request (180, 0);
            add_widget (title, combo);

            var renderer = new Gtk.CellRendererText ();
            combo.pack_start (renderer, true);
            combo.add_attribute (renderer, "text", 0);

            return combo;
        }

        public Gtk.ComboBoxText add_combo_box_text (string title, Gee.HashMap<string, string> items) {
            var combo = new Gtk.ComboBoxText ();
            combo.set_size_request (180, 0);
            add_widget (title, combo);

            foreach (var item in items.entries) {
                combo.append (item.key, item.value);
            }

            return combo;
        }

        public Gtk.Scale add_scale (string title, Gtk.Adjustment adjustment) {
            var scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, adjustment);
            scale.set_size_request (250, 0);
            scale.set_draw_value (false);

            add_widget (title, scale);

            return scale;
        }

        public Gtk.Switch add_switch (string title) {
            var toggle = new Gtk.Switch ();

            add_widget (title, toggle);

            return toggle;
        }

        public Gtk.SpinButton add_spin_button (string title, Gtk.Adjustment adjustment) {
            var spinner = new Gtk.SpinButton (adjustment, 1, 0);
            spinner.set_size_request (150, 0);

            add_widget (title, spinner);

            return spinner;
        }

        private void bind_sensitivity (Gtk.Widget widget, EmptyBox settings_box ) {
            widget.bind_property ("sensitive", settings_box, "sensitive", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
        }

        protected class EmptyBox : Gtk.ListBoxRow {
            public Gtk.Grid grid;
            public Gtk.Label label;

            public EmptyBox (string title, bool add_separator) {
                set_activatable (false);
                set_selectable (false);

                var main_grid = new Gtk.Grid ();
                var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

                label = new Gtk.Label (title);
                label.hexpand = true;
                label.halign = Gtk.Align.START;
                label.margin = 8;

                grid = new Gtk.Grid ();
                grid.hexpand = true;
                grid.halign = Gtk.Align.END;
                grid.set_margin_end (4);
                grid.set_margin_top (8);
                grid.set_margin_bottom (8);

                if (add_separator) {
                    main_grid.attach (separator, 0, 0, 2, 1);
                }

                main_grid.attach (label, 0, 1, 1, 1);
                main_grid.attach (grid, 1, 1, 1, 1);
                add (main_grid);

                show_all ();
            }
        }
    }
}

