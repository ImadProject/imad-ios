//
//  ProfileImageView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/11/06.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    var work:Int?
    let imagePath:String
    let widthHeigt:CGFloat
    var body: some View {
        KFImage(URL(string: work != nil ? imagePath.getImadImage():imagePath.getImageURL()))
            .resizable()
            .placeholder{
                Circle()
                    .foregroundColor(.gray.opacity(0.1))
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
            }
            .scaledToFill()
            .frame(width: widthHeigt,height: widthHeigt)
            .clipShape(Circle())
            .background{
                if imagePath.contains("default_profile_image"){
                    Circle()
                        .foregroundColor(.white)
                        .shadow(color:ProfileImageColorCategory.allCases.first(where: {$0.num == imagePath.getImageCode()})?.color ?? .clear,radius: 1)
                }
            }
    }
   
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(work: 1, imagePath: CustomData.profileImage,widthHeigt: 30)
    }
}
