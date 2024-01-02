//
//  Colors.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/27.
//

import SwiftUI

extension Color {
    static let bg = Color(red: 244.0/255.0, green: 243.0/255.0, blue: 238.0/255.0)
    static let pnk = Color(red: 244.0/255.0, green: 175.0/255.0, blue: 160.0/255.0)
    static let c1 = Color(red: 70.0/255.0, green: 63.0/255.0, blue: 58.0/255.0)
    static let c2 = Color(red: 138.0/255.0, green: 129.0/255.0, blue: 124.0/255.0)
    static let c3 = Color(red: 188.0/255.0, green: 184.0/255.0, blue: 177.0/255.0)
    
    static let ed = Color(red: 226.0/255.0, green: 192.0/255.0, blue: 68.0/255.0)
    static let wea = Color(red: 159.0/255.0, green: 177.0/255.0, blue: 188.0/255.0)
    
}

extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
