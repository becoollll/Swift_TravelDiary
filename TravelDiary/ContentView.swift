//
//  ContentView.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/21.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    init() { // clear default color
        // clear color
        UICollectionView.appearance().backgroundColor = .clear

        let titleColor = UIColor(
            red: CGFloat(70) / 255.0,
            green: CGFloat(63) / 255.0,
            blue: CGFloat(58) / 255.0,
            alpha: 1.0
        )
        
        // navigation title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: titleColor]
        
        // inline navigation title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: titleColor]
    }

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var searchText = "" // Add this line
    @State private var showCreateView = false
    //@State private var sortSelection: SortSelection = .byDate
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.bg
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        TextField("Search", text: $searchText) // Add this TextField
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                            .padding(.top, 5)
                        // filter, for search key words
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color.c3)
                            }
                            .padding(.trailing, 8)
                            .transition(.move(edge: .trailing))
                            .animation(.default)
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                    List {
                        ForEach(items.filter {
                            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
                        }) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                HStack{
                                    if item.isFavorite {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(Color.pnk)
                                    } else {
                                        Image(systemName: "heart")
                                            .foregroundColor(Color.pnk)
                                    }
                                    VStack(alignment: .leading){
                                        Text(item.name)
                                            .font(.custom("DelaGothicOne-Regular", size: 20))
                                            .foregroundColor(Color.c2)
                                            .bold()
                                            
                                        Text(item.date, format: Date.FormatStyle(date: .numeric))
                                            .foregroundColor(Color.c3)
                                            .bold()
                                    }
                                }
                                
                            }
                            
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .padding(5)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        
                        ToolbarItem {
                            Button(action: {
                                showCreateView.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(Color.ed)
                            }
                            .sheet(isPresented: $showCreateView) {
                                CreateView()
                            }
                        }
                        
                        
                    }
                    .navigationTitle("Travel Diary")
                    .foregroundColor(Color.ed)
                    
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self)
}

