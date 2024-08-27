//
//  PhotosListViewModel.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-27.
//

import Foundation
import RealmSwift
import SwiftUI

public protocol PhotoListenerManageable {
    func deletePhoto(_ photo: Photo)
}

class PhotosListViewModel: ObservableObject {

    private var realmManager = RealmManager()

    @Published var photos = [Photo]()

    @Published var isShowLoading: Bool = false
    @Published var isShowAlert: Bool = false
    @Published var alertMessage: String = ""

    func loadStoredPhotos() {

        photos = []

        let storedPhotos = realmManager.loadPhotos()
        storedPhotos
            .sorted(by: { $0.order < $1.order })
            .forEach { val in
                DispatchQueue.main.async {
                    self.photos.append(Photo(val))
                }
            }
    }

    func loadRandomPhotoAction() {

        self.showLoading()

        let excludingIDs = self.photos.map { $0.id }

        NetworkService.fetchRandomItem(excludingIDs: excludingIDs) { result in
            switch result {
            case .failure(let error):
                self.showAlert(message: "Error: \(error.localizedDescription)")
                self.hideLoading()
            case .success(let photo):
                guard let photo = photo else {
                    self.showAlert(message: "all_data_fetched".localized)
                    self.hideLoading()
                    return
                }
                var newPhoto = photo
                newPhoto.updateOrder(self.photos.count)

                guard let imageURL = URL(string: newPhoto.photoUrl) else {
                    self.appendNewPhoto(newPhoto)
                    self.hideLoading()
                    return
                }

                NetworkService.loadImage(withURL: imageURL) { resImage in
                    switch resImage {
                    case .failure(let error):
                        // Photo image loading issue occured. We'll use a placeholder
                        print("Loading image error: \(error)")
                    case .success(let image):
                        newPhoto.updateImage(image)
                    }
                    self.appendNewPhoto(newPhoto)
                    self.hideLoading()
                }
            }
        }
    }

    func deleteAllPhotosAction() {
        DispatchQueue.main.async {
            self.photos = []
        }
        self.realmManager.deleteAllPhotos()
    }
}

extension PhotosListViewModel {

    func appendNewPhoto(_ photo: Photo) {
        DispatchQueue.main.async {
            self.photos.append(photo)
        }
        self.realmManager.addPhoto(photo)
    }

    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.isShowAlert = true
        }
    }

    func showLoading() {
        DispatchQueue.main.async {
            self.isShowLoading = true
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.isShowLoading = false
        }
    }

    func droppedPhoto(at atIndex: Int) {
        let movedPhoto = photos[atIndex]
        if movedPhoto.order != atIndex {
            let startingIdx = min(atIndex, movedPhoto.order)
            let endIdx = max(atIndex, movedPhoto.order)
            self.resetOrder(from: startingIdx, to: endIdx)
        }
    }

    private func resetOrder(from: Int, to: Int) {
        photos[from...to].indices.forEach { idx in
            DispatchQueue.main.async {
                self.photos[idx].updateOrder(idx)
            }
            self.realmManager.updatePhoto(photos[idx])
        }
    }
}

extension PhotosListViewModel: PhotoListenerManageable {

    func deletePhoto(_ photo: Photo) {
        DispatchQueue.main.async {
            self.photos = self.photos.filter { $0.id != photo.id }
            if self.photos.count > 0 && photo.order <= self.photos.count-1 {
                self.resetOrder(from: photo.order, to: self.photos.count-1)
            }
        }
        self.realmManager.deletePhoto(photo)
    }
}
