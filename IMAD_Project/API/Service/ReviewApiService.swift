//
//  ReviewApiService.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/09/12.
//

import Foundation
import Combine
import Alamofire

enum ReviewApiService{
    
    static var intercept = BaseIntercept()
    
    static func reviewWrite(id:Int,title:String,content:String,score:Double,spoiler:Bool) -> AnyPublisher<NetworkResponse<CreateReviewResponse>,AFError>{
        print("리뷰작성 api호출")
        return ApiClient.shared.session
            .request(ReviewRouter.write(id: id, title: title, content: content, score: score, spoiler: spoiler),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type:NetworkResponse<CreateReviewResponse>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func reviewRead(id:Int) -> AnyPublisher<NetworkResponse<ReviewResponse>,AFError>{
        print("리뷰조회 api호출")
        return ApiClient.shared.session
            .request(ReviewRouter.read(id: id),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type:NetworkResponse<ReviewResponse>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func reviewUpdate(id:Int,title:String,content:String,score:Double,spoiler:Bool) -> AnyPublisher<NetworkResponse<Int?>,AFError>{
        print("리뷰수정 api호출")
        return ApiClient.shared.session
            .request(ReviewRouter.update(id: id, title: title, content: content, score: score, spoiler: spoiler),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<Int?>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func reviewDelete(id:Int) -> AnyPublisher<NetworkResponse<Int>,AFError>{
        print("리뷰삭제 api호출")
        return ApiClient.shared.session
            .request(ReviewRouter.delete(id: id),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<Int>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func reviewReadList(id:Int,page:Int,sort:String,order:Int) -> AnyPublisher<NetworkResponse<NetworkListResponse<ReviewResponse>>,AFError>{
        print("리뷰리스트 조회 api 호출")
        return ApiClient.shared.session
            .request(ReviewRouter.readList(id: id, page: page, sort: sort, order: order),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<NetworkListResponse<ReviewResponse>>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func reviewLike(id:Int,status:Int) -> AnyPublisher<NetworkResponse<Int>,AFError>{
        print("리뷰 좋아요/싫어요 api 호출")
        return ApiClient.shared.session
            .request(ReviewRouter.like(id: id, status: status),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<Int>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func myReview(page:Int) -> AnyPublisher<NetworkResponse<NetworkListResponse<ReviewResponse>>,AFError>{
        print("내 리뷰 리스트 api 호출")
        return ApiClient.shared.session
            .request(ReviewRouter.myReview(page: page),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<NetworkListResponse<ReviewResponse>>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func myLikeReview(page:Int,likeStatus:Int) -> AnyPublisher<NetworkResponse<NetworkListResponse<ReviewResponse>>,AFError>{
        print("내 좋아요/싫어요 리뷰 리스트 api 호출")
        return ApiClient.shared.session
            .request(ReviewRouter.myLikeReview(page: page,likeStatus:likeStatus),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<NetworkListResponse<ReviewResponse>>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
}
