//
//  TokenApitService.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/11/04.
//

import Foundation
import Alamofire

enum TokenApiService{
    
    static let intercept = GetTokenIntercept()
    
        static func getToken() {
            print("토큰 재발급 api 호출")
            ApiClient.shared.session
                .request(TokenRouter.token,interceptor: intercept)
                .response{UserDefaultManager.shared.checkToken(response: $0.response)}
        }
}
