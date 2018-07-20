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

    public class CerbereSettings : Granite.Services.Settings
    {
        public uint crash_time_interval { get; set; }
        public uint max_crashes { get; set; }
        public string[] monitored_processes { get; set; }

        static CerbereSettings? instance = null;

        private CerbereSettings () {
            base ("io.elementary.desktop.cerbere");
        }

        public static CerbereSettings get_default () {
            if (instance == null)
                instance = new CerbereSettings ();

            return instance;
        }

        public void reset () {
            schema.reset ("monitored-processes");
        }
    }
}
