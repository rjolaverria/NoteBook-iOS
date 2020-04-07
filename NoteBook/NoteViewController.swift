//
//  NoteViewController.swift
//  NoteBook
//
//  Created by Rafi Olaverria on 3/28/20.
//  Copyright © 2020 Rafi Olaverria. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    var note: Note!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note.content
    }
    
    // Save note when exit note
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        note.content = textView.text
        NoteManager.main.save(note: note)
        
    }
    
    // Delete Note
    @IBAction func deleteNote() {
        NoteManager.main.delete(note: note)
        navigationController?.popViewController(animated: true)
    }
}
