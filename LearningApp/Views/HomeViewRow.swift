//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Yean Seyha on 22/3/23.
//

import SwiftUI

struct HomeViewRow: View {
    var image: String
    var title: String
    var description: String
    var count : String
    var time: String

    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175),contentMode: .fit)
                .frame(width: 335,height: 175)
            
            HStack{
                //Image
                Image(image)
                    .resizable()
                    .frame(width: 116,height: 116)
                    .clipShape(Circle())
                Spacer()
                // Text
                VStack(alignment: .leading,spacing: 10){
                    Text(title)
                        .bold()
                    Text(description)
                        .padding(.bottom,20)
                        .font(Font.system(size:12))
                    
                    // Icons section
                    HStack{
                        // Number of lessons/questions
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15,height: 15)
                        Text(count)
                            .font(.caption)
                        Spacer()
                        //Time
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15,height: 15)
                        Text(time)
                            .font(.caption)
                        Spacer()
                            
                    }
                }
            }.padding(.leading,20)
        }.padding(.horizontal,20)

    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(
            image: "swift",
            title: "Learn Swift",
            description: "Some description",
            count: "10 Lessons",
            time: "2 hours"
        )
    }
}
