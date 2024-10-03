import SwiftUI
import Lottie

struct ContentView: View {
    @State private var showLottieAnimation = true
    @State private var isLoginViewPresented = false
    @State private var buttonOffset: CGFloat = 0
    @State private var imageOffset: CGFloat = 0
    @State private var textOffset: CGFloat = 0

    var body: some View {
            ZStack {
                Color(.black)
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
                                .frame(width: 150, height: 150)
                                .scaleEffect(1)
                                .padding(.bottom, 30.0)
                                
                        } else {
                            Image(systemName: "arrowshape.turn.up.right.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
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
