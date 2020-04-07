//
//  Notes.swift
//  NoteBook
//
//  Created by Rafi Olaverria on 3/28/20.
//  Copyright © 2020 Rafi Olaverria. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var content: String
}

// Manages Notes Database for connecting and CRUD
class NoteManager {
    //Reference to Database
    var database: OpaquePointer!
    
    // Singleton Instance
    static let main = NoteManager()
    private init() {}
    
    // Connect to database
    func connect() {
        //Check if already connected
        if database != nil {
            return
        }
        do {
            // File to use and create if does not exists
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in:
            .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notebook.sqlite3")
            
            // Establish connection
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Could not connect")
                return
            }
            
            // Create table if not does exists in file
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (content Text)", nil, nil, nil) != SQLITE_OK {
                print("Could not create table")
                return
            }
        }
        catch let error {
            print("Database creation failed", error)
        }
    }
    
    // CREATE Note
    func create() -> Int {
        connect()
        
        // Prepare Query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT INTO notes ('content') VALUES ('New Note')", -1, &statement, nil) != SQLITE_OK {
            print("Could not create query")
            return -1
        }
        
        // Execute Query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not insert note")
            return -1
        }
        
        // Finalize and clean up
        sqlite3_finalize(statement)
        
        // Return id
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    // GET all notes
    func getNotes() -> [Note] {
        connect()
        var result: [Note] = []
        
        // Prepare Query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid, content FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Could get notes")
            return []
        }
        
        // Execute Query
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), content: String(cString: sqlite3_column_text(statement, 1))))
        }
        
        // Finalize and clean up
        sqlite3_finalize(statement)
        return result
    }
    
    // GET Note
    func getSingleNote (id: Int) -> Note {
        connect()
        var result: Note!
        
        // Prepare Query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid, content FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could get notes")
        }
        
        // Execute Query
        if sqlite3_step(statement) == SQLITE_ROW {
            result = Note(id: Int(sqlite3_column_int(statement, 0)), content: String(cString: sqlite3_column_text(statement, 1)))
        }

        
        // Finalize and clean up
        sqlite3_finalize(statement)
        return result
    }
    
    // SAVE note
    func save(note: Note) {
        connect()
        
        // Prepare Query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE notes SET content = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could not create update statement")
        }
        
        // Parameter binding
        sqlite3_bind_text(statement, 1, NSString(string: note.content).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        // Execute Query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating")
        }
        
        // Finalize and clean up
        sqlite3_finalize(statement)
        
    }
    
    // DELETE note
    func delete(note: Note) {
        connect()
        
        // Prepare Query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could not create update statement")
        }
        
        // Parameter binding
        sqlite3_bind_int(statement, 1, Int32(note.id))
        
        // Execute Query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error deleting")
        }
        
        // Finalize and clean up
        sqlite3_finalize(statement)
        
    }
}
