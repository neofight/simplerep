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

public class SimpleRep.MainView : Gtk.Box {

    private SimpleRep.Database database;
    private SimpleRep.DeckList deck_list;
    private SimpleRep.ThrottledEvent position_event = new SimpleRep.ThrottledEvent ();
    private SimpleRep.DeckStack stack;

    public int64 selected_deck {
        get {
            return ((SimpleRep.DeckItem)deck_list.selected).deck.id;
        }
    }

    public MainView (SimpleRep.Database database) {
        this.database = database;

        deck_list = new SimpleRep.DeckList (database);
        stack = new SimpleRep.DeckStack (database);
        deck_list.item_renamed.connect ((deck) => { stack.update_deck (deck); });
        deck_list.item_selected.connect ((item) => { stack.show_deck (((SimpleRep.DeckItem)item).deck); });
        deck_list.root.child_added.connect ((item) => { stack.add_deck (((SimpleRep.DeckItem)item).deck); });
        deck_list.root.child_removed.connect ((item) => { stack.remove_deck (((SimpleRep.DeckItem)item).deck); });

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.position = SimpleRep.Application.settings.get_int ("divider-position");
        paned.pack1 (deck_list, false, false);
        paned.pack2 (stack, true, false);

        paned.notify["position"].connect (position_event.emit);
        position_event.emitted.connect (() => {
            SimpleRep.Application.settings.set_int ("divider-position", paned.position);
        });

        add (paned);
    }

    public void add_deck () {
        deck_list.add_deck ();
    }
}
