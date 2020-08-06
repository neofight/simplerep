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
   
    public BrowseView (SimpleRep.Deck deck, SimpleRep.Database db) {
        var list_store = new Gtk.ListStore (2, typeof (string), typeof (string));

        var cards = db.get_cards (deck);
        set_model (list_store);

        Gtk.TreeIter iter;
        foreach (var card in cards) {
            list_store.append (out iter);
            list_store.set (iter, 0, card.front, 1, card.back);
        }

        var cell_renderer = new Gtk.CellRendererText ();

        var front_column = new Gtk.TreeViewColumn.with_attributes ("Front", cell_renderer, "text", 0);
        front_column.expand = true;

        var back_column = new Gtk.TreeViewColumn.with_attributes ("Back", cell_renderer, "text", 1);
        back_column.expand = true;

        append_column (front_column);
        append_column (back_column);

        db.card_added.connect ((card) => {
            Gtk.TreeIter iter2;
            list_store.append (out iter2);
            list_store.set (iter2, 0, card.front, 1, card.back);
        });
    }
}
