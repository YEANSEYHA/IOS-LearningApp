//
//  CodeTextView.swift
//  LearningApp
//
//  Created by Yean Seyha on 22/3/23.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    @EnvironmentObject var model: ContentModel
    
    
    func makeUIView(context: Context) -> UITextView {
        let textview = UITextView()
        textview.isEditable = false
        return textview
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        // set the attributed text for the lesson
        textView.attributedText = model.codeText
        // scroll back to the top
        textView.scrollRectToVisible(CGRect(x:0,y:0,width: 1,height: 1), animated: false)
        
    }
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
