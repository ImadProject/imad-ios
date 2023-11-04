//
//  AuthApiService.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

enum AuthApiService{
    
    static let intercept = BaseIntercept()
    
    static func login(email:String,password:String) -> AnyPublisher<GetUserInfo,AFError>{
        print("로그인 api 호출")
        return ApiClient.shared.session
            .request(AuthRouter.login(email: email, password: password))
            .response{ response in
                
                var accessToken = ""
                var refreshToken = ""
                
                if let access = response.response?.allHeaderFields["Authorization"] as? String{
                    accessToken = access
                }
                if let refresh = response.response?.allHeaderFields["Authorization-refresh"] as? String{
                    refreshToken = refresh
                }else if let refresh = response.response?.allHeaderFields["authorization-refresh"] as? String{
                    refreshToken = refresh
                }
//                if !accessToken.isEmpty,!refreshToken.isEmpty{
                UserDefaultManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
//                }
            }
            .publishDecodable(type: GetUserInfo.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func register(email:String,password:String,authProvider:String) -> AnyPublisher<RegisterResponse,AFError>{
        print("회원가입 api 호출")
        
        return ApiClient.shared.session
            .request(AuthRouter.register(email: email, password: password,authProvider:authProvider))
            .response{ response in
                if let accessToken = response.response?.allHeaderFields["Authorization"] as? String,let refreshToken = response.response?.allHeaderFields["Authorization-refresh"] as? String{
                    UserDefaultManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
                }
            }
            .publishDecodable(type: RegisterResponse.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message ?? "")")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func delete(authProvier:String) -> AnyPublisher<GetUserInfo,AFError>{
        print("회원탈퇴 api 호출")
        return ApiClient.shared.session
            .request(authProvier != "IMAD" ? AuthRouter.oauthDelete(authProvider:authProvier) : AuthRouter.delete,interceptor: intercept)
            .publishDecodable(type: GetUserInfo.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
        
    }
//    static func getToken() {
//        let intercept = GetTokenIntercept()
//        print("토큰 재발급 api 호출")
//        ApiClient.shared.session
//            .request(AuthRouter.token,interceptor: intercept)
//            .response{ response in
//
//                var accessToken = ""
//                var refreshToken = ""
//
//                print("--------요청----------")
//                print(response.request?.allHTTPHeaderFields as Any)
//                print("--------응답----------")
//                print(response.response?.allHeaderFields as Any)
//
//                print("--------받은 토큰----------")
//                if let access = response.response?.allHeaderFields["Authorization"] as? String{
//                    accessToken = access
//                }
//                if let refresh = response.response?.allHeaderFields["Authorization-refresh"] as? String{
//                    refreshToken = refresh
//                }else if let refresh = response.response?.allHeaderFields["authorization-refresh"] as? String{
//                    refreshToken = refresh
//                }
//                UserDefaultManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
//
//                print(accessToken)
//                print(refreshToken)
//            }
//    }
    
}

