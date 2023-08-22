//
//  PageTwoView.swift
//  ShopListApp
//
//  Created by 釣悠馬 on 2023/04/27.
//

import SwiftUI

struct PageTwoView: View {
    
    @State var itemName = ""
    @State var price: Int? = nil
    @State var period: Int? = nil
    @State private var showingSettingModal = false
    @State private var showingResultModal = false
    @State var isAlert: Bool = false
    @State var periodChoices = ["年", "ヶ月", "週", "日"]
    @State var frequencyChoices = ["ほぼ毎日", "週に3回程度", "週に1回程度", "2週間に1回程度", "月に1回程度"]
    @State var selectedPeriod = 0
    @State var selectedFrequency = 0
    @AppStorage("asset") var asset = 0
    @AppStorage("hourlyWage") var hourlyWage = 0
    @State var days = 0
    @State var daysUsed = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("買い物満足度診断").font(.title)
            Spacer()
            Form {
                Section (header: Text("欲しい商品の情報を入力してください")) {
                    HStack {
                        TextField("商品名を入力", text: $itemName)
                            .multilineTextAlignment(TextAlignment.center)
                    }.padding(10)
                    HStack {
                        Text("値段：")
                        TextField("0", value: $price, format: .number)
                            .multilineTextAlignment(TextAlignment.trailing)
                        Text("円")
                    }.padding(10)
                    HStack {
                        Text("使用期間：")
                        TextField("0", value: $period, format: .number)
                            .multilineTextAlignment(TextAlignment.trailing)
                        Picker(selection: $selectedPeriod, label: Text("")) {
                            ForEach(periodChoices.indices, id: \.self) { periodIndex in
                                Text(self.periodChoices[periodIndex])
                            }
                        }.labelsHidden()
                        Text("間")
                    }.padding(10)
                    HStack {
                        Text("使用頻度：")
                        Picker(selection: $selectedFrequency, label: Text("")) {
                            ForEach(frequencyChoices.indices, id: \.self) { frequencyIndex in
                                Text(self.frequencyChoices[frequencyIndex])
                            }

                        }.labelsHidden()
                    }.padding(10)
                }
                
                Section (header: Text("現在のあなたの情報を入力してください")) {
                    HStack {
                        Text("現在の資産額：")
                        TextField("0", value: $asset, format: .number)
                            .multilineTextAlignment(TextAlignment.trailing)
                        Text("万円")
                    }.padding(10)
                    HStack {
                        Text("現在の時給：")
                        TextField("0", value: $hourlyWage, format: .number)
                            .multilineTextAlignment(TextAlignment.trailing)
                        Text("円")
                    }.padding(10)
                }
            }
            Spacer()
            Button(action: {
                if self.itemName == "" || self.price == nil || self.period == nil || self.asset == 0 || self.hourlyWage == 0 {
                    self.isAlert.toggle()
                } else {
                    self.days = convertToDays(period: &self.period, periodChoices: self.periodChoices, selectedPeriod: self.selectedPeriod)
                    self.daysUsed = numberOfDaysUsed(period: &self.period, frequencyChoices: self.frequencyChoices, selectedFrequency: self.selectedFrequency, days: self.days)
                    self.showingResultModal = true
                }
            }){
                Text("診断スタート")
                    .bold()
                    .padding()
                    .frame(width: 150, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(25)
            }.padding(10)
            Spacer()
                .sheet(isPresented: $showingResultModal) {
                    ResultModalView(itemName: self.$itemName, price: self.$price, asset: self.$asset, hourlyWage: self.$hourlyWage, daysUsed: self.$daysUsed)
                }
        }.alert(isPresented: self.$isAlert) {
            Alert(title: Text("全ての項目を入力してください"), dismissButton: .default(Text("OK")))
        }
    }
}

//使用期間の単位に応じて日数に変換
func convertToDays(period: inout Int?, periodChoices: [String], selectedPeriod: Int) -> Int{
    var days = 0
    if period != nil {
        switch periodChoices[selectedPeriod] {
        case "年":
            days = period! * 365
        case "ヶ月":
            days = period! * 30
        case "週":
            days = period! * 7
        default:
            days = period! * 1
        }
    }
    return days
}

//使用日数を使用頻度に合わせて変換
func numberOfDaysUsed(period: inout Int?, frequencyChoices: [String], selectedFrequency: Int, days: Int) -> Int{
    var daysUsed = 0
    if period != nil {
        switch frequencyChoices[selectedFrequency] {
        case "ほぼ毎日":
            daysUsed = days / 1
        case "週に3回程度":
            daysUsed = days / 2
        case "週に1回程度":
            daysUsed = days / 7
        case "2週間に1回程度":
            daysUsed = days / 14
        default:
            daysUsed = days / 30
        }
    }
    return daysUsed
}

struct PageTwoView_Previews: PreviewProvider {
    static var previews: some View {
        PageTwoView()
    }
}
