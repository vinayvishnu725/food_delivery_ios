//
//  api_request_model.swift
//  login_ui
//
//  Created by Vinay H on 22/09/25.
//

struct Device: Codable {
    let name: String
    let data: Specs
}

struct Specs: Codable {
    let year: Int
    let price: Double
    let cpuModel: String
    let hardDiskSize: String

    enum CodingKeys: String, CodingKey {
        case year, price
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
    }
}


