import SwiftUI

struct PageOneView: View {
    
    @State var items: [String] = []
    @State var newItem = ""
    @State var isAlert: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                ZStack {
                    Text("買い物リスト")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    MyEditButton().padding(.leading, 310.0)
                }
                HStack {    
                    TextField("欲しいものを入力してください", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                    
                    Button(action: {
                        if self.newItem == "" {
                            self.isAlert.toggle()
                        } else {
                            self.items.append(self.newItem)
                            self.newItem = ""
                            UserDefaults.standard.set(self.items, forKey: "itemSave")
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 50, height: 30)
                                .foregroundColor(.green)
                            Text("追加").foregroundColor(.white)
                        }
                    }
                }.padding(10)
                
                List {
                    ForEach (items, id: \.self) { item in
                        Text(item)
                    }.onDelete { (IndexSet) in
                        self.items.remove(atOffsets: IndexSet)
                        UserDefaults.standard.set(self.items, forKey: "itemSave")
                    }.onMove { (IndexSet, Destination) in
                        self.items.move(fromOffsets: IndexSet, toOffset: Destination)
                        UserDefaults.standard.set(self.items, forKey: "itemSave")
                    }
                }
            }.alert(isPresented: self.$isAlert) {
                Alert(title: Text("欲しいものを入力してください"), dismissButton: .default(Text("OK")))
            }.onAppear() {
                guard let defaultItem = UserDefaults.standard.array(forKey: "itemSave") as? [String] else {return}
                self.items = defaultItem
            }
        }
    }
}

struct MyEditButton: View {
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Text("完了")
            } else {
                Text("編集")
            }
        }
    }
}


struct PageOneView_Previews: PreviewProvider {
    static var previews: some View {
        PageOneView()
    }
}
