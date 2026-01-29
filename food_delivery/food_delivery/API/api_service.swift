//
//  api_service.swift
//  login_ui
//
//  Created by Vinay H on 18/09/25.
//

import Foundation

class APIService{
    static let shared  = APIService()
    private init(){}
    
    func fetcData(completion: @escaping ([APIObject]?) -> Void){
        guard let url  = URL(string:"https://api.restful-api.dev/objects") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
//            print("data objects:",  data)
            if let data  = data{
                do {
                    let objects = try JSONDecoder().decode([APIObject].self, from: data)
                    completion(objects)
                } catch {
                    print("Decoding error:", error)
                    completion(nil)
                }

            }else{
                print("Error:", error ?? "Unkown Error")
                completion(nil)
            }
        }.resume()
    }
    
    
   
    
    func postData(completion: @escaping (Result<String, Error>) -> Void){
        
        let newDevice = Device(
            name: "VINAY DEVICE",
            data: Specs(
                year: 2019,
                price: 1849.99,
                cpuModel: "Intel Core i9",
                hardDiskSize: "1 TB"
            )
        )
        
        guard let jsonData = try? JSONEncoder().encode(newDevice) else{
            print("Failed to encode request body")
            return
        }
        
        let url = URL(string: "https://your-api-endpoint.com/post")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let response  = response as? HTTPURLResponse, response.statusCode == 200{
                print("Success: \(response.statusCode)")
                completion(.success("Successfully posted data"))
            } else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey : "Failed with statis dode \(code)"])))
            }
        }.resume()
    }
}
