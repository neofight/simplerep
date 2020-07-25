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

    private static SimpleRep.MainWindow instance;

    private SimpleRep.Database database;
    private SimpleRep.ThrottledEvent resize_event = new SimpleRep.ThrottledEvent ();
    private SimpleRep.DeckList deck_list;
    private SimpleRep.ThrottledEvent position_event = new SimpleRep.ThrottledEvent ();
    private SimpleRep.DeckStack stack;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: _("Simple Rep")
        );

        instance = this;
        database = new SimpleRep.Database ();

        var add_button = new Gtk.Button.from_icon_name ("folder-new");

        var header_bar = new Gtk.HeaderBar () {
            show_close_button = true,
            title = _("Simple Rep")
        };

        header_bar.pack_start (add_button);

        deck_list = new SimpleRep.DeckList (database);
        stack = new SimpleRep.DeckStack (database.get_decks ());
        deck_list.item_renamed.connect ((deck) => { stack.update_deck (deck); });
        deck_list.item_selected.connect ((item) => { stack.show_deck (((SimpleRep.DeckItem)item).deck); });
        deck_list.root.child_added.connect ((item) => { stack.add_deck (((SimpleRep.DeckItem)item).deck); });
        deck_list.root.child_removed.connect ((item) => { stack.remove_deck (((SimpleRep.DeckItem)item).deck); });

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.position = SimpleRep.Application.settings.get_int ("divider-position");
        paned.pack1 (deck_list, false, false);
        paned.pack2 (stack, true, false);

        set_titlebar (header_bar);
        add (paned);

        add_button.clicked.connect (deck_list.add_deck);

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

    public static void panic (string message) {
        var dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Fatal Error"),
            message,
            "dialog-error");
        dialog.transient_for = instance;
        dialog.run ();
        dialog.destroy ();
        Process.exit (1);
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        resize_event.emit ();
        return base.configure_event (event);
    }
}
