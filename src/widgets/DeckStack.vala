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

public class SimpleRep.DeckStack : Gtk.Stack {

    private int decks = 0;

    public DeckStack (Gee.Iterable<SimpleRep.Deck> decks) {
        foreach (var deck in decks) {
            add_deck (deck);
        }

        if (this.decks == 0) {
            add_welcome_screen ();
        }
    }

    public void add_deck (SimpleRep.Deck deck) {
        var welcome_screen = new SimpleRep.DeckView (deck);
        welcome_screen.show_all ();

        add_named (welcome_screen, deck.id.to_string ());
        decks++;

        remove_welcome_screen ();
    }

    public void remove_deck (SimpleRep.Deck deck) {
        var welcome_screen = get_child_by_name (deck.id.to_string ());
        remove (welcome_screen);
        decks--;

        if (decks == 0) {
            add_welcome_screen ();
        }
    }

    public void show_deck (SimpleRep.Deck deck) {
        visible_child_name = deck.id.to_string ();
    }

    public void update_deck (SimpleRep.Deck deck) {
        var welcome_screen = (SimpleRep.DeckView)get_child_by_name (deck.id.to_string ());
        welcome_screen.title = deck.name;
    }

    private void add_welcome_screen () {
        var welcome_screen = new Granite.Widgets.Welcome (
            _("Start Learning"),
            _("Create your first card deck.")
        );
        welcome_screen.show_all ();

        add_named (welcome_screen, "no_decks");
        visible_child_name = "no_decks";
    }

    private void remove_welcome_screen () {
        var welcome_screen = get_child_by_name ("no_decks");

        if (welcome_screen != null) {
            remove (welcome_screen);
        }
    }
}
