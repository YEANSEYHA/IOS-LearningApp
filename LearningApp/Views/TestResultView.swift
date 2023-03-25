//
//  TestResultView.swift
//  LearningApp
//
//  Created by Yean Seyha on 25/3/23.
//

import SwiftUI

struct TestResultView: View {
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Doing great !")
                .font(.title)
            Spacer()
            Text("You got X out of X qurestions")
            Spacer()
            Button{
                // send the
                model.currentTestSelected = nil
            }label:{
                ZStack{
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }.padding()
        }
    }
}

struct TestResultView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultView()
    }
}
