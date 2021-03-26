//
//  JustEntry.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI

struct JustEntry: View {

    @Environment(\.managedObjectContext) var viewContext

    private var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var askAlbumName = false
    @State private var selection: String?
    @State private var albumPresentAlready = false

    @FetchRequest(
        entity: Albums.entity(),
        sortDescriptors: []
    ) var albums: FetchedResults<Albums>

    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                    ForEach(albums.indices, id: \.self) { index in
                        NavigationLink(
                            destination: IndividualAlbumView( albumName: albums[index].name!, albumIndex: index)) {
                            VStack {
                                if albums[index].present {
                                    Image(uiImage: UIImage(data: (albums[index].img)! )!)
                                        .imageGridModifier(gridLayout: gridLayout)
                                } else {
                                    Image(albumDefaultCoverImage)
                                        .imageGridModifier(gridLayout: gridLayout)
                                }
                                RegularText(text: albums[index].name!)
                            }
                        }
                    }
                }
                .padding(.all, 10)
                .animation(.interactiveSpring())
            }
        }
        .alert(isPresented: $albumPresentAlready) {
            Alert(title: Text(duplicateAlbumAlertCaptionText),
                  message: Text(duplicateAlbumAlertMessageText),
                  dismissButton: .default(Text(understoodAlertText)))
        }
        .alert(isPresented: $askAlbumName,
               TextAlert(title: newAlbumAlertCaptionText,
                         message: newAlbumAlertMessageText,
                         keyboardType: .default) { result in
                addAlbum(result: result)
               })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(albumTitleText)
        .navigationBarItems(trailing: Button(action: { askAlbumName = true },
                                             label: { Image(systemName: plusCircleSymbol)
                                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                             }))
    }

    func addAlbum(result: String?) {
        if result != nil {
            for eachAlbum in albums where eachAlbum.name == result {
                    self.albumPresentAlready = true
            }
            if !self.albumPresentAlready {
                let mainAlbum = Albums(context: viewContext)
                mainAlbum.name = result
                if viewContext.hasChanges {
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
    }
}

struct JustEntry_Previews: PreviewProvider {
    static var previews: some View {
        JustEntry().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

