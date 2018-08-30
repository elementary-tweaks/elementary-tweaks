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
 */

namespace ElementaryTweaks {
    public class Categories : Gtk.ScrolledWindow {
        private Gtk.Stack stack;
        private Gtk.ListBox list_box;

        public Categories () {

        }

        construct {
            hscrollbar_policy = Gtk.PolicyType.NEVER;
            list_box = new Gtk.ListBox ();
            list_box.expand = true;
            set_size_request (176, 10);
            add (list_box);

            var appearance = new Panes.AppearancePane ();
            list_box.add (appearance);

            var fonts = new Panes.FontsPane ();
            list_box.add (fonts);

            var animations = new Panes.AnimationsPane ();
            list_box.add (animations);

            var misc = new Panes.MiscPane ();
            list_box.add (misc);

            var files = new Panes.FilesPane ();
            list_box.add (files);

            //var plank = new Panes.PlankPane ();
            //list_box.add (plank);

            var slingshot = new Panes.SlingshotPane ();
            list_box.add (slingshot);

            var terminal = new Panes.TerminalPane ();
            list_box.add (terminal);

            var audience = new Panes.AudiencePane ();
            list_box.add (audience);

            list_box.row_selected.connect ((row) => {
                if (row == null) return;
                var page = ((Pane) row);
                if (page.added == false) {
                    page.added = true;
                    stack.add (page.pane);
                }

                stack.set_visible_child (page.pane);
            });

            list_box.set_header_func ((row, before) => {
                if (row == appearance) {
                    row.set_header (new Header (_("General")));
                } else if (row == files) {
                    row.set_header (new Header (_("Applications")));
                }
            });
        }

        public void set_stack (Gtk.Stack stack) {
            this.stack = stack;
            weak Gtk.ListBoxRow first = list_box.get_row_at_index (0);
            list_box.select_row (first);
            first.activate ();
        }

        public abstract class Pane : Gtk.ListBoxRow {
            protected delegate void SetValue<T> (T val);
            protected delegate void Reset ();

            public Gtk.Label label;
            Gtk.Image image;
            public bool added = false;
            public Gtk.ScrolledWindow pane { public get; private set; }
            public Gtk.Grid grid { public get; private set; }
            public Widgets.SettingsBox settings_box { public get; private set; }
            protected Gtk.LinkButton reset;

            public Pane (string label_string, string icon_name) {
                label.label = label_string;
                image.icon_name = icon_name;
            }

            construct {
                var rowgrid = new Gtk.Grid ();
                pane = new Gtk.ScrolledWindow (null, null);
                rowgrid.orientation = Gtk.Orientation.HORIZONTAL;
                rowgrid.column_spacing = 6;
                rowgrid.margin = 3;
                rowgrid.margin_start = 12;
                add (rowgrid);

                label = new Gtk.Label (null);
                label.hexpand = true;
                label.halign = Gtk.Align.START;

                image = new Gtk.Image ();
                image.icon_size = Gtk.IconSize.DND;

                rowgrid.add (image);
                rowgrid.add (label);

                grid = new Gtk.Grid ();
                grid.orientation = Gtk.Orientation.VERTICAL;
                grid.margin = 12;
                grid.margin_top = 24;
                grid.row_spacing = 12;
                grid.column_spacing = 0;
                grid.expand = true;
                grid.show ();
                pane.add (grid);
                pane.show ();
            }

            protected void connect_combobox (Gtk.ComboBox box, Gtk.ListStore store, SetValue<string> set_func) {
                box.changed.connect (() => {
                    Value val;
                    Gtk.TreeIter iter;

                    box.get_active_iter (out iter);
                    store.get_value (iter, 1, out val);
                    set_func ((string) val);
                });
            }

            protected void connect_font_button (Gtk.FontButton button, SetValue<string> set_func) {
                button.font_set.connect (() => {
                    set_func (button.get_font_name ());
                });
            }

            protected void connect_spin_button (Gtk.SpinButton button, SetValue<int> set_func) {
                button.value_changed.connect (() => {
                    set_func (button.get_value_as_int ());
                });
            }

            protected void connect_reset_button (Reset reset_func, bool expand = true) {
                reset = new Gtk.LinkButton (_("Reset to default"));
                reset.can_focus = false;
                reset.set_vexpand (expand);
                reset.valign = Gtk.Align.END;
                reset.halign = Gtk.Align.END;

                reset.activate_link.connect (() => {
                    reset_func ();
                    init_data ();
                    return true;
                });

                grid.add (reset);
                grid.show_all ();
            }

            protected virtual void init_data () {}
        }

        public class Header : Gtk.Label {
            public Header (string header) {
                label = "%s".printf (GLib.Markup.escape_text (header));
                show_all ();
            }

            construct {
                halign = Gtk.Align.START;
                get_style_context ().add_class ("h4");
            }
        }
    }
}
