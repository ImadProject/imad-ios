//
//  AuthViewModel.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/06.
//

import Foundation
import Combine
import Alamofire
import AuthenticationServices


final class AuthViewModel:ObservableObject{
    
    
    @Published var selection:RegisterFilter = .nickname     //탭뷰
    @Published var check = (nickname:false,gender:false)
    @Published var patchUser:PatchUserInfo = PatchUserInfo(user: nil)
    @Published var user:UserResponse? = nil
    
    let userInfoInstance = UserInfoManager.instance
    var success = PassthroughSubject<(),Never>()
    var registerResultEvent = PassthroughSubject<(success:Bool,message:String),Never>()
    var loginSuccess = PassthroughSubject<String,Never>()
    var cancelable = Set<AnyCancellable>()
    
    init(user:UserResponse?){
        self.user = user
    }
    func register(email:String,password:String,authProvider:String){
        AuthApiService.register(email: email, password: password,authProvider:authProvider)
            .sink{ completion in
                print(completion)
            } receiveValue: { [weak self] noData in
                self?.registerResultEvent.send(((200..<300)~=noData.status ? true : false, noData.message))
            }.store(in: &cancelable)
    }
    func login(email:String,password:String){
        AuthApiService.login(email: email, password: password)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] user in
                self?.userInfoInstance.dataUpdate(data: user.data)
                self?.user = user.data
                self?.loginSuccess.send(user.message)
            }.store(in: &cancelable)
    }
    func getUser(){
        UserApiService.user()
            .sink { completion in
                ErrorManager.instance.actionErrorMessage(completion: completion, success: {}, failed: {self.logout(tokenExpired: true)})
            } receiveValue: { [weak self] user in
                self?.userInfoInstance.dataUpdate(data: user.data)
                self?.user = user.data
                self?.patchUser = PatchUserInfo(user: user.data)
            }.store(in: &cancelable)
    }
    func patchUserInfo(){
        UserApiService.patchUser(gender: patchUser.gender, birthYear: patchUser.age, nickname: patchUser.nickname, tvGenre: patchUser.tvGenre,movieGenre: patchUser.movieGenre)
            .sink { completion in
                ErrorManager.instance.actionErrorMessage(completion: completion, success: {}, failed: {self.logout(tokenExpired: true)})
            } receiveValue: { [weak self] user in
                self?.userInfoInstance.dataUpdate(data: user.data)
                self?.user = user.data
                self?.patchUser = PatchUserInfo(user: user.data)
            }.store(in: &cancelable)
    }
    func logout(tokenExpired:Bool){
        print("로그아웃 및 토큰 삭제")
        self.userInfoInstance.cache = nil
//        alertMessage = ""
//        user = nil
//        patchUser = PatchUserInfo(user: nil)
        selection = .nickname
        TokenManager.shared.clearAll()
    }
    func delete(authProvier:String){
        AuthApiService.delete(authProvier:authProvier)
            .sink { completion in
                ErrorManager.instance.actionErrorMessage(completion: completion, success: {}, failed: {self.logout(tokenExpired: true)})
            } receiveValue: { [weak self] noData in
//                self?.alertMessage = noData.message
            }.store(in: &cancelable)
    }
    func passwordChange(old:String,new:String){
        UserApiService.passwordChange(old: old, new: new)
            .sink { completion in
                ErrorManager.instance.actionErrorMessage(completion: completion, success: {}, failed: {self.logout(tokenExpired: true)})
            } receiveValue: { [weak self] noData in
//                self?.alertMessage = noData.message
            }.store(in: &cancelable)
    }
    func appleLogin(result: Result<ASAuthorization, any Error>){
        switch result {
        case .success(let authResults):
            switch authResults.credential{
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let state = appleIDCredential.state
                let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? ""
                let userIdentifier = appleIDCredential.user
                let authoriztaion = String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? ""
                AuthApiService.appleLogin(authorizationCode: authoriztaion, userIdentity: userIdentifier, state: state, idToken: IdentityToken){ saveTokenSuccess in
                    guard saveTokenSuccess else {return self.loginSuccess.send("로그인에 실패했습니다.")}
                    self.getUser()
                }
            default:  break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
        }
    }
    
}
