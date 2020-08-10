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

public class SimpleRep.CreateCardDialog : Gtk.Dialog {

    private Gtk.Entry front_entry;
    private Gtk.Entry back_entry;
    private Gtk.Button create_button;

    public signal void card_created (SimpleRep.Card card);

    public CreateCardDialog (Gtk.Window parent, int64 deck_id) {
        Object (
            transient_for: parent,
            width_request: 450
        );

        var front_label = new Gtk.Label (_("Front"));
        front_entry = new Gtk.Entry ();
        front_entry.changed.connect (() => validate ());

        var back_label = new Gtk.Label (_("Back"));
        back_entry = new Gtk.Entry ();
        back_entry.changed.connect (() => validate ());

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        box.margin = 12;
        box.margin_top = 0;
        box.add (front_label);
        box.add (front_entry);
        box.add (back_label);
        box.add (back_entry);

        var content_area = get_content_area ();
        content_area.add (box);

        add_button (_("Close"), Gtk.ResponseType.CLOSE);

        create_button = (Gtk.Button)add_button (_("Create"), Gtk.ResponseType.OK);
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        create_button.sensitive = false;

        response.connect ((response_id) => {
            if (response_id == Gtk.ResponseType.OK) {
                var card = new SimpleRep.Card () {
                    deck_id = deck_id,
                    front = front_entry.text.strip (),
                    back = back_entry.text.strip ()
                };

                card_created (card);
            }

            destroy ();
        });
    }

    private void validate () {
        create_button.sensitive = front_entry.text.strip ().length > 0 && back_entry.text.strip ().length > 0;
    }
}
