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

    private Granite.Widgets.Welcome summary;

    public string title {
        set {
            summary.title = value;
        }
    }

    public DeckView (Deck deck) {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0
        );

        summary = new Granite.Widgets.Welcome (
            deck.name,
            _("Create your first card.")
        );

        var study = new Granite.Widgets.Welcome (
            _("Nothing to study"),
            _("Create your first card.")
        );

        var browse = new Granite.Widgets.Welcome (
            _("Nothing to browse"),
            _("Create your first card.")
        );

        var stack = new Gtk.Stack ();
        stack.add_titled (summary, "summary", "Summary");
        stack.add_titled (study, "study", "Study");
        stack.add_titled (browse, "browse", "Browse");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.stack = stack;
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.margin = 12;

        add(stack_switcher);
        add(stack);
    }
}
