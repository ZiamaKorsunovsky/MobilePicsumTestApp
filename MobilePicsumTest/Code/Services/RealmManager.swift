//
//  RealmManager.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-26.
//

import Foundation
import RealmSwift

protocol RealmManagerManageable {
    func addPhoto(_ photo: Photo)
    func deletePhoto(_ photo: Photo)
    func deleteAllPhotos()
    func loadPhotos() -> [StoredPhoto]
}

class RealmManager: RealmManagerManageable {
    func addPhoto(_ photo: Photo) {
        do {
            let storedPhoto = StoredPhoto(photo: photo)
            let realm = try Realm()
            try realm.write {
                realm.add(storedPhoto)
            }
        } catch {}
    }

    func deletePhoto(_ photo: Photo) {
        do {
            let realm = try Realm()
            let objectsToDelete = realm.objects(StoredPhoto.self).filter({
                $0.id == photo.id
            })
            if objectsToDelete.count > 0 {
                try realm.write {
                    realm.delete(objectsToDelete)
                }
            }
        } catch {}
    }

    func updatePhoto(_ photo: Photo) {
        do {
            let realm = try Realm()
            let objectToUpdate = StoredPhoto(photo: photo)
            try realm.write {
                realm.add(objectToUpdate, update: .all)
            }
        } catch {}
    }

    func deleteAllPhotos() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.deleteAll()
        }
    }

    func loadPhotos() -> [StoredPhoto] {
        do {
            let realm = try Realm()
            let results = realm.objects(StoredPhoto.self)
            return Array(results)
        } catch {
            return []
        }
    }
}
