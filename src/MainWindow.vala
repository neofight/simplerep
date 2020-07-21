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

    private SimpleRep.ThrottledEvent resize_event = new SimpleRep.ThrottledEvent ();
    private Granite.Widgets.SourceList deck_list;
    private SimpleRep.ThrottledEvent position_event = new SimpleRep.ThrottledEvent ();

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

        deck_list = new Granite.Widgets.SourceList ();

        var welcome_screen = new Granite.Widgets.Welcome (
            _("Start Learning"),
            _("Create your first card deck.")
        );

        var stack = new Gtk.Stack ();

        stack.add (welcome_screen);

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.position = SimpleRep.Application.settings.get_int ("divider-position");
        paned.pack1 (deck_list, false, false);
        paned.pack2 (stack, true, false);

        set_titlebar (header_bar);
        add (paned);

        add_button.clicked.connect (create_new_deck);

        paned.notify["position"].connect (position_event.emit);
        position_event.emitted.connect (() => {
                SimpleRep.Application.settings.set_int ("divider-position", paned.position);
        });

        resize_event.emitted.connect (() => {
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
        });
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        resize_event.emit ();
        return base.configure_event (event);
    }

    private void create_new_deck () {
        var deck_icon = new GLib.ThemedIcon ("folder");

        var deck_item = new SimpleRep.DeckItem (deck_list, _("untitled")) {
            editable = true,
            icon = deck_icon,
            selectable = true
        };

        deck_list.root.add (deck_item);
        deck_list.start_editing_item (deck_item);
    }
}
