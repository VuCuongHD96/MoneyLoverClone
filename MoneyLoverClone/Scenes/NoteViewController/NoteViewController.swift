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
    @IBOutlet private weak var limitTextLabel: UILabel!
    
    // MARK: - Properties
    struct Constant {
        static let limitNoteCount = 50
    }
    typealias Handler = (String?) -> Void
    var sendNote: Handler?
    var note: String?
    
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
        let note = noteTextView.text
        sendNote?(note)
    }

    // MARK: - Data
    private func setupData() {
        navigationItem.title = "Ghi chú"
        noteTextView.do {
            $0.delegate = self
            $0.text = note
        }
        textViewDidChange(noteTextView)
    }
}

extension NoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            navigationController?.popViewController(animated: true)
        }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= Constant.limitNoteCount
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        limitTextLabel.text = String(text.count) + "/" + String(Constant.limitNoteCount)
    }
}

extension NoteViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.note
}
