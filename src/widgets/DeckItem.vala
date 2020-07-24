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

public class SimpleRep.DeckItem : Granite.Widgets.SourceList.Item {

    private SimpleRep.DeckList deck_list;

    public SimpleRep.Deck deck;

    public DeckItem (SimpleRep.DeckList deck_list, SimpleRep.Deck deck) {
        var deck_icon = new GLib.ThemedIcon ("folder");

        Object (
            name: deck.name,
            editable: true,
            icon: deck_icon,
            selectable: true
        );

        this.deck_list = deck_list;
        this.deck = deck;
    }

    public override Gtk.Menu? get_context_menu () {
        var rename_item = new Gtk.MenuItem.with_label (_("Rename"));
        rename_item.activate.connect (() => {
            deck_list.start_editing_item (this);
        });

        var delete_item = new Gtk.MenuItem.with_label (_("Delete"));
        delete_item.activate.connect (() => {
            deck_list.remove_deck (this);
        });

        var menu = new Gtk.Menu ();
        menu.append (rename_item);
        menu.append (delete_item);
        menu.show_all ();
        return menu;
    }
}
