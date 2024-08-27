//
//  Photo.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-26.
//

import UIKit
import Foundation

public struct Photo: Decodable, Identifiable, Equatable {
    public var id: Int
    var photoUrl: String
    var author: String
    var order: Int
    var image: UIImage

    enum CodingKeys: String, CodingKey {
        case id, author
        case photoUrl = "download_url"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let idString = try values.decode(String.self, forKey: .id)
        id = Int(idString) ?? 0
        author = try values.decode(String.self, forKey: .author)
        photoUrl = try values.decode(String.self, forKey: .photoUrl)

        order = 0
        image = UIImage(systemName: "photo")!
    }

    init(id: Int, order: Int, author: String) {
        self.id = id
        self.author = author
        self.photoUrl = ""

        self.order = order
        self.image = UIImage(systemName: "photo")!
    }

    mutating func updateOrder(_ value: Int) {
        self.order = value
    }

    mutating func updateImage(_ value: UIImage) {
        self.image = value
    }
}

extension Photo {
    init(_ storedPhoto: StoredPhoto) {
        self.id = storedPhoto.id
        self.order = storedPhoto.order
        self.author = storedPhoto.author
        self.photoUrl = storedPhoto.url?.absoluteString ?? ""
        self.image = storedPhoto.image
    }

    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id && lhs.order == rhs.order
    }
}
