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

    public class IndicatorSoundSettings : Object {
        private static IndicatorSoundSettings? instance = null;
        private static Settings? settings = null;

        public double max_volume {
            get { return get_settings ().get_value ("max-volume").get_double (); }
            set { get_settings ().set_value ("max-volume", value);}
        }

        private IndicatorSoundSettings () {}

        public static IndicatorSoundSettings get_default () {
            if (instance == null) {
                instance = new IndicatorSoundSettings ();
            }

            return instance;
        }

        public static Settings get_settings () {
            if (settings == null) {
                settings = new Settings ("io.elementary.desktop.wingpanel.sound");
            }

            return settings;
        }

        public void reset () {
            get_settings ().reset ("max-volume");
        }
    }
}
