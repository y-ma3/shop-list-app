//
//  ResultModalView.swift
//  ShopListApp
//
//  Created by 釣悠馬 on 2023/04/29.
//

import SwiftUI

struct ResultModalView: View {
    
    @Binding var itemName: String
    @Binding var price: Int?
    @Binding var asset: Int
    @Binding var hourlyWage: Int
    @Binding var daysUsed: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        let asset = asset * 10000
        if self.price != nil {
            let rate = String(format: "%.1f", Float(price!) / Float(asset) * 100)
            let workingHours = String(format: "%.1f", Float(price!) / Float(hourlyWage))
            let feePerUse = String(format: "%.1f", Float(price!) / Float(daysUsed))
            
            VStack {
                Text("\(itemName)は、")
                    .padding()
                    .font(.largeTitle)
                VStack {
                    HStack {
                        Text("あなたの資産の")
                        Text("\(rate)%")
                            .foregroundColor(Color.red)
                            .bold()
                    }.padding().font(.title3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    HStack {
                        Text("\(workingHours)時間")
                            .foregroundColor(Color.red)
                            .bold()
                        Text("の労働")
                    }.padding().font(.title3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    HStack {
                        Text("1回あたり")
                        Text("約\(feePerUse)円")
                            .foregroundColor(Color.red)
                            .bold()
                        Text("の使用料")
                    }.padding().font(.title3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
                Text("で、購入できます")
                    .padding()
                    .font(.largeTitle)
                Button(action: {
                    dismiss()
                }) {
                    Text("閉じる")
                        .bold()
                        .padding()
                        .frame(width: 150, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
        }
    }
}

struct ResultModalView_Previews: PreviewProvider {
    static var previews: some View {
        ResultModalView(itemName: .constant("りんご"), price: .constant(20000), asset: .constant(10), hourlyWage: .constant(950), daysUsed: .constant(100))
    }
}
