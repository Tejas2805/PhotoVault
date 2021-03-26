//
//  SaveImage.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI
import UIKit

struct SaveImage: View {

    @Environment(\.managedObjectContext) var viewContext

    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var imageSaved = false
    @State var albumName: String
    @FetchRequest(
        entity: Albums.entity(),
        sortDescriptors: []
    ) var albums: FetchedResults<Albums>

    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .imageIconModifier(width: 300, height: 300)
            } else {
                Image(systemName: snowSymbol)
                    .imageIconModifier(width: 300, height: 300)
            }
            Button(openCameraText) {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }.padding()
            Button(openLibraryText) {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }.padding()
            if selectedImage != nil {
                Button(action: {
                    let pickedImage = selectedImage?.jpegData(compressionQuality: 1.0)
                    let saveImage = ImgCore(context: viewContext)
                    saveImage.img = pickedImage
                    saveImage.album = albumName
                    imageSaved = true
                    updateAlbumState(image: pickedImage!)
                    if viewContext.hasChanges {
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }, label: { Text(saveImageTitleText)
                    .padding()
                })
            }
        }
        .alert(isPresented: $imageSaved) {
            Alert(title: Text(imagedSavedAlertCaptionText), dismissButton: .default(Text(understoodAlertText)))
        }
        .navigationBarTitle(saveImageTitleText)
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
    }

    func updateAlbumState(image: Data) {
        for eachAlbum in albums where eachAlbum.name == albumName {
            viewContext.performAndWait {
                eachAlbum.present = true
                eachAlbum.img = image
            }
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

struct SaveImage_Previews: PreviewProvider {
    static var previews: some View {
        SaveImage(albumName: "Main")
            .environment(\.managedObjectContext,
                         PersistenceController.preview.container.viewContext)
    }
}
