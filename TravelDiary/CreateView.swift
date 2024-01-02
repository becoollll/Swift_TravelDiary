//
//  CreateView.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/26.
//

import SwiftUI
import SwiftData
import SwiftUI

struct CreateView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = Item()
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.bg
                    .ignoresSafeArea()
                List {
                    Section(header: Text("Name").foregroundColor(Color.c2)) {
                        TextField("", text: $item.name)
                            .foregroundColor(Color.c1)
                    }
                    Section(header: Text("Visited Date").foregroundColor(Color.c2)) {
                        DatePicker("Choose Visited Date", selection: $item.date, displayedComponents: .date)
                            .foregroundColor(Color.c2)
                    }
                    Section(header: Text("Contact").foregroundColor(Color.c2)) {
                        TextField("Telephone", text: $item.tel)
                            .foregroundColor(Color.c1)
                        TextField("Address", text: $item.add)
                            .foregroundColor(Color.c1)
                            .frame(maxHeight: .infinity)
                    }
                    Section(header: Text("Comment").foregroundColor(Color.c2)) {
                        TextEditor(text: $item.comment)
                            .foregroundColor(Color.c1)
                            .frame(minHeight: 100)
                    }
                    Section(header: Text("Preference").foregroundColor(Color.c2)) {
                        Toggle("Favorite?", isOn: $item.isFavorite)
                            .toggleStyle(SwitchToggleStyle(tint: Color.pnk))
                            .foregroundColor(Color.c2)
                        
                        HStack {
                            Text("Rating")
                                .foregroundColor(Color.c2)
                            Slider(value: $item.rating, in: 0...5, step: 1)
                                .accentColor(Color.ed)
                            Text("\(Int(item.rating))")
                                .foregroundColor(Color.c2)
                        }
                    }

                    
                    
                    
                }
                .navigationTitle("Add New Place")
                .toolbar {
                    // Add toolbar items here
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            withAnimation {
                                context.insert(item)
                            }
                            dismiss()
                        }
                    }
                    
                }
                
            }
        }
    }
}



#Preview {
    CreateView()
        .modelContainer(for: Item.self)
}

