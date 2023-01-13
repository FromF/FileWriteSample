//
//  ContentView.swift
//  FileWriteSample
//
//  Created by 藤治仁 on 2023/01/09.
//

import SwiftUI

struct ContentView: View {
    @State var displayText = "Hello, world!"
    @State var saveText = "SampleText"
    var body: some View {
        TabView {
            FileReadWriteView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("ファイルの読み書き")
                    }
            }.tag(1)
            FileDownloadView()
                .tabItem {
                    VStack {
                        Image(systemName: "bold")
                        Text("ファイルダウンロード")
                    }
            }.tag(2)
        }
    }
    
    func saveData(name: String, data: Data) {
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = dirURL.appendingPathComponent(name)
        do {
            try data.write(to: fileURL)
        } catch {
            print("save failed \(error)")
        }
    }
    
    func loadData(name: String) -> Data? {
        var data: Data?
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return data
        }
        let fileURL = dirURL.appendingPathComponent(name)
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            print("load failed \(error)")
        }
        
        return data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
