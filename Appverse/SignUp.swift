//
//  SignUp.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI

struct SignUp: View {

    @State var username: String = ""
    @State var password: String = ""
    @State var passwordHidden: Bool = true
    @State var confirmPasswordHidden: Bool = true
    @State var incorrectCredentials: Bool = false
    @State var confirmPassword: String = ""
    @State private var selection: String?

    var body: some View {
        ZStack {
            VStack {
                NavigationLink(destination: LoginScreen(), tag: loginTag, selection: $selection) {
                    EmptyView()
                }
                Group {
                    HStack {
                        Button(action: {
                            self.selection = loginTag
                        }, label: {
                            Image(backButtonImage)
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .topLeading)
                                .foregroundColor(.black)
                        })
                        Spacer()
                        CaptionText(caption: signUpCaptionText)
                        Spacer()
                    }
                    Spacer()
                    VaultImage()
                    Spacer()
                    UsernameTextField(username: $username)
                    if self.passwordHidden {
                        PasswordSecureField(password: $password,
                                            passwordHidden: $passwordHidden, placeHolder: passwordText)
                        PasswordSecureField(password: $confirmPassword, passwordHidden:
                                                $passwordHidden, placeHolder: confirmPasswordText)
                    } else {
                        PasswordTextField(password: $password, passwordHidden: $passwordHidden,
                                          placeHolder: passwordText)
                        PasswordTextField(password: $confirmPassword, passwordHidden:
                                            $passwordHidden, placeHolder: confirmPasswordText)
                    }
                    Button(action: {
                        if self.confirmPassword == self.password && self.username != "" {
                            defaults.set(self.username, forKey: usernameText)
                            defaults.set(self.password, forKey: passwordText)
                            self.selection = loginTag
                        } else {
                            incorrectCredentials = true
                        }
                    }, label: { ConnectButton(buttonContent: registerText)
                    })
                    if incorrectCredentials {
                        ConnectFailedText(text: signUpFailedText)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(purpleBackground
                .edgesIgnoringSafeArea(.all))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

