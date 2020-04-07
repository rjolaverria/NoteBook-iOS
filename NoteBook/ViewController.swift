//
//  ViewController.swift
//  NoteBook
//
//  Created by Rafi Olaverria on 3/28/20.
//  Copyright © 2020 Rafi Olaverria. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] = []
    var noteIndex: Int!
    
    // Load notes
       func load() {
           // Get all notes
           notes = NoteManager.main.getNotes()
           
           // Reload Table view
           self.tableView.reloadData()
       }
    
    // Add new note
    @IBAction func createNote() {
        noteIndex = NoteManager.main.create()
        load()
    }
    
    // Delete Note
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, completionHandler) in
            NoteManager.main.delete(note: self.notes[indexPath.row])
            self.load()
        })
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    // Load notes when scene appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    // Set section amount
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set row amount
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Map row cells to notes object
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].content
        return cell
    }
    
    // Segue to NotesViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue" {
            if let destination = segue.destination as? NoteViewController {
                destination.note = notes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}
