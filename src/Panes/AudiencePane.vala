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
    public class Panes.AudiencePane : Categories.Pane {
        public Gtk.Switch stay_on_top;
        public Gtk.Switch move_window;
        public Gtk.Switch playback_wait;

        public AudiencePane () {
            base (_("Videos"), "multimedia-video-player");
        }

        construct {
            if (Util.schema_exists ("org.pantheon.audience") || Util.schema_exists("io.elementary.videos")) {
                build_ui ();
                init_data ();
                connect_signals ();
            }
        }

        private void build_ui () {
            var behaviour = new Widgets.SettingsBox ();

            stay_on_top = behaviour.add_switch (_("Stay on top while playing"));
            move_window = behaviour.add_switch (_("Move window from video canvas"));
            playback_wait = behaviour.add_switch (_("Don't instantly start video playback"));

            grid.add (behaviour);
            grid.show_all ();
        }

        protected override void init_data () {
            stay_on_top.set_state (AudienceSettings.get_default ().stay_on_top);
            move_window.set_state (AudienceSettings.get_default ().move_window);
            playback_wait.set_state (AudienceSettings.get_default ().playback_wait);
        }

        private void connect_signals () {
            stay_on_top.notify["active"].connect (() => {AudienceSettings.get_default ().stay_on_top = stay_on_top.state; });
            move_window.notify["active"].connect (() => {AudienceSettings.get_default ().move_window = move_window.state; });
            playback_wait.notify["active"].connect (() => {AudienceSettings.get_default ().playback_wait = playback_wait.state; });

            connect_reset_button (() => {
                AudienceSettings.get_default ().reset ();
            });
        }
    }
}
