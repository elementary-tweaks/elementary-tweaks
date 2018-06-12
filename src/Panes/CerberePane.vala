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
    public class Panes.CerberePane : Categories.Pane {
        private AppsBox box;

        public CerberePane () {
            base (_("Cerbere"), "preferences-tweaks-cerbere");
        }

        construct {
            if (Util.schema_exists ("io.elementary.desktop.cerbere")) {
                build_ui ();
                connect_signals ();
            }
        }

        private void build_ui () {
            box = new AppsBox ();

            grid.add (box);
            grid.show_all ();
        }

        protected override void init_data () {}

        private void connect_signals () {
            connect_reset_button (()=> {
                box.reset ();
            }, false);
        }
    }

    public class AppsBox : Gtk.Grid {
        private List<AppEntry> entries;

        private Gtk.ListBox list_box;
        private AppChooser apps_popover;
        private Gtk.Button remove_button;

        protected class AppEntry : Gtk.ListBoxRow {
            public signal void deleted ();

            private AppInfo info;
            private string executable;

            private Gtk.Image image;
            private Gtk.Label label;

            public AppEntry.from_command (string command, string icon_name) {
                this (AppInfo.create_from_commandline (command, null, AppInfoCreateFlags.NONE));

                executable = command;

                string markup = Util.create_markup (command, _("Custom command"));
                label.set_text (markup);
                label.use_markup = true;

                image.set_from_icon_name (icon_name, Gtk.IconSize.DND);
            }

            public AppEntry (AppInfo info) {
                this.info = info;
                executable = info.get_executable ();

                var main_grid = new Gtk.Grid ();
                main_grid.orientation = Gtk.Orientation.HORIZONTAL;

                main_grid.margin = 6;
                main_grid.margin_start = 12;
                main_grid.column_spacing = 12;

                if (executable != "wingpanel") {
                    var icon = info.get_icon ();
                    image = new Gtk.Image.from_gicon (icon, Gtk.IconSize.LARGE_TOOLBAR);
                    image.pixel_size = 32;
                } else {
                    image = new Gtk.Image.from_icon_name ("preferences-tweaks-slingshot", Gtk.IconSize.DND);
                }

                main_grid.add (image);

                string? description = info.get_description ();
                if (description == null) {
                    description = "";
                }

                string markup = Util.create_markup (info.get_display_name (), description);
                label = new Gtk.Label (markup);
                label.expand = true;
                label.use_markup = true;
                label.halign = Gtk.Align.START;
                label.ellipsize = Pango.EllipsizeMode.END;
                main_grid.add (label);

                add (main_grid);
            }

            public AppInfo get_info () {
                return info;
            }

            public string get_executable () {
                return executable;
            }
        }

        public AppsBox () {
            entries = new List<AppEntry> ();

            column_spacing = 12;
            row_spacing = 12;

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.hexpand = scrolled.vexpand = true;

            var header_label = new Gtk.Label (_("Keep these applications open:"));
            header_label.margin_start = 12;
            header_label.margin_top = 6;
            header_label.halign = Gtk.Align.START;
            header_label.get_style_context ().add_class ("h4");

            list_box = new Gtk.ListBox ();
            list_box.row_selected.connect (on_changed);
            scrolled.add (list_box);

            var add_button = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.MENU);
            add_button.tooltip_text = _("Add watched app…");
            add_button.clicked.connect (on_add_button_clicked);

            remove_button = new Gtk.Button.from_icon_name ("list-remove-symbolic", Gtk.IconSize.MENU);
            remove_button.tooltip_text = _("Remove selected app");
            remove_button.sensitive = false;
            remove_button.clicked.connect (on_remove_button_clicked);

            apps_popover = new AppChooser (add_button);
            apps_popover.app_chosen.connect (load_info);
            apps_popover.command_added.connect (load_command);

            var toolbar = new Gtk.ActionBar ();
            toolbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
            toolbar.add (add_button);
            toolbar.add (remove_button);

            var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            main_box.add (header_label);
            main_box.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            main_box.add (scrolled);
            main_box.add (toolbar);

            var frame = new Gtk.Frame (null);
            frame.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            frame.add (main_box);

            attach (frame, 0, 0, 2, 1);

            load_existing ();
            show_all ();
        }

        private void on_add_button_clicked () {
            apps_popover.show_all ();
        }

        private void on_remove_button_clicked () {
            var entry = (AppEntry) list_box.get_selected_row ();
            entry.deleted ();
        }

        public void reset () {
            var childs = list_box.get_children ();
            foreach (var child in childs) {
                var entry = (AppEntry) child;
                entry.deleted ();
            }

            CerbereSettings.get_default ().reset ();

            load_existing ();
        }

        private void load_info (AppInfo info) {
            if (!get_info_loaded (info)) {
                var row = new AppEntry (info);
                row.deleted.connect (on_deleted);

                entries.append (row);
                list_box.add (row);
                list_box.show_all ();
                on_changed ();
            }
        }

        private void load_command (string command) {
                var row = new AppEntry.from_command (command, "application-x-executable");
                row.deleted.connect (on_deleted);

                entries.append (row);
                list_box.add (row);
                list_box.show_all ();
                on_changed ();
        }

        private bool get_info_loaded (AppInfo info) {
            foreach (var entry in entries) {
                if (entry.get_info () == info) {
                    return true;
                }
            }

            return false;
        }

        private void on_deleted (AppEntry row) {
            entries.remove (row);
            row.destroy ();
            on_changed ();
        }

        private void on_changed () {
            remove_button.sensitive = (list_box.get_selected_row () != null);

            string[] _targets = {};
            foreach (var entry in entries) {
                _targets += entry.get_executable ();
            }

            CerbereSettings.get_default ().monitored_processes = _targets;
        }

        private void load_existing () {
            string[] _targets = CerbereSettings.get_default ().monitored_processes;
            Array<string> added = new Array<string>();

            foreach (var info in AppInfo.get_all ()) {
                if (info.get_executable () in _targets) {
                    load_info (info);
                    added.append_val (info.get_executable ());
                }
            }

            foreach (string target in _targets) {
                if (!(target in added.data)) {
                    load_command (target);
                }
            }
        }
    }

    public class AppChooser : Gtk.Popover {
        protected class AppRow : Gtk.Box {
            public AppInfo info;

            public AppRow (AppInfo info) {
                this.info = info;

                orientation = Gtk.Orientation.HORIZONTAL;
                margin = 6;
                spacing = 12;

                var image = new Gtk.Image.from_gicon (info.get_icon (), Gtk.IconSize.LARGE_TOOLBAR);
                image.pixel_size = 32;
                add (image);

                string? description = info.get_description ();
                if (description == null) {
                    description = "";
                }

                string markup = Util.create_markup (info.get_display_name (), description);
                var label = new Gtk.Label (markup);
                label.use_markup = true;
                label.halign = Gtk.Align.START;
                label.ellipsize = Pango.EllipsizeMode.END;
                add (label);

                show_all ();
            }
        }

        private Gtk.ListBox listbox;
        private Gtk.SearchEntry search_entry;
        private Gtk.Entry custom_entry;

        public signal void app_chosen (AppInfo info);
        public signal void command_added (string command);

        public AppChooser (Gtk.Widget widget) {
            Object (relative_to: widget);
            modal = true;

            var grid = new Gtk.Grid ();
            grid.margin = 12;
            grid.row_spacing = 6;

            search_entry = new Gtk.SearchEntry ();
            search_entry.placeholder_text = _("Search Applications");
            search_entry.search_changed.connect (apply_filter);

            custom_entry = new Gtk.Entry ();
            custom_entry.placeholder_text = _("Custom command");
            custom_entry.primary_icon_name = "document-properties-symbolic";

            custom_entry.activate.connect (() => {
                command_added (custom_entry.get_text ());
                hide ();
            });

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.height_request = 200;
            scrolled.width_request = 250;
            scrolled.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            scrolled.shadow_type = Gtk.ShadowType.IN;

            listbox = new Gtk.ListBox ();
            listbox.expand = true;
            listbox.height_request = 250;
            listbox.width_request = 200;
            listbox.set_sort_func (sort_function);
            apply_filter ();
            scrolled.add (listbox);

            listbox.row_activated.connect (on_app_selected);

            grid.attach (search_entry, 0, 0, 1, 1);
            grid.attach (scrolled, 0, 1, 1, 1);
            grid.attach (custom_entry, 0, 2, 1, 1);

            add (grid);
            grid.show_all ();

            init_list ();
        }

        private void init_list () {
            foreach (var _info in AppInfo.get_all ()) {
                if (_info.should_show ()) {
                    var row = new AppRow (_info);
                    listbox.prepend (row);
                }
            }
        }

        private int sort_function (Gtk.ListBoxRow first_row, Gtk.ListBoxRow second_row) {
            var row_1 = (AppRow)first_row.get_child ();
            var row_2 = (AppRow)second_row.get_child ();

            string name_1 = row_1.info.get_display_name ();
            string name_2 = row_2.info.get_display_name ();

            return name_1.collate (name_2);
        }

        private bool filter_function (Gtk.ListBoxRow row) {
            var app_row = (AppRow)row.get_child ();
            return search_entry.text.down () in app_row.info.get_display_name ().down ()
                || search_entry.text.down () in app_row.info.get_description ().down ();
        }

        private void on_app_selected (Gtk.ListBoxRow row) {
            var app_row = (AppRow)row.get_child ();
            app_chosen (app_row.info);
            hide ();
        }

        private void apply_filter () {
            listbox.set_filter_func (filter_function);
        }
    }
}
