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

public class SimpleRep.BrowseView : Gtk.TreeView {

    private SimpleRep.Database db;
    private Gtk.ListStore list_store;

    public signal void edit_card_clicked (int64 card_id);

    public BrowseView (SimpleRep.Deck deck, SimpleRep.Database db) {
        this.db = db;
        list_store = new Gtk.ListStore (3, typeof (int64), typeof (string), typeof (string));

        var cards = db.get_cards (deck);
        set_model (list_store);

        Gtk.TreeIter iter;
        foreach (var card in cards) {
            list_store.append (out iter);
            list_store.set (iter, 0, (int64)card.id, 1, card.front, 2, card.back);
        }

        var cell_renderer = new Gtk.CellRendererText ();

        var front_column = new Gtk.TreeViewColumn.with_attributes ("Front", cell_renderer, "text", 1);
        front_column.expand = true;

        var back_column = new Gtk.TreeViewColumn.with_attributes ("Back", cell_renderer, "text", 2);
        back_column.expand = true;

        append_column (front_column);
        append_column (back_column);

        db.card_added.connect ((card) => {
            Gtk.TreeIter iter2;
            list_store.append (out iter2);
            list_store.set (iter2, 0, (int64)card.id, 1, card.front, 2, card.back);
        });

        db.card_removed.connect ((card_id) => {
            var iter2 = find_card (card_id);
            if (iter2 != null) {
                list_store.remove (ref iter2);
            }
        });

        db.card_saved.connect ((card) => {
            var iter2 = find_card (card.id);
            if (iter2 != null) {
                list_store.set_value (iter2, 1, card.front);
                list_store.set_value (iter2, 2, card.back);
            }
        });
    }

    public override bool button_press_event (Gdk.EventButton event) {
        if (event.triggers_context_menu ()) {
            Gtk.TreePath path;
            Gtk.TreeViewColumn column;
            int cell_x, cell_y;

            get_path_at_pos ((int) event.x, (int) event.y, out path, out column, out cell_x, out cell_y);

            if (path != null) {
                Gtk.TreeIter iter;
                Value val;

                list_store.get_iter (out iter, path);
                list_store.get_value (iter, 0, out val);

                var menu = get_context_menu (val.get_int64 ());
                menu.popup_at_pointer (event);
                return true;
            }
        }

        return base.button_press_event (event);
    }

    private Gtk.TreeIter? find_card (int64 card_id) {
        Gtk.TreeIter iter;
        Value val;

        if (!list_store.get_iter_first (out iter)) {
            return null;
        }

        do {
            list_store.get_value (iter, 0, out val);

            if (val.get_int64 () == card_id) {
                return iter;
            }
        } while (list_store.iter_next (ref iter));

        return null;
    }

    private Gtk.Menu get_context_menu (int64 card_id) {
        var edit_item = new Gtk.MenuItem.with_label (_("Edit"));
        edit_item.activate.connect (() => {
            edit_card_clicked (card_id);
        });

        var delete_item = new Gtk.MenuItem.with_label (_("Delete"));
        delete_item.activate.connect (() => {
            db.remove_card (card_id);
        });

        var menu = new Gtk.Menu ();
        menu.append (edit_item);
        menu.append (delete_item);
        menu.show_all ();
        return menu;
    }
}
