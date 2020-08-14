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

public class SimpleRep.SummaryView : Granite.Widgets.Welcome {

    private int64 deck_id;

    public SummaryView (SimpleRep.Deck deck, SimpleRep.Database db) {
        base (deck.name, subtitle_text (deck));

        deck_id = deck.id;

        append ("accessories-dictionary", "Study", description (deck));

        db.deck_updated.connect ((deck) => {
            if (deck.id != deck_id) {
                return;
            }

            subtitle = subtitle_text (deck);
            remove_item (0);
            append ("accessories-dictionary", "Study", description (deck));
            show_all ();
        });
    }

    private static string subtitle_text (SimpleRep.Deck deck) {
        return ngettext (
            "%d card in the deck.",
            "%d cards in the deck.",
            deck.cards_total
        ).printf (deck.cards_total);
    }

    private static string description (SimpleRep.Deck deck) {
        var new_text = ngettext (
            "%d new card.",
            "%d new cards.",
            deck.cards_new
        ).printf (deck.cards_new);

        var due_text = ngettext (
            "%d card due for review.",
            "%d cards due for review.",
            deck.cards_due
        ).printf (deck.cards_due);

        return @"$new_text $due_text";
    }
}
