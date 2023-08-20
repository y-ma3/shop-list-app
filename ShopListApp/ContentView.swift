import SwiftUI
import AppVersionMonitorSwiftUI

struct ContentView: View {
    
    @State var isAlert: Bool = false
    @State var selection = 1
    
    var body: some View {
        
        TabView(selection: $selection) {
            PageOneView()
                .tabItem() {
                    Label("リスト", systemImage: "list.bullet.clipboard")
                }.tag(1)
            PageTwoView()
                .tabItem() {
                    Label("買い物診断", systemImage: "rotate.3d")
                }.tag(2)
        }
        .alert(isPresented: $isAlert) {
            Alert(title: Text("お知らせ"), message: Text("最新バージョンがあります"), dismissButton: .default(Text("OK")) {
                // AppStoreを開く
                let url = URL(string: "https://apps.apple.com/us/app/%E8%B2%B7%E3%81%84%E7%89%A9%E3%83%AA%E3%82%B9%E3%83%88%E3%82%A2%E3%83%97%E3%83%AA/id6449244738")!
                // URLを開けるかをチェックする
                if UIApplication.shared.canOpenURL(url) {
                    // URLを開く
                    UIApplication.shared.open(url, options: [:])
                }
            })
        }
        .appVersionMonitor(id: 6449244738) { status in
            switch status {
            case .updateAvailable:
                isAlert = true
                print("アップデートがあります")
            case .updateUnavailable:
                print("アップデートがありません")
            case .failure(let error):
                print("エラーが発生しました: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
