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

public class SimpleRep.DeckList : Granite.Widgets.SourceList {

    private SimpleRep.Database db;

    public DeckList (SimpleRep.Database db) {
        this.db = db;

        var decks = db.get_decks ();

        foreach (var deck in decks) {
            var deck_item = new SimpleRep.DeckItem (this, deck);
            deck_item.edited.connect (save_deck);

            root.add (deck_item);
        }
    }

    public void add_deck () {
        var deck = new SimpleRep.Deck () {
            name = _("untitled")
        };

        db.add_deck (deck);

        var deck_item = new SimpleRep.DeckItem (this, deck);
        deck_item.edited.connect (save_deck);

        root.add (deck_item);
        start_editing_item (deck_item);
    }

    public void remove_deck (SimpleRep.DeckItem deck_item) {
        db.remove_deck (deck_item.deck);

        root.remove (deck_item);
    }

    public void save_deck (Granite.Widgets.SourceList.Item item, string name) {
        if (name.strip () == "") {
            name = _("untitled");
        }

        var deck_item = (SimpleRep.DeckItem)item;
        deck_item.name = name;

        var deck = deck_item.deck;
        deck.name = name;
        db.save_deck (deck);
    }
}
