//
//  FileDownloadView.swift
//  FileWriteSample
//
//  Created by 藤治仁 on 2023/01/13.
//

import SwiftUI

struct FileDownloadView: View {
    @State var downloadURL = "https://1.bp.blogspot.com/-_CVATibRMZQ/XQjt4fzUmjI/AAAAAAABTNY/nprVPKTfsHcihF4py1KrLfIqioNc_c41gCLcBGAs/s400/animal_chara_smartphone_penguin.png"
    var body: some View {
        VStack {
            Text("ダウンロードするURL")
            TextField("URL", text: $downloadURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                Task {
                    do {
                        let data = try await request(with: downloadURL)
                        saveData(name: "Test.png", data: data)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("DownLoad")
            }
            .padding()

        }
    }
    
    enum APIClientError: Error {
        case invalidURL
        case responseError
        case noData
        case badStatus(statusCode: Int)
        case serverError(_ error: Error)
    }

    //https://blog.personal-factory.com/2022/01/23/how-to-use-async-await-since-swift5_5/
    private func request(with urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APIClientError.invalidURL
        }
        do {
            // ①リクエスト
            let (data, urlResponse) = try await URLSession.shared.data(from: url, delegate: nil)
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIClientError.responseError
            }

            // ②ステータスコードによって処理を分ける
            switch httpStatus.statusCode {
                case 200 ..< 400:
                    let response = data
                    if response.isEmpty {
                        throw APIClientError.noData
                    }
                    return response
                case 400... :
                    throw APIClientError.badStatus(statusCode: httpStatus.statusCode)
                default:
                    fatalError()
                    break
            }
        } catch {
            throw APIClientError.serverError(error)
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
}

struct FileDownloadView_Previews: PreviewProvider {
    static var previews: some View {
        FileDownloadView()
    }
}
