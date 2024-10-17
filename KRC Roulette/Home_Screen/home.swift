import SwiftUI

struct home: View {
    @State private var moveLogoToTop = false
    @State private var buttons = false
    @State private var isJackpotViewActive = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("background_home")
                    .resizable()
                    .ignoresSafeArea()

                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                Image("casinologo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .offset(y: moveLogoToTop ? -UIScreen.main.bounds.height / 2.3 + 100 : 0)
                    .animation(.easeInOut(duration: 1), value: moveLogoToTop)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            moveLogoToTop = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            buttons = true
                        }
                    }

                if buttons {
                    ZStack {
                        Image("window-home")
                            .resizable()
                            .frame(width: 400, height: 450)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<4) { index in
                                    VStack {
                                        Image(index == 0 ? "game1" : index == 1 ? "game2" : index == 2 ? "game3" : "game4")
                                            .resizable()
                                            .frame(width: 200, height: 280)
                                            .padding(.bottom, 50.0)
                                        
                                        if index == 0 {
                                            NavigationLink(destination: jackpot(), isActive: $isJackpotViewActive) {
                                                Button(action: {
                                                    isJackpotViewActive = true
                                                }) {
                                                    Image("button_jackpot")
                                                        .resizable()
                                                        .frame(width: 160, height: 40)
                                                        .padding(.top, -30.0)
                                                }
                                            }
                                        } else {
                                            Button(action: {
                                                // Akcja dla innych gier
                                            }) {
                                                Image(index == 1 ? "button_roullete" : index == 2 ? "button_poker" : "button_blackjack")
                                                    .resizable()
                                                    .frame(width: 160, height: 40)
                                                    .padding(.top, -30.0)
                                            }
                                        }
                                    }
                                    .frame(width: 180, height: 430)
                                }
                            }
                        }
                        .padding()
                        .frame(width: 370, height: 420)
                        .animation(.spring(response: 1.6, dampingFraction: 1.7, blendDuration: 1.3), value: buttons)
                    }
                    .padding(.top, 150.0)
                    .offset(y: buttons ? 0 : UIScreen.main.bounds.height)
                    .animation(.spring(response: 1.6, dampingFraction: 1.7, blendDuration: 1.3), value: buttons)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//struct JackpotView: View {
//    var body: some View {
//        Text("Jackpot View")
//            .font(.largeTitle)
//            .padding()
//    }
//}

#Preview {
    home()
}

