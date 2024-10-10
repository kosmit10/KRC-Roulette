import SwiftUI
import Lottie

// Rozszerzenie dla View do zaokrąglania rogów
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = []

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ContentView: View {
    @State private var showLottieAnimation = true
    @State private var isLoginViewPresented = false
    @State private var buttonOffset: CGFloat = 0
    @State private var imageOffset: CGFloat = 0
    @State private var textOffset: CGFloat = 0
    @State private var showShadow = false
    
    var body: some View {
        ZStack {
            Image("background_home")
                .resizable()
                .ignoresSafeArea()
                .frame(width: 500, height: 900)
            Color.black.opacity(0.7)
            if showShadow {
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.white.opacity(0.001)]), startPoint: .bottom, endPoint: .top)
                    .frame(height: UIScreen.main.bounds.height / 1)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .offset(y: UIScreen.main.bounds.height / 2)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showShadow)
            }
            VStack {
                Image("casinologo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .offset(x: imageOffset)
                    .animation(.easeInOut(duration: 1), value: imageOffset)
                    .padding(.all)
                
                Button(action: {
                    withAnimation {
                        isLoginViewPresented = true
                    }
                }) {
                    if showLottieAnimation {
                        LottieView(animationName: "loading")
                            .frame(width: 200, height: 200) // Zwiększony rozmiar
                            .scaleEffect(1)
                            .padding(.bottom, 30.0)
                    } else {
                        Image(systemName: "arrowshape.turn.up.right.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 50)) // Zwiększony rozmiar
                    }
                }
                .padding(.bottom, 30.0)
                .offset(y: buttonOffset)
                .animation(.easeInOut(duration: 1), value: buttonOffset)
                
              
            }
            .padding()
            
            
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                imageOffset = 0
                textOffset = 0
                buttonOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation {
                    showLottieAnimation = false
                    showShadow = true // Po zakończeniu animacji, pokaż cień
                }
            }
        }
        .fullScreenCover(isPresented: $isLoginViewPresented, content: {
            Login()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isLoginViewPresented)
        })
    }
}

#Preview {
    ContentView()
}
