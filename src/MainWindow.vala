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

public class SimpleRep.MainWindow : Gtk.ApplicationWindow {

    private uint configure_id;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: _("Simple Rep")
        );

        var add_button = new Gtk.Button.from_icon_name ("folder-new");

        var header_bar = new Gtk.HeaderBar () {
            show_close_button = true,
            title = _("Simple Rep")
        };

        header_bar.pack_start (add_button);

        var welcome_screen = new Granite.Widgets.Welcome (
            _("Start Learning"),
            _("Create your first card deck.")
        );

        set_titlebar (header_bar);
        add (welcome_screen);
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        if (configure_id != 0) {
            GLib.Source.remove (configure_id);
        }

        configure_id = Timeout.add (100, () => {
            configure_id = 0;

            if (is_maximized) {
                SimpleRep.Application.settings.set_boolean ("window-maximized", true);
            } else {
                SimpleRep.Application.settings.set_boolean ("window-maximized", false);

                int x, y;
                get_position (out x, out y);
                SimpleRep.Application.settings.set ("window-position", "(ii)", x, y);

                Gdk.Rectangle rect;
                get_allocation (out rect);
                SimpleRep.Application.settings.set ("window-size", "(ii)", rect.width, rect.height);
            }

            return false;
        });

        return base.configure_event (event);
    }
}
