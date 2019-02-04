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
        private Gtk.Switch current_workspace;
        private Gtk.Switch show_unpinned;
        private Gtk.Switch lock_items;

        private Gtk.Adjustment icon_size = new Gtk.Adjustment (0,0,1000,1,10,10);
        private Gtk.Adjustment hide_delay = new Gtk.Adjustment (0,0,1000,1,10,10);
        private Gtk.Adjustment offset = new Gtk.Adjustment (0,0,1000,1,10,10);

        private Gtk.ComboBox hide_mode;
        private Gtk.ComboBox theme;
        private Gtk.ComboBox monitor;
        private Gtk.ComboBox screen_position;
        private Gtk.ComboBox alignment;
        private Gtk.ComboBox item_alignment;

        public PlankPane () {
            base (_("Dock"), "plank");
        }

        construct {
            build_ui ();
            connect_signals ();
        }

        private void build_ui () {
            var behabiour = new Widgets.SettingsBox ();
            var appearance = new Widgets.SettingsBox ();

            //Behavior
            var behabiour_label = new Widgets.Label (_("Behavior"));
            lock_items = behabiour.add_switch (_("Lock items"));
            show_unpinned = behabiour.add_switch (_("Show Unpinned"));
            current_workspace =behabiour.add_switch (_("Restrict to Workspace"));
            hide_mode = behabiour.add_combo_box (_("Hide mode"));
            behabiour.add_spin_button (_("Hide delay"), hide_delay);

            //Appearance
            var appearance_label = new Widgets.Label (_("Appearance"));
            theme = appearance.add_combo_box (_("Theme"));
            appearance.add_spin_button (_("Icon size"), icon_size);
            monitor = appearance.add_combo_box (_("Monitor"));
            screen_position = appearance.add_combo_box (_("Screen position"));
            alignment = appearance.add_combo_box (_("Alignment"));
            item_alignment = appearance.add_combo_box (_("Item alignment"));
            appearance.add_spin_button (_("Offset"), offset);

            grid.add (behabiour_label);
            grid.add (behabiour);
            grid.add (appearance_label);
            grid.add (appearance);
            grid.show_all ();
        }

        protected override void init_data () {}

        private void connect_signals () {

        }
    }
}
