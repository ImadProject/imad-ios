//
//  WorkInfo.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/08/18.
//

import Foundation

struct WorkInfo:Codable{
    
    let genres: [Int]
    let productionCountries: [String]?
    let contentsId: Int?
    let tmdbId:Int
    let tagline:String
    let overview, posterPath, originalLanguage: String?
    let certification, contentsType: String?
    let title, originalTitle, releaseDate: String?
    let runtime: Int?
    let status, name, originalName, firstAirDate: String?
    let lastAirDate: String?
    let reviewCnt:Int
    let imageScore:Double?
    let numberOfEpisodes, numberOfSeasons: Int?
    let seasons:[Season]?
    let networks:[Network]?
    let credits:Credit?
    
    enum CodingKeys: String, CodingKey {
        case genres
        case productionCountries = "production_countries"
        case contentsId = "contents_id"
        case tmdbId = "tmdb_id"
        case overview, tagline
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case certification
        case contentsType = "contents_type"
        case title
        case imageScore = "imad_score"
        case reviewCnt = "review_cnt"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case runtime, status, name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case seasons,networks,credits
    }
}


