//
//  FileReadWriteView.swift
//  FileWriteSample
//
//  Created by 藤治仁 on 2023/01/13.
//

import SwiftUI

struct FileReadWriteView: View {
    @State var displayText = "Hello, world!"
    @State var saveText = "SampleText"
    var body: some View {
        VStack {
            Text("読み込んだテキストデータ：\(displayText)")
            HStack {
                Text("書き込みたい文字列：")
                TextField("test", text: $saveText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack{
                Button {
                    if let data = saveText.data(using: .utf8) {
                        let fileName = "Sample.txt"
                        saveData(name: fileName, data: data)
                    }
                } label: {
                    Text("save")
                        .padding()
                        .background(.orange)
                }
                .padding()
                
                Button {
                    let fileName = "Sample.txt"
                    if let data = loadData(name: fileName) ,
                       let text = String(data: data, encoding: .utf8) {
                        displayText = text
                    } else {
                        displayText = "load Failed"
                    }
                } label: {
                    Text("load")
                        .padding()
                        .background(.orange)
                }
                .padding()
            }
        }
        .padding()
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

struct FileReadWriteView_Previews: PreviewProvider {
    static var previews: some View {
        FileReadWriteView()
    }
}
