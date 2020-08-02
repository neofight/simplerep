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

public class SimpleRep.HeaderBar : Gtk.HeaderBar {

    private Gtk.Button add_card_button;

    public signal void add_deck_clicked ();
    public signal void add_card_clicked ();

    public bool can_add_card {
        set {
            add_card_button.sensitive = value;
        }
    }

    public HeaderBar () {
        Object (
            show_close_button: true,
            title: _("Simple Rep")
        );

        var add_deck_button = new Gtk.Button.from_icon_name ("folder-new", Gtk.IconSize.LARGE_TOOLBAR);
        add_deck_button.valign = Gtk.Align.CENTER;

        add_card_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        add_card_button.valign = Gtk.Align.CENTER;
        add_card_button.sensitive = false;

        pack_start (add_deck_button);
        pack_start (add_card_button);

        add_deck_button.clicked.connect (() => add_deck_clicked ());
        add_card_button.clicked.connect (() => add_card_clicked ());
    }
}
