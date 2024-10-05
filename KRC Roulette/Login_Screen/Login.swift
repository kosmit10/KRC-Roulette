import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct Login: View {
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var wrongUsername = false
    @State private var wrongPassword = false
    @State private var showingLoginscreen = false
    @State private var isLoginScreenActive = false
    @State private var isregisterscreenPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Image("background_login")
                Color.black.opacity(0.3)
                    .scaledToFit()
                    .padding()
                ZStack {
                    Image("Login-screen")
                        .resizable()
                        .frame(width: 370, height: 270)
                    Color.black.opacity(0.1)

                    VStack {
                        VStack {
                            ZStack {
                                Image("pass-mail")
                                    .resizable()
                                    .frame(width: 180, height: 50)
                                    .aspectRatio(contentMode: .fill)
                                
                                TextField("", text: $username)
                                    .autocapitalization(.sentences)
                                    .disableAutocorrection(true)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 180, height: 50)
                                    .border(wrongUsername ? Color.red : Color.clear)
                            }
                            ZStack {
                                Image("pass-mail")
                                    .resizable()
                                    .frame(width: 180, height: 50)
                                    .aspectRatio(contentMode: .fill)
                                SecureField("", text: $password)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 180, height: 50)
                                    .border(wrongPassword ? Color.red : Color.clear)
                            }
                        }
                        .padding(.leading, 120.0)
                        .padding(.top, 50.0)
                        HStack {
                            Button(action: {
                                login()
                            }) {
                                Image("button-login")
                                    .resizable()
                                    .frame(width: 150, height: 40)
                            }
                            Button(action: {
                                register()
                            }) {
                                Image("button-register")
                                    .resizable()
                                    .frame(width: 150, height: 40)
                            }
                        }
                        .padding()
                    }
                    .padding()
                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)

                }
                NavigationLink(destination: home().transition(.move(edge: .trailing)), isActive: $isLoginScreenActive) {
                    EmptyView()
                }
                .animation(.easeInOut)

            }
            .ignoresSafeArea()

        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func login() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Please enter both username and password."
            showAlert = true
            return
        }

        if !username.contains("@") {
            alertMessage = "Username must be an email address."
            showAlert = true
            return
        }

        print("Attempting to log in with email: \(username)")

        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error = error {
                alertMessage = "Login failed: \(error.localizedDescription)"
                print("Login failed with error: \(error.localizedDescription)")
                showAlert = true
                return
            }
            
           
            print("Login successful!")
            isLoginScreenActive = true
        }
    }



    func register() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Please enter both username and password."
            showAlert = true
            return
        }

        if !username.contains("@") {
            alertMessage = "Username must be an email address."
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                alertMessage = "Account successfully created! Please log in."
                showAlert = true
            }
        }
    }
}

#Preview {
    Login()
}

