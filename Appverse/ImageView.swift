//
//  ImageView.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI

struct ImageView: View {

    @State var imageName: UIImage?
    @State var backgroundChange: Bool = false
    var imageIndex: Int
    var albumIndex: Int

    var body: some View {
        if backgroundChange {
            IndividualImageView(backgroundChange: $backgroundChange, imageName: $imageName, imageIndex: imageIndex,
                                albumIndex: albumIndex)
                .background(Color.black)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        } else {
            IndividualImageView(backgroundChange: $backgroundChange, imageName: $imageName, imageIndex: imageIndex,
                                albumIndex: albumIndex)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

struct IndividualImageView: View {

    @Binding var backgroundChange: Bool
    @Binding var imageName: UIImage?
    @GestureState var scale: CGFloat = 1.0
    @State private var selection: String?

    var imageIndex: Int
    var albumIndex: Int

    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: imageName!)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .gesture(MagnificationGesture()
                            .updating($scale, body: { (value, scale, _) in
                                scale = value.magnitude
                            }))
            Spacer()
        }
        .gesture(
            TapGesture()
                .onEnded {
                    backgroundChange.toggle()
                }
        )
    }
}

