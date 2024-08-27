//
//  StoredPhoto.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-26.
//

import UIKit
import Foundation
import RealmSwift

class StoredPhoto: Object {
    @Persisted var id: Int = 0
    @Persisted var order: Int = 0
    @Persisted var author: String = ""
    @Persisted private var _url: String = ""
    @Persisted private var _imageData: Data?

    convenience init(photo: Photo) {
        self.init()

        self.id = photo.id
        self.order = photo.order
        self.author = photo.author
        self._url = photo.photoUrl
        self._imageData = photo.image.jpegData(compressionQuality: 1)
    }

    var url: URL? {
        get {
            URL(string: _url)
        }
    }

    var image: UIImage {
        get {
            guard let data = _imageData, let image = UIImage(data: data) else {
                return UIImage(systemName: "photo")!
            }
            return image
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
