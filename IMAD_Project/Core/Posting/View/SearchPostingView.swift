//
//  SearchPostingView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/10/17.
//

import SwiftUI

struct SearchPostingView: View {
    
    @StateObject var vm = CommunityViewModel(community: nil, communityList: [])
    
    @State var community:PostingResponse?
    @State var sortButton = false
    @State var orderButton = false
    @State var typeButton = false
    @State var text = ""
    
    @State var goCommunity = false
    @State var sort:SortPostCategory = .createdDate
    @State var order:OrderPostCategory = .descending
    @State var type:SearchCategory = .titleContents
    @State var category:CommunityCategory = .all
    
    @Environment(\.dismiss) var dismiss
    @StateObject var user = UserInfoManager.instance
    
    var body: some View {
        VStack(alignment: .leading){
            header
            searchView
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    filterView(type: "search")
                    filterView(type: "order")
                    filterView(type: "sort")
                    filterView(type: "category")
                }
                .padding(.horizontal,10)
            }
            if !vm.communityList.isEmpty{
                ScrollView(showsIndicators: false){
                    Text("총 \(vm.totalOfElements)개")
                        .fontWeight(.bold).padding(.horizontal,10).frame(maxWidth: .infinity,alignment:.leading)
                    ForEach(vm.communityList,id: \.self){ community in
                        Button {
                            self.community = community
                            goCommunity = true
                        } label: {
                            CommunityListRowView(community: community)
                        }
                        .padding(.leading,10)
                        
                        .padding(.vertical,2)
                        if vm.communityList.last == community,vm.maxPage > vm.currentPage{
                            ProgressView()
                                .onAppear{
                                    vm.readListConditionsAll(searchType: type.num, query: text, page: vm.currentPage + 1, sort: sort.rawValue, order: order.rawValue,category: category.num)
                                }
                        }
                    }
                }
            }else{
                Spacer()
            }
        }
        .navigationDestination(isPresented: $goCommunity){
            if let community{
                PostingDetailsView(reported: community.reported, postingId: community.postingID, back: $goCommunity)
                   
                    .navigationBarBackButtonHidden()
            }
        }
        .onChange(of: order){ _ in
            if !text.isEmpty{
                listUpdate()
            }
        }
        .onChange(of: type){ _ in
            if !text.isEmpty{
                listUpdate()
            }
        }
        .onChange(of: category){ _ in
            if !text.isEmpty{
                listUpdate()
            }
        }
        .onChange(of: sort){ _ in
            if !text.isEmpty{
                listUpdate()
            }
        }
        .foregroundColor(.customIndigo)
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()
    }
}

struct SearchPostingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPostingView(vm:CommunityViewModel(community: nil, communityList: CustomData.communityList))
           
    }
}
extension SearchPostingView{
    var header:some View{
        HeaderView(backIcon: "chevron.left", text: "커뮤니티 검색"){
            dismiss()
        }
        .padding([.top,.leading],10)
    }
    var searchView:some View{
        HStack{
            CustomTextField(password: false, image: "magnifyingglass", placeholder: "게시물을 검색해 주세요..", color:.gray,style:.none, text: $text)
                .padding(15)
                .background(Color.gray.opacity(0.2).cornerRadius(50))
                .padding(.leading,10)
            Button {
                if !text.isEmpty{
                    listUpdate()
                }
            } label: {
                Text("검색")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.customIndigo)
                    .cornerRadius(20)
            }
            .padding(.trailing,10)
        }
    }
    func filterView(type:String) -> some View{
        Menu {
            switch type{
            case "search":
                Picker(selection: $type) {
                    ForEach(SearchCategory.allCases,id:\.self){ type in
                        Text(type.name)
                    }
                } label: {}
            case "order":
                Picker(selection: $order) {
                    ForEach(OrderPostCategory.allCases,id:\.self){ order in
                        Text(order.name)
                    }
                } label: {}
            case "sort":
                Picker(selection: $sort) {
                    ForEach(SortPostCategory.allCases,id:\.self){ sort in
                        Text(sort.name)
                    }
                } label: {}
            case "category":
                Picker(selection: $category) {
                    ForEach(CommunityCategory.allCases,id:\.self){ category in
                        Text(category.name)
                    }
                } label: {}
            default: Text("")
            }
        } label: {
            HStack{
                switch type{
                case "search":
                    Text(self.type.name)
                        .font(.custom("GmarketSansTTFMedium", size: 12))
                case "order":
                    Text(self.order.name)
                        .font(.custom("GmarketSansTTFMedium", size: 12))
                case "sort":
                    Text(self.sort.name)
                        .font(.custom("GmarketSansTTFMedium", size: 12))
                case "category":
                    Text(self.category.name)
                        .font(.custom("GmarketSansTTFMedium", size: 12))
                default: Text("")
                }
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
        .padding(.vertical,5)
        .padding(.horizontal)
        .background(Capsule().stroke(lineWidth: 1)
            .foregroundColor(.customIndigo))
        .padding(.vertical,5)
    }
    func listUpdate(){
        vm.currentPage = 1
        vm.communityList.removeAll()
        vm.readListConditionsAll(searchType: type.num, query: text, page: vm.currentPage, sort: sort.rawValue, order: order.rawValue,category: category.num)
    }
}
