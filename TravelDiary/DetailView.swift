//
//  DetailView.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/25.
//

import SwiftUI
import CoreLocation


struct DetailView: View {
    
    // declare
    var item: Item
    @State private var currentTemperature: Double?
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    
    //about editing
    @State private var isEditing = false
    
    @State private var isEditingAddress = false
    @State private var isEditingContact = false
    @State private var isEditingDate = false
    @State private var isEditingComment = false
    
    @State private var editedAddress: String = ""
    @State private var editedContact: String = ""
    @State private var editedDate: Date = Date()
    @State private var editedComment: String = ""
    
    @State private var showDateSave = false
    @State private var showCommentSave = false
    
    
    var body: some View {
        ZStack{
            Color.bg
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    HStack {
                        // title
                        Text(item.name)
                            //.font(.title)
                            .bold()
                            .padding()
                            .font(.custom("DelaGothicOne-Regular", size: 28))
                            .foregroundColor(Color.c1)
                        
                        // favorite button
                        Button(action: {
                            item.isFavorite.toggle()
                        }) {
                            Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 32, height: 30)
                                .foregroundColor(Color.pnk)
                        }
                        
                        // edit button
                        if isEditing {
                            Button(action: {
                                editedAddress = ""
                                editedContact = ""
                                editedComment = ""
                                isEditing.toggle()
                            }) {
                                Text("Done")
                                    .bold()
                                    .foregroundColor(Color.c2)
                            }
                            .padding()
                        } else {
                            Button(action: {
                                editedAddress = item.add
                                editedContact = item.tel
                                editedComment = item.comment
                                isEditing.toggle()
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.c2)
                            }
                            .padding()
                        }
                    }
                    
                    //rating stars
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Button(action: {
                                item.rating = Double(index)
                            }) {
                                Image(systemName: index <= Int(item.rating) ? "star.fill" : "star")
                                    .font(.system(size: 25))
                            }
                            .foregroundColor(Color.ed)
                            
                        }
                        
                    }
                    .padding(EdgeInsets(top: 5, leading: 40, bottom: 20, trailing: 40))
                    
                    HStack {
                        Text("MAP")
                            //.bold()
                            .font(.custom("DelaGothicOne-Regular", size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(width: 250, height: 30)
                    .background(Color.c2)
                    Text("(click map to show the unfolded map!)")
                        .foregroundColor(Color.c2)
                    
                    
                    // Link to MapView
                    NavigationLink(destination: MapView(location:item.add)
                        .edgesIgnoringSafeArea(.all)){
                            MapView(location: item.add)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height:200)
                                .cornerRadius(20)
                                .padding(EdgeInsets(top: 5, leading: 40, bottom: 20, trailing: 40))
                        }
                    
                    // Address & Contact
                    HStack(alignment: .top)  {
                        VStack{
                            HStack {
                                HStack {
                                    Text("ADDRESS")
                                        .bold()
                                        .font(.custom("DelaGothicOne-Regular", size: 14))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 120, height: 30)
                                .background(Color.c2)
                                
                                
                                
                                // edit mode
                                if isEditing {
                                    Button(action: {
                                        isEditingAddress.toggle()
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(Color.ed)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                            
                            //save edit content
                            if isEditingAddress {
                                TextField("Edit Address", text: $editedAddress)
                                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.c3, lineWidth: 1)
                                    )
                                    .padding(10)
                                    .onSubmit {
                                        item.add = editedAddress
                                        isEditingAddress.toggle()
                                    }
                            } else {
                                Text(item.add)
                                    .foregroundColor(Color.c1)
                                    .padding(.top,5)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding()
                        
                        VStack {
                            HStack {
                                HStack {
                                    Text("CONTACT")
                                        .bold()
                                        .font(.custom("DelaGothicOne-Regular", size: 14))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 120, height: 30)
                                .background(Color.c2)
                                
                                
                                //edit mode
                                if isEditing {
                                    Button(action: {
                                        isEditingContact.toggle()
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(Color.ed)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                            //save edit content
                            if isEditingContact {
                                TextField("Edit Contact", text: $editedContact)
                                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.c3, lineWidth: 1)
                                    )
                                    .padding(10)
                                    .onSubmit {
                                        item.tel = editedContact
                                        isEditingContact.toggle()
                                    }
                            } else {
                                Text(item.tel)
                                    .foregroundColor(Color.c1)
                                    .padding(.top,5)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("WEATHER")
                            .bold()
                            .font(.custom("DelaGothicOne-Regular", size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(width: 250, height: 30)
                    .background(Color.c2)
                    Text("(click to show full weather details!)")
                        .foregroundColor(Color.c2)
                    
                    // Link to WeatherView
                    NavigationLink(destination: WeatherView(item: item)) {
                        // show current weather
                        TempView(item: item)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(width:200, height: 100)
                            .foregroundColor(.white)
                            .background(Color.wea)
                    }
                    .cornerRadius(20)
                    .padding(EdgeInsets(top: 5, leading: 40, bottom: 20, trailing: 40))
                    
                    // Visit Date
                    HStack {
                        HStack {
                            Text("VISITED DATE")
                                .bold()
                                .font(.custom("DelaGothicOne-Regular", size: 14))
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 30)
                        .background(Color.c2)
                        // edit Date
                        if isEditing {
                            Button(action: {
                                isEditingDate.toggle()
                                showDateSave = false
                                
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color.ed)
                            }
                            .padding(.trailing, 8)
                            
                            if showDateSave {
                                Button(action: {
                                    item.date = editedDate
                                    isEditingDate.toggle()
                                    showDateSave = false
                                }) {
                                    Text("Save")
                                        .foregroundColor(Color.ed)
                                }
                            }
                        }
                    }
                    
                    // edit mode
                    if isEditingDate {
                        DatePicker("", selection: $editedDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .onChange(of: editedDate, perform: { _ in
                                showDateSave = true
                            })
                    } else {
                        Text(item.date, style: .date)
                            .foregroundColor(Color.c1)
                            .padding(EdgeInsets(top: 5, leading: 40, bottom: 20, trailing: 40))
                    }
                    
                    // Comment
                    HStack {
                        HStack {
                            Text("NOTES & EXPERIENCES")
                                .bold()
                                .font(.custom("DelaGothicOne-Regular", size: 14))
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 30)
                        .background(Color.c2)
                        
                        //edit comment
                        if isEditing {
                            Button(action: {
                                isEditingComment.toggle()
                                showCommentSave = false
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color.ed)
                            }
                            .padding(.trailing, 8)
                            
                            if showCommentSave {
                                Button(action: {
                                    item.comment = editedComment
                                    isEditingComment.toggle()
                                    showCommentSave = false
                                }) {
                                    Text("Save")
                                        .foregroundColor(Color.ed)
                                }
                            }
                        }
                    }
                    
                    // edit mode
                    if isEditingComment {
                        TextEditor(text: $editedComment)
                            .frame(height: 100)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.c3, lineWidth: 1)
                            )
                            .padding(EdgeInsets(top: 15, leading: 40, bottom: 20, trailing: 40))
                            .onChange(of: editedComment, perform: { _ in
                                showCommentSave = true
                            })
                    } else {
                        Text(item.comment)
                            .foregroundColor(Color.c1)
                            .padding(EdgeInsets(top: 5, leading: 40, bottom: 50, trailing: 40))
                    }
                    

                    

                    
                }
            }
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    @State static var item = Item(name: "Cafe Deadend", date: Date(), tel: "232-923423", add: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", comment: "very good", isFavorite: false, rating: 4)
    
    static var previews: some View {
        DetailView(item: item)
    }
}
