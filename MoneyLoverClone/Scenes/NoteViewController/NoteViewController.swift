//
//  NoteViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class NoteViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var noteTextView: UITextView!
    
    // MARK: - Properties
    typealias Handler = (String) -> Void
    var sendNote: Handler?
    var note = ""
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.noteTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let note = noteTextView.text ?? ""
        sendNote?(note)
    }
    
    // MARK: - Views
    private func setupData() {
        navigationItem.title = "Ghi chú"
        noteTextView.do {
            $0.delegate = self
            $0.text = note
        }
    }
}

extension NoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        guard text == "\n" else {
            return true
        }
        navigationController?.popViewController(animated: true)
        return false
    }
}

extension NoteViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.note
}
