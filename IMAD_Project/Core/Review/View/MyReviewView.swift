//
//  MyReviewView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/04/19.
//

import SwiftUI

struct MyReviewView: View {
    let mode:Int
    @State var like = true
    
    @State var tokenExpired = (false,"")
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:ReviewViewModel
    
    var profileMode:(){
        switch mode{
        case 0:
            return vm.myReviewList(page: vm.currentPage)
        case 1:
            return vm.myLikeReviewList(page: vm.currentPage)
        default:
            return ()
        }
    }
    var list:[ReadReviewResponse]{
        switch mode{
        case 0:
            return vm.myReview
        case 1:
            return vm.myLikeReview
        default:
            return []
        }
    }
    
    var body: some View {
        VStack{
            header
            item
        }
        .foregroundColor(.black)
        .background(Color.white)
        .onAppear{
            vm.myReview = []
            vm.myLikeReview = []
            profileMode
        }
        .onReceive(vm.tokenExpired) { messages in
            tokenExpired = (true,messages)
        }
//        .alert(isPresented: $tokenExpired.0) {
//            Alert(title: Text("토큰 만료됨"),message: Text(tokenExpired.1),dismissButton:.cancel(Text("확인")){
//                vmAuth.loginMode = false
//            })
//        }
    }
}

struct MyReviewView_Previews: PreviewProvider {
    static var previews: some View {
        MyReviewView(mode: 0)
            .environmentObject(ReviewViewModel(reviewList: CustomData.instance.reviewDetail))
    }
}

extension MyReviewView{
    var header:some View{
        VStack{
            ZStack{
                HStack{
                    Button {
                       dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .bold()
                            .padding()
                            
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .bold()
                            .padding()
                    }
                }
                Text(mode == 0 ? "내 리뷰" : "내 반응")
                    .font(.title3)
                    .bold()
            }
            if mode == 1{
                HStack{
                    Group{
                        Button {
                            withAnimation {
                                like = true
                            }
                        } label: {
                            HStack{
                                Image(systemName: "heart.fill")
                                Text("좋아요")
                            }.foregroundColor(.red)
                        }.overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: UIScreen.main.bounds.width/2,height: 2)
                                .offset(y:20)
                                .foregroundColor(like ? .red : .clear)
                        }
                        Button {
                            withAnimation {
                                like = false
                            }
                        } label: {
                            HStack{
                                Image(systemName: "heart.slash.fill")
                                Text("싫어요")
                            }.foregroundColor(.blue)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: UIScreen.main.bounds.width/2,height: 2)
                                .offset(y:20)
                                .foregroundColor(like ? .clear : .blue)
                        }
                    }
                    .frame(maxWidth: .infinity)

                }
            }
        }
    }
    var item:some View{
        VStack{
            if list.isEmpty{
                Spacer()
                if mode == 0{
                    Image(systemName: "text.badge.xmark")
                        .font(.largeTitle)
                        .padding(.bottom,5)
                    Text("작성한 리뷰가 없습니다")
                }else{
                    ZStack{
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .offset(x:3)
                            .rotationEffect(Angle(degrees: -10))
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .offset(x:-3)
                            .rotationEffect(Angle(degrees: 10))
                    }
                    Text("좋아요/싫어요가 없습니다")
                }
                Spacer()
            }else{
                ScrollView{
                    ForEach(mode == 0 ? list : list.filter({like ? $0.likeStatus == 1 : $0.likeStatus == -1 }),id:\.self){ item in
                        NavigationLink {
                            ReviewDetailsView(goWork: true, reviewId: item.reviewID)
                                .environmentObject(vmAuth)
                                .navigationBarBackButtonHidden()
                        } label: {
                            MyReviewListRowView(review: item)
                                .padding(.horizontal)
                        }.padding(.top,10)
                        Divider().padding(.vertical)
                        if list.count > 10{
                            ProgressView()
                                .onAppear{
                                    vm.currentPage += 1
                                    profileMode
                                }
                        }
                    }
                }
            }
        }
    }
}
