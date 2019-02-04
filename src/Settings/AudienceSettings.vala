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

    public class AudienceSettings : Granite.Services.Settings {
        public bool move_window { get; set; }
        public bool stay_on_top { get; set; }
        public bool playback_wait { get; set; }

        static AudienceSettings? instance = null;

        private AudienceSettings () {
            base ((Util.schema_exists ("io.elementary.videos"))?"io.elementary.videos":"org.pantheon.audience");
        }

        public static AudienceSettings get_default () {
            if (instance == null) {
                instance = new AudienceSettings ();
            }

            return instance;
        }

        public void reset () {
            string[] to_reset = {"move-window", "stay-on-top", "playback-wait"};

            foreach (string key in to_reset) {
                schema.reset (key);
            }
        }
    }
}
