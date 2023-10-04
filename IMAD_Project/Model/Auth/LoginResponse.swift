//
//  KakaoAuth.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/06.
//

import Foundation

struct LoginResponse:Codable{
    
    var email:String
    var nickname:String?
    var gender:String?
    var ageRange:Int
    var profileImage:Int
    var tvGenre:[Int]?
    var movieGenre:[Int]?
    let authProvider:String
    let role:String
    
    
    enum CodingKeys:String,CodingKey{
        case email
        case nickname
        case authProvider = "auth_provider"
        case gender
        case ageRange = "age_range"
        case profileImage = "profile_image"
        case tvGenre = "preferred_tv_genres"
        case movieGenre = "preferred_movie_genres"
        case role
    }
}
