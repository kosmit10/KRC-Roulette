import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct jackpot: View {
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
                                                    Text("Saldo:")
                                                    Text(" \(balance)$")
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
        .navigationBarBackButtonHidden()
        .onAppear {
            resetOffsets()
            loadUserProfile()
            fetchUserBalance()
        }
    }

    // Pobieranie zdjęcia profilowego i balansu z Firebase
    func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
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
            if let document = document, document.exists {
                if let userBalance = document.data()?["balance"] as? Int64 {
                    balance = userBalance
                } else if let userBalance = document.data()?["balance"] as? Int {
                    // Rzutowanie na 'Int64', jeśli dane w Firestore są w typie 'Int'
                    balance = Int64(userBalance)
                }
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

    // Funkcja do rozpoczęcia kręcenia
    func startSpinning() {
        isSpinning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.spinSymbols()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopSpinning()
        }
    }

    // Losowanie symboli z płynnością animacji
    func spinSymbols() {
        for i in 0..<3 {
            // Dodaj losowe opóźnienie do zmiany symbolu
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    results[i] = Int.random(in: 0..<symbols.count)
                }
            }
        }
    }

    // Zatrzymanie kręcenia i obliczanie wyniku
    func stopSpinning() {
        timer?.invalidate()
        isSpinning = false
        calculateResult()
    }

    // Obliczenie wyniku na podstawie wylosowanych symboli
    func calculateResult() {
        let winnings = results.filter { $0 == results.first }.count == 3 ? 100 : -50
        
        // Rzutowanie wyniku na 'Int64'
        updateUserBalance(by: winnings)
    }

    // Resetowanie przesunięć
    func resetOffsets() {
        for i in 0..<3 {
            offsets[i] = 0
        }
    }
}

#Preview {
    jackpot()
}

