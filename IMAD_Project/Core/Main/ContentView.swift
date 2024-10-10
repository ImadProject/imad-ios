//
//  ContentView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/03/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch") //온보딩
    @State var flashOn = true
    @StateObject var vm = AuthViewModel(user:nil)
    
    var body: some View {
        ZStack {
            if flashOn{
                SplashView(off: $flashOn)
            }else{
                if isFirstLaunch{
                    if let user = vm.user{
                        if user.role == "GUEST"{
                            RegisterTabView()
                        }else{
                            MenuTabView()
                        }
                    }else{
                        LoginAllView()
                    }
                }else{
                    OnBoardingTabView(isFirstLaunch: $isFirstLaunch)
                }
            }
        }
        .onAppear{
            vm.getUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ContentView()
        }
    }
}
