//
//  MyReviewView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/04/19.
//

import SwiftUI

struct MyReviewView: View {
    let title:String
    @Binding var back:Bool
    var body: some View {
        VStack(alignment: .leading){
            header
            List{
                ForEach(CustomData.instance.reviewList,id: \.self){ item in
                    CommunityListRowView(image: item.thumbnail, community: CustomData.instance.community, textColor: .black)
                }.listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            
        }
        .foregroundColor(.black)
        .background(Color.white)
    }
}

struct MyReviewView_Previews: PreviewProvider {
    static var previews: some View {
        MyReviewView(title: "리뷰", back: .constant(false))
    }
}

extension MyReviewView{
    var header:some View{
        ZStack{
            HStack{
                Button {
                    back = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .bold()
                        .padding()
                        
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .bold()
                        .padding()
                }

            }
            Text("내 " + title)
                .font(.title2)
                .bold()
        }
    }
}
