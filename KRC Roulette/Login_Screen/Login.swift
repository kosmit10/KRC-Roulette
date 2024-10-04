//
//  Login.swift
//  KRC Roulette
//
//  Created by maciura on 03/10/24.
//

import SwiftUI

struct Login: View {
    var body: some View {
        ZStack{
            Image("background_login")
                .padding()
            ZStack {
                Image("Login-screen")
                    .resizable()
                    .frame(width: 370, height: 270)
                VStack{
                    VStack {
                        ZStack{
                            Image("pass-mail")
                                .resizable()
                                .frame(width: 180, height: 50)
                        }
                        ZStack{
                            Image("pass-mail")
                                .resizable()
                                .frame(width: 180, height: 50)
                        }
                        
                    }
                    .padding(.leading, 120.0)
                    .padding(.top, 110.0)
                HStack{
                    Button(action: {
                        
                    }){
                        Image("button-login")
                            .resizable()
                            .frame(width: 150, height: 40)
                        }
                    Button(action: {
                        
                    }){
                        Image("button-register")
                            .resizable()
                            .frame(width: 150, height: 40)
                        }
                    }
                .padding(.bottom, 70.0)
                }
                .padding()
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Login()
}
