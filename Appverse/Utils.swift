//
//  Utils.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import Foundation
import SwiftUI
import UIKit

let defaults = UserDefaults.standard
let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
let purpleBackground = LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)

struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        HStack {
            Image(systemName: personSymbol)
                .foregroundColor(.secondary)
            TextField(usernameText, text: $username)
        }
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    @Binding var passwordHidden: Bool
    var placeHolder: String
    var body: some View {
        HStack {
            Button(action: { passwordHidden.toggle() }, label: {
                Image(systemName: closedEyeSymbol)
                    .foregroundColor(.secondary)
            })
            SecureField(placeHolder, text: $password)
        }
        .cornerRadius(5.0)
        .padding()
        .background(Color.white)
        .padding(.bottom, 20)
    }
}

struct PasswordTextField: View {
    @Binding var password: String
    @Binding var passwordHidden: Bool
    var placeHolder: String
    var body: some View {
        HStack {
            Button(action: {
                passwordHidden.toggle()
            }, label: {
                Image(systemName: eyeSymbol)
                    .foregroundColor(.secondary)
            })
            TextField(placeHolder, text: $password)
        }
        .cornerRadius(5.0)
        .padding()
        .background(Color.white)
        .padding(.bottom, 20)
    }
}

struct GridButton: View {
    @Binding var gridLayout: [GridItem]
    var body: some View {
        Button(action: {
            self.gridLayout = Array(repeating: .init(.flexible()), count: self.gridLayout.count % 4 + 1)
        }, label: { Image(systemName: gridSymbol)
            .font(.title)
            .foregroundColor(.blue)
        })
    }
}

struct CaptionText: View {
    var caption: String
    var body: some View {
        Text(caption)
            .font(.largeTitle)
            .fontWeight(.semibold)
    }
}

struct ConnectButton: View {
    var buttonContent: String
    var body: some View {
        return Text(buttonContent)
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .cornerRadius(15.0)
    }
}

struct VaultImage: View {
    var body: some View {
        Image(vaultImage)
            .imageIconModifier(width: 200, height: 200)
    }
}

struct AlbumToolbarView: View {

    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(
        entity: Albums.entity(),
        sortDescriptors: []
    ) var albums: FetchedResults<Albums>
    @FetchRequest(
        entity: ImgCore.entity(),
        sortDescriptors: []
    ) var imgs: FetchedResults<ImgCore>
    @State private var selection: String?
    @State private var shouldDeleteAlbum = false
    var geometry: GeometryProxy
    var albumName: String
    var albumIndex: Int

    var body: some View {
        NavigationLink(destination: SaveImage( albumName: albumName), tag: saveImageTag, selection: $selection) {
            EmptyView()
        }
        NavigationLink(destination: JustEntry(), tag: justEntryTag, selection: $selection) {
            EmptyView()
        }
        HStack {
            Spacer()
            Button(action: { self.selection = saveImageTag },
                   label: { AddPhotoContent() })
            Spacer()
            Button(action: {
                shouldDeleteAlbum = true
            }, label: {
                Image(systemName: trashSymbol)
            })
            Spacer()
        }
        .alert(isPresented: $shouldDeleteAlbum) {
            Alert(
                title: Text(deleteAlbumAlertCaptionText),
                message: Text(deleteAnyAlertMessageText),
                primaryButton: .destructive(Text(deleteText)) {
                    deleteAlbum(albumName: albumName)
                    deleteImages(albumName: albumName)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .frame(width: geometry.size.width, height: geometry.size.height/8)
        .background(lightGreyColor)
    }

    func deleteAlbum(albumName: String) {

        for eachAlbum in albums where eachAlbum.name == albumName {
            viewContext.delete(eachAlbum)
        }
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func deleteImages(albumName: String) {

        for eachImage in imgs where eachImage.album == albumName {
            viewContext.delete(eachImage)
        }
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

struct AddPhotoContent: View {
    var body: some View {
        Text(addPhotosText)
            .font(.headline)
            .foregroundColor(.blue)
            .background(lightGreyColor)
    }
}

struct RegularText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.regular)
            .foregroundColor(Color.black)
    }
}

struct ConnectFailedText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.title2)
            .offset(y: -10)
            .foregroundColor(.red)
    }
}

extension Image {
    func imageIconModifier(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: width, height: height)
    }

    func imageGridModifier(gridLayout: [GridItem]) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: gridLayout.count == 1 ? 200 : 100)
            .cornerRadius(10)
            .shadow(color: Color.primary.opacity(0.3), radius: 1)
    }
}

