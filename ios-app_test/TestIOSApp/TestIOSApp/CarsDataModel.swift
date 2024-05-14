//
//  CarsDataModel.swift
//  TestIOSApp
//
//  Created by Yarik on 13.05.2024.
//  Copyright © 2024 Test. All rights reserved.
//

import Foundation
import Alamofire


enum CarListState {
    case loading
    case success(DescriptionModel)
    case failure(Error)
}

enum CarsInput {
    case initial
}

// MARK: - Welcome
struct DescriptionModel: Codable {
    let title: String
    let results: [CarModel]
}


// MARK: - Result
struct CarModel: Codable {
    let title: String
    let description: String
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

