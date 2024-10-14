import SwiftUI

struct jackpot: View {
    @State private var symbols = ["bild", "bonus", "clubs", "diamons", "hearts", "spades", "wild"]
    @State private var isSpinning = false
    @State private var offsets = [CGFloat](repeating: 0, count: 3)
    @State private var leverPulled = false
    @State private var results = [Int](repeating: 0, count: 3) // Zawiera indeks losowych symboli dla każdego bębna
    @State private var timer: Timer? // Timer do animacji

    var body: some View {
        ZStack {
            Color(.black)
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
                            
                            ZStack {
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
                    .padding()
                }
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .onAppear {
            resetOffsets()
        }
    }

    // Funkcja do wyzerowania offsetów na początku
    func resetOffsets() {
        offsets = [0, 0, 0]
    }

    // Rozpoczęcie kręcenia symbolami
    func startSpinning() {
        isSpinning = true
        let duration = 0.05

        // Losowe wyniki dla każdego bębna
        results = results.map { _ in Int.random(in: 0..<symbols.count) }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
            for index in 0..<offsets.count {
                offsets[index] -= 30
                if offsets[index] <= -CGFloat(symbols.count * 90) {
                    offsets[index] = 0
                }
            }
        }

        // Zatrzymanie kręcenia po 3 sekundach
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            stopSpinning()
        }
    }

    // Zatrzymanie kręcenia i wyrównanie bębnów
    func stopSpinning() {
        timer?.invalidate()
        timer = nil
        isSpinning = false

        for index in 0..<offsets.count {
            let remainder = offsets[index].truncatingRemainder(dividingBy: 90)
            let adjustment = remainder > 45 ? (90 - remainder) : -remainder
            withAnimation(.easeOut(duration: 0.5)) {
                offsets[index] += adjustment
            }
        }
    }
}

#Preview {
    jackpot()
}
