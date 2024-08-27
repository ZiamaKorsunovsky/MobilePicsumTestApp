//
//  PhotoCellView.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-26.
//

import Foundation
import SwiftUI

struct PhotoCellView: View {

    var photo: Photo
    var listener: PhotoListenerManageable?

    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { gr in
                Image(uiImage: photo.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: gr.size.width)
            }
            .clipped()
            .aspectRatio(1, contentMode: .fit)

            HStack {
                Spacer()

                ZStack(alignment: .center) {
                    Circle()
                        .fill(.white)
                        .frame(width: 34, height: 34)

                    Button {
                        listener?.deletePhoto(photo)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .foregroundColor(.red)
                    }
                    .frame(width: 30, height: 30)
                    .padding(4)
                }
            }

            VStack {
                Spacer()

                Text(photo.author)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, maxHeight: 24)
                    .font(.headline)
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.8))
            }
        }
        .clipped()
        .background(Color.gray)
        .border(Color.black, width: 1)
    }
}

struct PhotoCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            PhotoCellView(photo: Photo(id: 0, order: 0, author: "Author"), listener: nil)
                .frame(width: 200, height: 200)
            Spacer()
        }
        .previewLayout(.sizeThatFits)
    }
}
