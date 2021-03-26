//
//  IndividualAlbumView.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI
import UIKit
import CoreData

struct IndividualAlbumView: View {

    @State var albumName: String = ""
    var albumIndex: Int

    var body: some View {
        IndividualAlbumView2(albumName: $albumName, albumIndex: albumIndex)
    }
}

struct IndividualAlbumView2: View {
    @Environment(\.managedObjectContext) var viewContext

    @State var gridLayout: [GridItem] = [ GridItem() ]
    @Binding var albumName: String
    @State var bool: Bool = true
    var albumIndex: Int

    @FetchRequest(
        entity: ImgCore.entity(),
        sortDescriptors: []
    ) var imgsCore: FetchedResults<ImgCore>

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(
                            imgsCore.indices, id: \.self) { index in
                            if imgsCore[index].album == self.albumName {
                                NavigationLink(destination: ImageView(imageName:
                                                                        UIImage(data: (imgsCore[index].img)!),
                                                                      imageIndex: index, albumIndex: albumIndex)) {
                                    Image(uiImage: UIImage(data: (imgsCore[index].img)! )!)
                                        .imageGridModifier(gridLayout: gridLayout)
                                }
                            }
                        }
                    }
                    .padding(.all, 10)
                    .animation(.interactiveSpring())
                }
                AlbumToolbarView(geometry: geometry, albumName: self.albumName, albumIndex: albumIndex)
            }
        }
        .navigationTitle(self.albumName)
        .navigationBarItems(trailing: GridButton(gridLayout: $gridLayout))
    }
}

