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

public class SimpleRep.DeckView : Gtk.Box {

    private SimpleRep.Database db;
    private Granite.Widgets.Welcome summary;

    public string title {
        set {
            summary.title = value;
        }
    }

    public DeckView (Deck deck, Database db) {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0
        );

        this.db = db;

        summary = new SimpleRep.SummaryView (deck, db);

        var browse = new SimpleRep.BrowseView (deck, db);
        browse.edit_card_clicked.connect (edit_card);

        var stack = new Gtk.Stack ();
        stack.add_titled (summary, "summary", "Summary");
        stack.add_titled (browse, "browse", "Browse");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.stack = stack;
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.margin = 12;

        add (stack_switcher);
        add (stack);
    }

    private void edit_card (int64 card_id) {
        var card = db.get_card (card_id);

        var dialog = new SimpleRep.EditCardDialog ((Gtk.Window)get_toplevel (), card);
        dialog.card_edited.connect ((card) => {
            db.save_card (card);
        });

        dialog.show_all ();
        dialog.present ();
    }
}
