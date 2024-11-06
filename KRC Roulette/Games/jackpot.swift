import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct jackpot: View {
    @State private var showLottieAnimation = true
    @State private var symbols = ["bild", "bonus", "clubs", "diamons", "hearts", "spades", "wild"]
    @State private var isSpinning = false
    @State private var offsets = [CGFloat](repeating: 0, count: 3)
    @State private var leverPulled = false
    @State private var results = [Int](repeating: 0, count: 3)
    @State private var timer: Timer?
    @State private var balance: Int64 = 1000
    @State private var userProfileImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color(.black)
            VStack {
                if let profileImage = userProfileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding()
                }
                ZStack {
                    Image("background_jackpot2")
                        .resizable()
                        .frame(width: 450, height: 900)
                        .padding()
                        .ignoresSafeArea()
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()

                    ZStack {
                        VStack {
                            Image("baner")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .padding(.bottom, -60.0)

                            ZStack {
                                Image("background_jackpot")
                                    .resizable()
                                    .frame(width: 450, height: 650)
                                    .padding()
                                
                                VStack {
                                    ZStack {
                                        ZStack {
                                            Image("window-jackpot")
                                                .resizable()
                                                .frame(width: 300, height: 120)
                                                .padding()
                                            HStack {
                                                Image("worek")
                                                    .resizable()
                                                    .frame(width: 70, height: 90)
                                                VStack {
                                                    if showLottieAnimation {
                                                        LottieView(animationName: "loading")
                                                            .frame(width: 100, height: 100)
                                                            .scaleEffect(1)
                                                            .padding(.bottom, 30.0)
                                                    } else {
                                                        Text("Saldo:")
                                                        Text(" \(balance)$") // Wyświetlenie salda po animacji
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.top, -250.0)

                                        HStack {
                                            ForEach(0..<3) { index in
                                                VStack {
                                                    Image(symbols[results[index] % symbols.count])
                                                        .resizable()
                                                        .frame(width: 50, height: 90)
                                                }
                                                .frame(height: 90)
                                                .clipped()
                                            }
                                        }
                                        .padding(.top, 50.0)
                                        .padding(.trailing, 8.0)
                                        
                                        HStack {
                                            Image("spin_cut")
                                                .resizable()
                                                .frame(width: 400, height: 400)
                                                .padding([.bottom, .trailing], -80.0)
                                            
                                            Image("raczka")
                                                .resizable()
                                                .frame(width: 30, height: 200)
                                                .padding(.leading, -5.0)
                                                .rotation3DEffect(
                                                    .degrees(leverPulled ? -30 : 0),
                                                    axis: (x: 1, y: 0, z: 0),
                                                    anchor: .bottom,
                                                    perspective: 0.5
                                                )
                                                .gesture(
                                                    DragGesture()
                                                        .onChanged { _ in
                                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                                leverPulled = true
                                                            }
                                                        }
                                                        .onEnded { _ in
                                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                                leverPulled = false
                                                            }
                                                            startSpinning()
                                                        }
                                                )
                                        }
                                        .padding([.top, .trailing], 40.0)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            resetOffsets()
            loadUserProfile()
            fetchUserBalance()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showLottieAnimation = false
            }
        }
    }

    func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Błąd pobierania obrazu profilowego: \(error.localizedDescription)")
                }
                if let data = data, let image = UIImage(data: data) {
                    userProfileImage = image
                }
            }
        }
    }

    func fetchUserBalance() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Błąd pobierania balansu: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                if let userBalance = document.data()?["balance"] as? Int64 {
                    balance = userBalance
                } else if let userBalance = document.data()?["balance"] as? Int {
                    balance = Int64(userBalance)
                }
            } else {
                // Stwórz dokument, jeśli go nie ma
                db.collection("users").document(userId).setData(["balance": balance]) { error in
                    if let error = error {
                        print("Błąd tworzenia dokumentu: \(error.localizedDescription)")
                    }
                }
            }
            // Wyłącz animację, gdy dane balansu zostaną pobrane
            DispatchQueue.main.async {
                showLottieAnimation = false
            }
        }
    }

    func updateUserBalance(by amount: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // Rzutowanie 'amount' na 'Int64' i dodanie go do balansu
        balance += Int64(amount)
        
        // Aktualizacja balansu w Firebase
        db.collection("users").document(userId).updateData(["balance": balance])
    }

    func startSpinning() {
        isSpinning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.spinSymbols()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopSpinning()
        }
    }

    func spinSymbols() {
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    results[i] = Int.random(in: 0..<symbols.count)
                }
            }
        }
    }

    func stopSpinning() {
        timer?.invalidate()
        isSpinning = false
        calculateResult()
    }

    func calculateResult() {
        let uniqueSymbols = Set(results)
        var winnings = 0

        if uniqueSymbols.count == 1 {
            winnings = 200
        } else if uniqueSymbols.count == 2 {
            winnings = 50
        } else {
            winnings = -50
        }

        if results.allSatisfy({ symbols[$0] == "wild" }) || results.allSatisfy({ symbols[$0] == "bonus" }) {
            winnings += 300
        }

        updateUserBalance(by: winnings)
    }

    func resetOffsets() {
        for i in 0..<3 {
            offsets[i] = 0
        }
    }
}

#Preview {
    jackpot()
}
