//
//  LoginScreen.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI
import CoreData

struct LoginScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var username: String = ""
    @State var password: String = ""
    @State var authenticationFailed: Bool = false
    @State var passwordHidden: Bool = true
    let mainUsername = defaults.string(forKey: usernameText) ?? ""
    let mainPassword = defaults.string(forKey: passwordText) ?? ""
    @State private var selection: String?

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                   Group {
                        NavigationLink(destination: SignUp(), tag: signUpTag, selection: $selection) {
                            EmptyView()
                        }
                        NavigationLink(destination: JustEntry(), tag: justEntryTag, selection: $selection) {
                            EmptyView()
                        }
                        CaptionText(caption: welcomeCaptionText )
                        Spacer()
                        VaultImage()
                        Spacer()
                   }
                    UsernameTextField(username: $username)
                    if self.passwordHidden {
                        PasswordSecureField(password: $password,
                                            passwordHidden: $passwordHidden, placeHolder: passwordText)
                    } else {
                        PasswordTextField(password: $password, passwordHidden: $passwordHidden,
                                          placeHolder: passwordText)
                    }
                    Button(action: {
                         if self.username == mainUsername && self.password == mainPassword {
                            self.selection = justEntryTag
                        } else {
                            self.authenticationFailed = true
                        }
                    }, label: { ConnectButton(buttonContent: loginText) })
                    if authenticationFailed {
                        ConnectFailedText(text: loginFailedText)
                    }
                    Spacer()
                    Button(action: { self.selection = signUpTag }, label: {
                        RegularText(text: signUpText)
                    })
                }
                .padding()
                .background(purpleBackground
                    .edgesIgnoringSafeArea(.all))
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

