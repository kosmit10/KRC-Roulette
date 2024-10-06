import SwiftUI

struct home: View {
    @State private var moveLogoToTop = false
    @State private var buttons = false

    var body: some View {
        ZStack {
            Image("background_home")
                .resizable()
                .ignoresSafeArea()

            Color.black.opacity(0.4)
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
                VStack(spacing: 5) {
                    Button(action: {
                        
                    }) {
                        ZStack {
                            Image("button-pocker")
                                .scaledToFit()
                                .frame(width: 350, height: 100)
                        }
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image("button-blackjack")
                            .scaledToFit()
                            .frame(width: 350, height: 100)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image("button-jackpot")
                            .scaledToFit()
                            .frame(width: 350, height: 100)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image("button-roullete")
                            .scaledToFit()
                            .frame(width: 350, height: 100)
                    }
                }
                .padding(.top, 80.0)
                .offset(y: buttons ? 0 : UIScreen.main.bounds.height)
                .animation(.spring(response: 1.6, dampingFraction: 1.7, blendDuration: 1.3), value: buttons)
                .transition(.move(edge: .bottom))
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    home()
}
