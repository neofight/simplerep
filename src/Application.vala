/*
* Copyright (c) 2020 William Hoggarth
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: William Hoggarth <mail@whoggarth.org>
*/

public class SimpleRep.Application : Gtk.Application {

    public static GLib.Settings settings;

    static construct {
        settings = new GLib.Settings ("com.github.neofight.simplerep");
    }

    public Application () {
        Object (
            application_id: "com.github.neofight.simplerep",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new SimpleRep.MainWindow (this);

        bool maximized;
        int x, y;
        var rect = Gtk.Allocation ();

        maximized = settings.get_boolean ("window-maximized");
        settings.get ("window-position", "(ii)", out x, out y);
        settings.get ("window-size", "(ii)", out rect.width, out rect.height);

        if (x != -1 || y != -1) {
            main_window.move (x, y);
        }

        if (rect.width != -1 || rect.height != -1) {
            main_window.set_allocation (rect);
        }

        if (maximized) {
            main_window.maximize ();
        }

        main_window.show_all ();
    }

    public static int main (string[] args) {
        return new SimpleRep.Application ().run (args);
    }
}
