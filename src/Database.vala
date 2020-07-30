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

public class SimpleRep.Database {

    private Sqlite.Database db;

    public Database () {
        var data_path = Path.build_filename (Environment.get_user_data_dir (), "com.github.neofight.simplerep");

        var directory = File.new_for_path (data_path);
        if (!directory.query_exists ()) {
            try {
                directory.make_directory_with_parents ();
            } catch (Error e) {
                SimpleRep.MainWindow.panic ("Unable to open database: " + e.message);
            }
        }

        var db_path = Path.build_filename (data_path, "database.db");

        var result = Sqlite.Database.open_v2 (db_path, out db);

        if (result != Sqlite.OK) {
            SimpleRep.MainWindow.panic ("Unable to open database: " + db.errmsg ());
        }

        init ();
    }

    public void add_deck (SimpleRep.Deck deck) {
        const string SQL = "INSERT INTO decks (name) VALUES (?);";

        var stmt = prepare (SQL);
        stmt.bind_text (1, deck.name);

        var result = stmt.step ();

        if (result != Sqlite.DONE) {
            SimpleRep.MainWindow.panic ("Unable to add deck to database: " + db.errmsg ());
        }

        deck.id = db.last_insert_rowid ();
    }

    public Gee.ArrayList<SimpleRep.Deck> get_decks () {
        const string SQL = "SELECT id, name FROM decks;";

        var stmt = prepare (SQL);

        Gee.ArrayList<SimpleRep.Deck> decks = new Gee.ArrayList<SimpleRep.Deck> ();

        while (true) {
            var result = stmt.step ();
            if (result == Sqlite.DONE) {
                break;
            } else if (result != Sqlite.ROW) {
                SimpleRep.MainWindow.panic ("Error fetching deck record");
            }

            decks.add (new SimpleRep.Deck () {
                id = stmt.column_int (0),
                name = stmt.column_text (1)
            });
        }

        return decks;
    }

    public void remove_deck (SimpleRep.Deck deck) {
        const string SQL = "DELETE FROM decks WHERE id = ?;";

        var stmt = prepare (SQL);
        stmt.bind_int64 (1, deck.id);

        var result = stmt.step ();

        if (result != Sqlite.DONE) {
            SimpleRep.MainWindow.panic ("Unable to remove deck from database: " + db.errmsg ());
        }
    }

    public void save_deck (SimpleRep.Deck deck) {
        const string SQL = "UPDATE decks SET name = ? WHERE id = ?;";

        var stmt = prepare (SQL);
        stmt.bind_text (1, deck.name);
        stmt.bind_int64 (2, deck.id);

        var result = stmt.step ();

        if (result != Sqlite.DONE) {
            SimpleRep.MainWindow.panic ("Unable to save deck to database: " + db.errmsg ());
        }
    }

    private void init () {
        const string SQL = """
            CREATE TABLE IF NOT EXISTS Decks (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL
            );""";

        var stmt = prepare (SQL);

        var result = stmt.step ();

        if (result != Sqlite.DONE) {
            SimpleRep.MainWindow.panic ("Unable to initialise database: " + db.errmsg ());
        }
    }

    private Sqlite.Statement prepare (string sql) {
        Sqlite.Statement stmt;

        var result = db.prepare_v2 (sql, -1, out stmt, null);

        if (result != Sqlite.OK) {
            SimpleRep.MainWindow.panic ("A database error occured: " + db.errmsg ());
        }

        return stmt;
    }
}