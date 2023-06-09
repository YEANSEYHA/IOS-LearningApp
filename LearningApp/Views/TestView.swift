//
//  TestView.swift
//  LearningApp
//
//  Created by Yean Seyha on 24/3/23.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    @State var showResults = false
    
    var body: some View {
        //Bug here when remove Text the Vstack is not display
            if model.currentQuestion != nil && showResults == false {
            
                VStack(alignment: .leading) {
                // QUESTION number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                        .padding(.leading,20)
                        
                
                // Question
                CodeTextView()
                        .padding(.horizontal,20)
                
                // Answers
                    ScrollView {
                        VStack {
                            ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                                Button {
                                    // Track the selected index
                                    selectedAnswerIndex = index
                                    
                                } label: {
                                    ZStack {
                                        if submitted == false {
                                            RectangleCard(color: index == selectedAnswerIndex ? .gray: .white)
                                                .frame(height: 48)
                                        }else{
                                            // Answer has been submitted
                                            if index == selectedAnswerIndex &&
                                                index == model.currentQuestion!.correctIndex{
                                                RectangleCard(color: Color.green)
                                                    .frame(height: 48)
                                            }
                                            else if index == selectedAnswerIndex &&
                                                        index != model.currentQuestion!.correctIndex{
                                                // Show a red background
                                                RectangleCard(color: Color.red)
                                                    .frame(height: 48)
                                            }
                                            else if index == model.currentQuestion!.correctIndex {
                                                // This button is the correct answer
                                                // Show a green background
                                                RectangleCard(color: Color.green)
                                                    .frame(height: 48)
                                            }else{
                                                RectangleCard(color: Color.white)
                                                    .frame(height: 48)
                                            }
                                        }
                                        
                                        
                                        Text(model.currentQuestion!.answers[index])
                                        
                                    }
                                    
                                }
                                .disabled(submitted)
                                
                            }
                        }.padding()
                            .accentColor(.black)
                    }
                
                // Buttons
                    Button{
                        // check if answers has been submitted
                        if submitted == true {
                            
                            // check if it the last question
                            if model.currentQuestionIndex + 1 ==
                                model.currentModule!.test.questions.count {
                                showResults = true
                                
                            }else {
                                // answer has already been submitted, move to next question
                                model.nextQuestion()
                                // Reset properties
                                submitted = false
                                selectedAnswerIndex = nil
                            }
                            
                            
                            
                        }else {
                            // submit the answer
                            
                            // Change submitted state to true
                            submitted = true
                            
                            // Check the answer and increment the counter if correct
                            if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                                numCorrect += 1
                            }
                        }
                        
                    }label: {
                        ZStack{
                            RectangleCard(color: .green)
                                .frame(height: 48)
                            Text(buttonText)
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                                
                        }.padding()
                    }.disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
            else if showResults == true {
            // Test hasn't loaded yet
                TestResultView(numCorrect: numCorrect)
            } else {
                ProgressView()
            }
    }
    var buttonText: String {
        // check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                return "Finish" // or finish
            } else {
                return "Next"
            }
        }else {
            //There is a next question
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
