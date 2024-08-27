//
//  PhotosListScreen.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-27.
//

import SwiftUI

struct PhotosListScreen: View {

    @ObservedObject
    var viewModel: PhotosListViewModel = PhotosListViewModel()

    @State
    private var active: Photo?

    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 120, maximum: 200), spacing: 15)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: self.columns, spacing: 15) {
                        ReorderableView(viewModel.photos, active: $active) { photo in
                            PhotoCellView(photo: photo, listener: viewModel)
                                .contentShape(.dragPreview, Rectangle())
                        } moveAction: { from, to in
                            viewModel.photos.move(fromOffsets: from, toOffset: to)
                        } dropAction: { _, to in
                            viewModel.droppedPhoto(at: to)
                        }
                    }.padding()
                }
                .defaultScrollAnchor(.bottom)
                .scrollContentBackground(.hidden)
                .reorderableForEachContainer(active: $active)
            }
            .toolbar {
                ActionsToolbar(viewModel: viewModel)
            }

        }
        .alert(isPresented: $viewModel.isShowAlert, content: {
            Alert(title: Text("oops".localized), message: Text(viewModel.alertMessage), dismissButton: .cancel())
        })
        .overlay {
            if viewModel.isShowLoading {
                ZStack {
                    Color(white: 0, opacity: 0.5)
                    ProgressView().tint(.white)
                }
                .ignoresSafeArea()
            }
        }
        .task {
            viewModel.loadStoredPhotos()
        }
    }
}

struct ActionsToolbar: ToolbarContent {

    @ObservedObject
    var viewModel: PhotosListViewModel = PhotosListViewModel()

    var body: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    viewModel.loadRandomPhotoAction()
                } label: {
                    Text("load_photo".localized)
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                Button {
                    viewModel.deleteAllPhotosAction()
                } label: {
                    Text("delete_all".localized)
                }
                .buttonStyle(.borderedProminent)
                .disabled($viewModel.photos.count == 0)
            }
        }
    }
}

struct PhotosListScreen_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListScreen()
    }
}
