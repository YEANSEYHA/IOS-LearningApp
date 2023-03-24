//
//  TestView.swift
//  LearningApp
//
//  Created by Yean Seyha on 24/3/23.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        //Bug here when remove Text the Vstack is not display
            if model.currentQuestion != nil {
            
            VStack {
                // QUESTION number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                
                // Answers
                
                // Buttons
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        } else {
            // Test hasn't loaded yet
            ProgressView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
