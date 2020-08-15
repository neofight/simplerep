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
    private SimpleRep.MainView main_view;
    private SimpleRep.ThrottledEvent resize_event = new SimpleRep.ThrottledEvent ();

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: _("Simple Rep")
        );

        instance = this;
        database = new SimpleRep.Database ();

        main_view = new SimpleRep.MainView (database);

        var header_bar = new SimpleRep.HeaderBar () {
            can_add_card = database.get_deck_count () > 0
        };
        database.deck_added.connect (() => { header_bar.can_add_card = true; });
        database.deck_removed.connect (() => { header_bar.can_add_card = (database.get_deck_count () > 0); });

        set_titlebar (header_bar);
        add (main_view);

        header_bar.add_deck_clicked.connect (main_view.add_deck);
        header_bar.add_card_clicked.connect (create_card);

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

    private void create_card () {
        var deck_id = main_view.selected_deck;

        var dialog = new SimpleRep.CreateCardDialog (this, deck_id);
        dialog.card_created.connect ((card) => {
            database.add_card (card);
        });

        dialog.show_all ();
        dialog.present ();
    }
}
